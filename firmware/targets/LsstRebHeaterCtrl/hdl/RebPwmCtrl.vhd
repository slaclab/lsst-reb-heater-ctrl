-------------------------------------------------------------------------------
-- Title      : 
-------------------------------------------------------------------------------
-- Company    : SLAC National Accelerator Laboratory
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- This file is part of LSST. It is subject to
-- the license terms in the LICENSE.txt file found in the top-level directory
-- of this distribution and at:
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
-- No part of LSST, including this file, may be
-- copied, modified, propagated, or distributed except according to the terms
-- contained in the LICENSE.txt file.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;

entity RebPwmCtrl is

   generic (
      TPD_G : time := 1 ns);

   port (
      clk200          : in  sl;
      rst200          : in  sl;
      axilReadMaster  : in  AxiLiteReadMasterType;
      axilReadSlave   : out AxiLiteReadSlaveType;
      axilWriteMaster : in  AxiLiteWriteMasterType;
      axilWriteSlave  : out AxiLiteWriteSlaveType;

      outputEn : out slv(11 downto 0);
      pwm      : out slv(11 downto 0));

end entity RebPwmCtrl;

architecture rtl of RebPwmCtrl is

   type RegType is record
      clkDivRst      : slv(11 downto 0);
      highCount      : slv8Array(11 downto 0);
      lowCount       : slv8Array(11 downto 0);
      delayCount     : slv8Array(11 downto 0);
      highCountTmp   : slv8Array(11 downto 0);
      lowCountTmp    : slv8Array(11 downto 0);
      delayCountTmp  : slv8Array(11 downto 0);
      channelChanged : slv(11 downto 0);
      syncCount      : slv(7 downto 0);
      syncPulse      : sl;
      outputEn       : slv(11 downto 0);
      axilReadSlave  : AxiLiteReadSlaveType;
      axilWriteSlave : AxiLiteWriteSlaveType;
   end record RegType;

   constant REG_INIT_C : RegType := (
      clkDivRst      => (others => '0'),
      highCount      => (others => (others => '0')),
      lowCount       => (others => (others => '0')),
      delayCount     => (others => (others => '0')),
      highCountTmp   => (others => (others => '0')),
      lowCountTmp    => (others => (others => '0')),
      delayCountTmp  => (others => (others => '0')),
      channelChanged => (others => '0'),
      syncCount      => (others => '0'),
      syncPulse      => '0',
      outputEn       => (others => '0'),
      axilReadSlave  => AXI_LITE_READ_SLAVE_INIT_C,
      axilWriteSlave => AXI_LITE_WRITE_SLAVE_INIT_C);

   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;

begin

   PWM_GEN : for i in 11 downto 0 generate
      U_ClockDivider_1 : entity work.ClockDivider
         generic map (
            TPD_G         => TPD_G,
            COUNT_WIDTH_G => 8)
         port map (
            clk        => clk200,           -- [in]
            rst        => r.clkDivRst(i),   -- [in]
            highCount  => r.highCount(i),   -- [in]
            lowCount   => r.lowCount(i),    -- [in]
            delayCount => r.delayCount(i),  -- [in]
            divClk     => pwm(i));          -- [out]
   end generate PWM_GEN;

   comb : process (axilReadMaster, axilWriteMaster, r, rst200) is
      variable v      : RegType;
      variable axilEp : AxiLiteEndpointType;
   begin
      -- Latch the current value
      v := r;

      -- Establish a sync pulse at 400 kHz
      v.syncPulse := '0';
      v.syncCount := r.syncCount + 1;
      if (r.syncCount = 499) then
         v.syncCount := (others => '0');
         v.syncPulse := '1';
      end if;

      -- Check for changed values every syncPulse and update PWMs if necessary
      v.clkDivRst := (others => '0');
      if (r.syncPulse = '1') then
         for i in 0 to 11 loop
            if (r.channelChanged(i) = '1') then
               v.highCount(i)  := r.highCountTmp(i);
               v.lowCount(i)   := r.lowCountTmp(i);
               v.delayCount(i) := r.delayCountTmp(i);
               v.clkDivRst(i)  := '1';
            end if;
         end loop;
      end if;


      ----------------------------------------------------------------------------------------------
      -- AXI Lite
      ----------------------------------------------------------------------------------------------
      axiSlaveWaitTxn(axilEp, axilWriteMaster, axilReadMaster, v.axilWriteSlave, v.axilReadSlave);

      for i in 0 to 11 loop
         axiSlaveRegister(axilEp, toSlv(i*4, 8), 0, v.highCountTmp(i));
         axiSlaveRegister(axilEp, toSlv(i*4, 8), 9, v.lowCountTmp(i));
         axiSlaveRegister(axilEp, toSlv(i*4, 8), 18, v.delayCountTmp(i));
         axiSlaveRegister(axilEp, toSlv(i*4, 8), 27, v.outputEn(i));
         axiSlaveRegister(axilEp, toSlv(i*4, 8), 31, v.channelChanged(i), '1');
      end loop;

      -- Readback registers for sanity checking
      for i in 0 to 11 loop
         axiSlaveRegisterR(axilEp, toSlv((i+12)*4, 8), 0, r.highCount(i));
         axiSlaveRegisterR(axilEp, toSlv((i+12)*4, 8), 9, r.lowCount(i));
         axiSlaveRegisterR(axilEp, toSlv((i+12)*4, 8), 18, r.delayCount(i));
      end loop;

      axiSlaveDefault(axilEp, v.axilWriteSlave, v.axilReadSlave, AXI_RESP_DECERR_C);
      ----------------------------------------------------------------------------------------------

      if (rst200 = '1') then
         v := REG_INIT_C;
      end if;

      rin <= v;

      outputEn       <= r.outputEn;
      axilWriteSlave <= r.axilWriteSlave;
      axilReadSlave  <= r.axilReadSlave;
   end process;

   seq : process (clk200) is
   begin
      if (rising_edge(clk200)) then
         r <= rin after TPD_G;
      end if;
   end process seq;

end architecture rtl;
