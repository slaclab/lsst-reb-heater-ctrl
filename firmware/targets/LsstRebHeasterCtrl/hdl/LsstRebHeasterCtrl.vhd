-------------------------------------------------------------------------------
-- File       : LsstRebHeasterCtrl.vhd
-- Company    : SLAC National Accelerator Laboratory
-- Created    : 2018-04-05
-- Last update: 2018-06-04
-------------------------------------------------------------------------------
-- Description: Firmware Target's Top Level
-------------------------------------------------------------------------------
-- This file is part of 'LSST Firmware'.
-- It is subject to the license terms in the LICENSE.txt file found in the 
-- top-level directory of this distribution and at: 
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
-- No part of 'LSST Firmware', including this file, 
-- may be copied, modified, propagated, or distributed except according to 
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;

entity LsstRebHeasterCtrl is
   generic (
      TPD_G        : time := 1 ns;
      BUILD_INFO_G : BuildInfoType);
   port (
      -- 1GbE Ports
      ethClkP : in  sl;
      ethClkN : in  sl;
      ethRxP  : in  slv(1 downto 0);
      ethRxN  : in  slv(1 downto 0);
      ethTxP  : out slv(1 downto 0);
      ethTxN  : out slv(1 downto 0);
      -- XADC Ports
      vPIn    : in  sl;
      vNIn    : in  sl);
end LsstRebHeasterCtrl;

architecture top_level of LsstRebHeasterCtrl is

   constant AXI_XBAR_CONFIG_C : AxiLiteCrossbarMasterConfigArray(8 downto 0) := genAxiLiteConfig(9, x"0000_0000", 22, 18);

   signal axilClk          : sl;
   signal axilRst          : sl;
   signal axilWriteMasters : AxiLiteWriteMasterArray(6 downto 0);
   signal axilWriteSlaves  : AxiLiteWriteSlaveArray(6 downto 0) := (others => AXI_LITE_WRITE_SLAVE_EMPTY_DECERR_C);
   signal axilReadMasters  : AxiLiteReadMasterArray(6 downto 0);
   signal axilReadSlaves   : AxiLiteReadSlaveArray(6 downto 0)  := (others => AXI_LITE_READ_SLAVE_EMPTY_DECERR_C);

begin

   ---------------------
   -- Common Core Module
   ---------------------
   U_Core : entity work.LsstPwrCtrlCore
      generic map (
         TPD_G             => TPD_G,
         NUM_LANE_G        => 2,
         AXI_XBAR_CONFIG_G => AXI_XBAR_CONFIG_C,
         BUILD_INFO_G      => BUILD_INFO_G)
      port map (
         -- Register Interface
         axilClk          => axilClk,
         axilRst          => axilRst,
         axilReadMasters  => axilReadMasters,
         axilReadSlaves   => axilReadSlaves,
         axilWriteMasters => axilWriteMasters,
         axilWriteSlaves  => axilWriteSlaves,
         -- Misc.
         extRstL          => '1',
         -- XADC Ports
         vPIn             => vPIn,
         vNIn             => vNIn,
         -- 1GbE Interface
         ethClkP          => ethClkP,
         ethClkN          => ethClkN,
         ethRxP           => ethRxP,
         ethRxN           => ethRxN,
         ethTxP           => ethTxP,
         ethTxN           => ethTxN);

end top_level;
