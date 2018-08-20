-------------------------------------------------------------------------------
-- Title      : Testbench for design "RebPwmCtrl"
-------------------------------------------------------------------------------
-- Company    : SLAC National Accelerator Laboratory
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- This file is part of lsst. It is subject to
-- the license terms in the LICENSE.txt file found in the top-level directory
-- of this distribution and at:
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
-- No part of lsst, including this file, may be
-- copied, modified, propagated, or distributed except according to the terms
-- contained in the LICENSE.txt file.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;

----------------------------------------------------------------------------------------------------

entity RebPwmCtrlTb is

end entity RebPwmCtrlTb;

----------------------------------------------------------------------------------------------------

architecture sim of RebPwmCtrlTb is

   -- component generics
   constant TPD_G : time := 1 ns;

   -- component ports
   signal clk200          : sl;                                                      -- [in]
   signal rst200          : sl;                                                      -- [in]
   signal axilReadMaster  : AxiLiteReadMasterType  := AXI_LITE_READ_MASTER_INIT_C;   -- [in]
   signal axilReadSlave   : AxiLiteReadSlaveType   := AXI_LITE_READ_SLAVE_INIT_C;    -- [out]
   signal axilWriteMaster : AxiLiteWriteMasterType := AXI_LITE_WRITE_MASTER_INIT_C;  -- [in]
   signal axilWriteSlave  : AxiLiteWriteSlaveType  := AXI_LITE_WRITE_SLAVE_INIT_C;   -- [out]
   signal outputEn        : slv(11 downto 0);                                        -- [out]
   signal pwm             : slv(11 downto 0);                                        -- [out]

begin

   -- component instantiation
   U_RebPwmCtrl : entity work.RebPwmCtrl
      generic map (
         TPD_G => TPD_G)
      port map (
         clk200          => clk200,           -- [in]
         rst200          => rst200,           -- [in]
         axilReadMaster  => axilReadMaster,   -- [in]
         axilReadSlave   => axilReadSlave,    -- [out]
         axilWriteMaster => axilWriteMaster,  -- [in]
         axilWriteSlave  => axilWriteSlave,   -- [out]
         outputEn        => outputEn,         -- [out]
         pwm             => pwm);             -- [out]


   U_ClkRst_1 : entity work.ClkRst
      generic map (
         CLK_PERIOD_G      => 5 ns,
         CLK_DELAY_G       => 1 ns,
         RST_START_DELAY_G => 0 ns,
         RST_HOLD_TIME_G   => 5 us,
         SYNC_RESET_G      => true)
      port map (
         clkP => clk200,
         rst  => rst200);

   sim: process is
      variable data : slv(31 downto 0) := (others => '0');
      variable addr : slv(31 downto 0) := (others => '0');
   begin
      wait until rst200 = '1';
      wait until rst200 = '0';
      wait until clk200 = '1';
      wait for 10 us;
      wait until clk200 = '1';
      data(8 downto 0) := "001111000";
      data(17 downto 9) := "001111000";
      data(26 downto 18) := "000010000";
      axiLiteBusSimWrite(clk200, axilWriteMaster, axilWriteSlave, addr, data, true);

      
      wait until clk200 = '1';
      addr := X"00000004";
      data(26 downto 18) := "000000000";
      axiLiteBusSimWrite(clk200, axilWriteMaster, axilWriteSlave, addr, data, true);
      wait until clk200 = '1';      
      wait;
   end process sim;

end architecture sim;

----------------------------------------------------------------------------------------------------
