-------------------------------------------------------------------------------
-- Title      : Testbench for design "LsstRebHeaterCtrl"
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

----------------------------------------------------------------------------------------------------

entity LsstRebHeaterCtrlTb is

end entity LsstRebHeaterCtrlTb;

----------------------------------------------------------------------------------------------------

architecture sim of LsstRebHeaterCtrlTb is

   -- component generics
   constant TPD_G        : time    := 1 ns;
   constant SIMULATION_G : boolean := false;
   constant BUILD_INFO_G : BuildInfoType    := BUILD_INFO_DEFAULT_SLV_C;

   -- component ports
   signal ethClkP         : sl;                -- [in]
   signal ethClkN         : sl;                -- [in]
   signal ethRxP          : slv(1 downto 0);   -- [in]
   signal ethRxN          : slv(1 downto 0);   -- [in]
   signal ethTxP          : slv(1 downto 0);   -- [out]
   signal ethTxN          : slv(1 downto 0);   -- [out]
   signal bootCsL         : sl;                -- [out]
   signal bootMosi        : sl;                -- [out]
   signal bootMiso        : sl;                -- [in]
   signal bootWpL         : sl;                -- [out]
   signal bootHdL         : sl;                -- [out]
   signal vPIn            : sl;                -- [in]
   signal vNIn            : sl;                -- [in]
   signal lambdaEnabled   : slv(5 downto 0) := (others => '0');   -- [in]
   signal lambdaAcOk      : slv(5 downto 0) := (others => '0');   -- [in]
   signal lambdaPwrOk     : slv(5 downto 0) := (others => '0');   -- [in]
   signal lambdaOtw       : slv(5 downto 0) := (others => '0');   -- [in]
   signal lambdaRemoteOnL : slv(5 downto 0) := (others => '0');   -- [out]
   signal lambdaSda       : slv(5 downto 0) := (others => 'H');   -- [inout]
   signal lambdaScl       : slv(5 downto 0) := (others => 'H');   -- [inout]
   signal rebOutputEn     : slv(11 downto 0);  -- [out]
   signal rebPwm          : slv(11 downto 0);  -- [out]
   signal ltc2945AlertL   : slv(11 downto 0) := (others => '1');  -- [in]
   signal ltc2945Sda      : slv(11 downto 0);  -- [inout]
   signal ltc2945Scl      : slv(11 downto 0);  -- [inout]
   signal cryoEnL         : sl := '0';                -- [in]
   signal coldplateEnL    : sl := '0';                -- [in]

begin

   -- component instantiation
   U_LsstRebHeaterCtrl: entity work.LsstRebHeaterCtrl
      generic map (
         TPD_G        => TPD_G,
         SIMULATION_G => true,
         BUILD_INFO_G => BUILD_INFO_G)
      port map (
         ethClkP         => ethClkP,          -- [in]
         ethClkN         => ethClkN,          -- [in]
         ethRxP          => ethRxP,           -- [in]
         ethRxN          => ethRxN,           -- [in]
         ethTxP          => ethTxP,           -- [out]
         ethTxN          => ethTxN,           -- [out]
         bootCsL         => bootCsL,          -- [out]
         bootMosi        => bootMosi,         -- [out]
         bootMiso        => bootMiso,         -- [in]
         bootWpL         => bootWpL,          -- [out]
         bootHdL         => bootHdL,          -- [out]
         vPIn            => vPIn,             -- [in]
         vNIn            => vNIn,             -- [in]
         lambdaEnabled   => lambdaEnabled,    -- [in]
         lambdaAcOk      => lambdaAcOk,       -- [in]
         lambdaPwrOk     => lambdaPwrOk,      -- [in]
         lambdaOtw       => lambdaOtw,        -- [in]
         lambdaRemoteOnL => lambdaRemoteOnL,  -- [out]
         lambdaSda       => lambdaSda,        -- [inout]
         lambdaScl       => lambdaScl,        -- [inout]
         rebOutputEn     => rebOutputEn,      -- [out]
         rebPwm          => rebPwm,           -- [out]
         ltc2945AlertL   => ltc2945AlertL,    -- [in]
         ltc2945Sda      => ltc2945Sda,       -- [inout]
         ltc2945Scl      => ltc2945Scl,       -- [inout]
         cryoEnL         => cryoEnL,          -- [in]
         coldplateEnL    => coldplateEnL);    -- [in]

   
   U_ClkRst_1 : entity work.ClkRst
      generic map (
         CLK_PERIOD_G      => 8 ns,
         CLK_DELAY_G       => 1 ns,
         RST_START_DELAY_G => 0 ns,
         RST_HOLD_TIME_G   => 5 us,
         SYNC_RESET_G      => true)
      port map (
         clkP => ethClkP,
         clkN => ethClkN);
   

end architecture sim;

----------------------------------------------------------------------------------------------------
