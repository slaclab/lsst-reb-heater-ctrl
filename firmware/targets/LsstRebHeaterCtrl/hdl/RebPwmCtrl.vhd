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

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;

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

      cryoEn      : in  sl;
      coldplateEn : in  sl;
      outputEn    : out slv(11 downto 0);
      pwm         : out slv(11 downto 0));

end entity RebPwmCtrl;

architecture rtl of RebPwmCtrl is

   type RegType is record
      clkDivRst      : slv(11 downto 0);
      highCount      : slv9Array(11 downto 0);
      lowCount       : slv9Array(11 downto 0);
      delayCount     : slv9Array(11 downto 0);
      highCountTmp   : slv9Array(11 downto 0);
      lowCountTmp    : slv9Array(11 downto 0);
      delayCountTmp  : slv9Array(11 downto 0);
      alignChannel   : slv(11 downto 0);
      syncCount      : slv(11 downto 0);
      syncPulse      : sl;
      outputEn       : slv(11 downto 0);
      outputEnTmp    : slv(11 downto 0);
      axilReadSlave  : AxiLiteReadSlaveType;
      axilWriteSlave : AxiLiteWriteSlaveType;
   end record RegType;

   constant REG_INIT_C : RegType := (
      clkDivRst      => (others => '0'),
      highCount      => (others => toSlv(249, 9)),
      lowCount       => (others => toslv(249, 9)),
      delayCount     => (others => (others => '0')),
      highCountTmp   => (others => toSlv(249, 9)),
      lowCountTmp    => (others => toSlv(249, 9)),
      delayCountTmp  => (others => (others => '0')),
      alignChannel   => (others => '0'),
      syncCount      => (others => '0'),
      syncPulse      => '0',
      outputEn       => (others => '0'),
      outputEnTmp    => (others => '0'),
      axilReadSlave  => AXI_LITE_READ_SLAVE_INIT_C,
      axilWriteSlave => AXI_LITE_WRITE_SLAVE_INIT_C);

   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;

   signal preRise : slv(11 downto 0);
   signal preFall : slv(11 downto 0);

begin

   PWM_GEN : for i in 11 downto 0 generate
      U_ClockDivider_1 : entity surf.ClockDivider
         generic map (
            TPD_G         => TPD_G,
            COUNT_WIDTH_G => 9)
         port map (
            clk        => clk200,           -- [in]
            rst        => r.clkDivRst(i),   -- [in]
            highCount  => r.highCount(i),   -- [in]
            lowCount   => r.lowCount(i),    -- [in]
            delayCount => r.delayCount(i),  -- [in]
            divClk     => pwm(i),           -- [out]
            preRise    => preRise(i),       -- [out]
            preFall    => preFall(i));      -- [out]
   end generate PWM_GEN;

   comb : process (axilReadMaster, axilWriteMaster, coldplateEn, cryoEn, preFall, r, rst200) is
      variable v      : RegType;
      variable axilEp : AxiLiteEndpointType;
   begin
      -- Latch the current value
      v := r;

      -- Assert reset as pwm falls
      for i in 0 to 11 loop
         if (r.alignChannel(i) = '1' and preFall(i) = '1') then
            v.clkDivRst(i) := '1';
         end if;
      end loop;

      -- Release all resets one all channels being aligned have been reset
      if (uOr(r.alignChannel) = '1' and uOr(r.alignChannel xor r.clkDivRst) = '0') then
         v.syncCount := r.syncCount + 1;
      end if;

      if (r.syncCount = 499) then
         v.clkDivRst    := (others => '0');
         v.alignChannel := (others => '0');
         v.syncCount    := (others => '0');
      end if;


      -- Keep pwms off by holding in resent when outputEn = 0
--       for i in 0 to 11 loop
--          if (r.outputEn(i) = '0') then
--             v.clkDivRst(i) := '1';
--          end if;
--       end loop;


      ----------------------------------------------------------------------------------------------
      -- AXI Lite
      ----------------------------------------------------------------------------------------------
      axiSlaveWaitTxn(axilEp, axilWriteMaster, axilReadMaster, v.axilWriteSlave, v.axilReadSlave);

      for i in 0 to 11 loop
         axiSlaveRegister(axilEp, toSlv(i*8, 8), 0, v.highCountTmp(i));
         axiSlaveRegister(axilEp, toSlv(i*8, 8), 9, v.lowCountTmp(i));
         axiSlaveRegister(axilEp, toSlv(i*8, 8), 18, v.delayCountTmp(i));
         axiSlaveRegister(axilEp, toSlv(i*8, 8), 27, v.outputEnTmp(i));
--         axiWrDetect(axilEp, toSlv(i*8, 8), v.alignChannel(i));
         -- Readback registers for sanity checking         
         axiSlaveRegisterR(axilEp, toSlv((i*8)+4, 8), 0, r.highCount(i));
         axiSlaveRegisterR(axilEp, toSlv((i*8)+4, 8), 9, r.lowCount(i));
         axiSlaveRegisterR(axilEp, toSlv((i*8)+4, 8), 18, r.delayCount(i));

         -- Interlocks override outputEn
         if (i >= 0 and i <= 5) and cryoEn = '0' then
            v.outputEnTmp(i) := '0';
         end if;

         if ((i >= 6 and i <= 11) and coldplateEn = '0') then
            v.outputEnTmp(i) := '0';
         end if;

--          -- Don't allow frequencies above 2 MHz
--          if (v.highCountTmp(i) + v.lowCountTmp(i) < 98) then
--             v.highCountTmp(i)      := r.highCountTmp(i);
--             v.lowCountTmp(i)       := r.lowCountTmp(i);
--             v.axilWriteSlave.bresp := AXI_RESP_SLVERR_C;
--          end if;

--          -- Don't allow frequencies below 400kHz
--          if (v.highCountTmp(i) + v.lowCountTmp(i) > 498) then
--             v.highCountTmp(i)      := r.highCountTmp(i);
--             v.lowCountTmp(i)       := r.lowCountTmp(i);
--             v.axilWriteSlave.bresp := AXI_RESP_SLVERR_C;
--          end if;
      end loop;


      -- Use this to set multiple channels to a common phase alignment reference
      axiSlaveRegister(axilEp, toSlv(12*8, 8), 0, v.alignChannel);

      axiSlaveDefault(axilEp, v.axilWriteSlave, v.axilReadSlave, AXI_RESP_DECERR_C);
      ----------------------------------------------------------------------------------------------

      for i in 0 to 11 loop
         if (preFall(i) = '1') then
            -- Bounds check. Reset tmps back to last good values if out of bounds
            -- Don't allow frequencies over 2MHz or under 400kHz
            if (r.highCountTmp(i) + r.lowCountTmp(i) < 98) or
               (r.highCountTmp(i) + r.lowCountTmp(i) > 498) or
               (r.highCountTmp(i) = 0) or (r.lowCountTmp(i) = 0) then
               v.highCountTmp(i) := r.highCount(i);
               v.lowCountTmp(i)  := r.lowCount(i);
            else
               -- Assign tmps to pwm inputs
               v.highCount(i)  := r.highCountTmp(i);
               v.lowCount(i)   := r.lowCountTmp(i);
               v.delayCount(i) := r.delayCountTmp(i);
               v.outputEn(i)   := r.outputEnTmp(i);
            end if;
         end if;
      end loop;

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
