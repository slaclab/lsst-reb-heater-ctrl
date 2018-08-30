-------------------------------------------------------------------------------
-- File       : LsstRebHeaterCtrl.vhd
-- Company    : SLAC National Accelerator Laboratory
-- Created    : 2018-04-05
-- Last update: 2018-08-30
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
use work.I2cPkg.all;

library unisim;
use unisim.vcomponents.all;

entity LsstRebHeaterCtrl is
   generic (
      TPD_G        : time    := 1 ns;
      SIMULATION_G : boolean := false;
      BUILD_INFO_G : BuildInfoType);
   port (
      -- 1GbE Ports
      ethClkP         : in    sl;
      ethClkN         : in    sl;
      ethRxP          : in    slv(1 downto 0);
      ethRxN          : in    slv(1 downto 0);
      ethTxP          : out   slv(1 downto 0);
      ethTxN          : out   slv(1 downto 0);
      -- Boot Memory Ports
      bootCsL         : out   sl;
      bootMosi        : out   sl;
      bootMiso        : in    sl;
      bootWpL         : out   sl;
      bootHdL         : out   sl;
      -- XADC Ports
      vPIn            : in    sl;
      vNIn            : in    sl;
      -- PS Ctrl
      lambdaEnabled   : in    slv(5 downto 0);
      lambdaAcOk      : in    slv(5 downto 0);
      lambdaPwrOk     : in    slv(5 downto 0);
      lambdaOtw       : in    slv(5 downto 0);
      lambdaRemoteOnL : out   slv(5 downto 0) := (others => '1');
      lambdaSda       : inout slv(5 downto 0);
      lambdaScl       : inout slv(5 downto 0);
      -- REB Heater channels
      rebOutputEn     : out   slv(11 downto 0);
      rebPwm          : out   slv(11 downto 0);
      ltc2945AlertL   : in    slv(11 downto 0);
      ltc2945Sda      : inout slv(11 downto 0);
      ltc2945Scl      : inout slv(11 downto 0);
      -- Interlocks
      cryoEnL         : in    sl;
      coldplateEnL    : in    sl;
      -- Temp
      tempSda         : inout sl;
      tempScl         : inout sl;
      tempAlertL      : in    sl;
      tempCritL       : in    sl);
end LsstRebHeaterCtrl;

architecture top_level of LsstRebHeaterCtrl is

   -------------------------------------------------------------------------------------------------
   -- Main signals
   -------------------------------------------------------------------------------------------------
   signal clk200 : sl;
   signal rst200 : sl;

   constant AXI_XBAR_CONFIG_C : AxiLiteCrossbarMasterConfigArray(9 downto 0) := genAxiLiteConfig(10, x"0000_0000", 22, 18);

   signal axilClk          : sl;
   signal axilRst          : sl;
   signal axilWriteMasters : AxiLiteWriteMasterArray(6 downto 0);
   signal axilWriteSlaves  : AxiLiteWriteSlaveArray(6 downto 0) := (others => AXI_LITE_WRITE_SLAVE_EMPTY_DECERR_C);
   signal axilReadMasters  : AxiLiteReadMasterArray(6 downto 0);
   signal axilReadSlaves   : AxiLiteReadSlaveArray(6 downto 0)  := (others => AXI_LITE_READ_SLAVE_EMPTY_DECERR_C);

   signal startConv : sl := '1';

   -------------------------------------------------------------------------------------------------
   -- REB Signals
   -------------------------------------------------------------------------------------------------
   signal heaterAxilWriteMaster : AxiLiteWriteMasterType;
   signal heaterAxilWriteSlave  : AxiLiteWriteSlaveType;
   signal heaterAxilReadMaster  : AxiLiteReadMasterType;
   signal heaterAxilReadSlave   : AxiLiteReadSlaveType;

   signal ltc2945AxilWriteMasters : AxiLiteWriteMasterArray(11 downto 0);
   signal ltc2945AxilWriteSlaves  : AxiLiteWriteSlaveArray(11 downto 0) := (others => AXI_LITE_WRITE_SLAVE_EMPTY_DECERR_C);
   signal ltc2945AxilReadMasters  : AxiLiteReadMasterArray(11 downto 0);
   signal ltc2945AxilReadSlaves   : AxiLiteReadSlaveArray(11 downto 0)  := (others => AXI_LITE_READ_SLAVE_EMPTY_DECERR_C);

   signal ltc2945ComFault : slv(11 downto 0);

   signal ltc2945I2cIn  : i2c_in_array(11 downto 0);
   signal ltc2945I2cOut : i2c_out_array(11 downto 0);


   -------------------------------------------------------------------------------------------------
   -- Lambda Signals
   -------------------------------------------------------------------------------------------------
   signal lambdaAxilWriteMasters : AxiLiteWriteMasterArray(6 downto 0);
   signal lambdaAxilWriteSlaves  : AxiLiteWriteSlaveArray(6 downto 0) := (others => AXI_LITE_WRITE_SLAVE_EMPTY_DECERR_C);
   signal lambdaAxilReadMasters  : AxiLiteReadMasterArray(6 downto 0);
   signal lambdaAxilReadSlaves   : AxiLiteReadSlaveArray(6 downto 0)  := (others => AXI_LITE_READ_SLAVE_EMPTY_DECERR_C);

   signal lambdaComFault : slv(5 downto 0);

   signal lambdaI2cIn  : i2c_in_array(11 downto 0);
   signal lambdaI2cOut : i2c_out_array(11 downto 0);

   -------------------------------------------------------------------------------------------------
   -- Temp signals
   -------------------------------------------------------------------------------------------------
   signal tempI2cIn  : i2c_in_type;
   signal tempI2cOut : i2c_out_type;



begin

   ---------------------
   -- Common Core Module
   ---------------------
   U_Core : entity work.LsstPwrCtrlCore
      generic map (
         TPD_G             => TPD_G,
         SIMULATION_G      => SIMULATION_G,
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
         -- Eth config
         overrideEthCofig => '0',
         overrideMacAddr  => X"01_00_16_56_00_08",
         overrideIpAddr   => X"0B_01_A8_C0",
         -- Boot Memory Ports
         bootCsL          => bootCsL,
         bootMosi         => bootMosi,
         bootMiso         => bootMiso,
         bootWpL          => bootWpL,
         bootHdL          => bootHdL,
         -- 1GbE Interface
         ethClkP          => ethClkP,
         ethClkN          => ethClkN,
         ethRxP           => ethRxP,
         ethRxN           => ethRxN,
         ethTxP           => ethTxP,
         ethTxN           => ethTxN);

   -------------------------------------------------------------------------------------------------
   -- PWM
   -------------------------------------------------------------------------------------------------
   -- Create 200 MHz clock for PWM base
   U_ClockManager7_1 : entity work.ClockManager7
      generic map (
         TPD_G              => TPD_G,
         TYPE_G             => "MMCM",
         INPUT_BUFG_G       => false,
         FB_BUFG_G          => true,
         OUTPUT_BUFG_G      => true,
         NUM_CLOCKS_G       => 1,
         CLKIN_PERIOD_G     => 8.0,
         DIVCLK_DIVIDE_G    => 1,
         CLKFBOUT_MULT_F_G  => 8.0,
         CLKOUT0_DIVIDE_F_G => 5.0)
      port map (
         clkIn     => axilClk,          -- [in]
         rstIn     => axilRst,          -- [in]
         clkOut(0) => clk200,           -- [out]
         rstOut(0) => rst200);          -- [out]

   -- Bring AXIL onto clk200
   U_AxiLiteAsync_1 : entity work.AxiLiteAsync
      generic map (
         TPD_G => TPD_G)
--         AXI_ERROR_RESP_G => AXI_ERROR_RESP_G,
      port map (
         sAxiClk         => axilClk,                -- [in]
         sAxiClkRst      => axilRst,                -- [in]
         sAxiReadMaster  => axilReadMasters(0),     -- [in]
         sAxiReadSlave   => axilReadSlaves(0),      -- [out]
         sAxiWriteMaster => axilWriteMasters(0),    -- [in]
         sAxiWriteSlave  => axilWriteSlaves(0),     -- [out]
         mAxiClk         => clk200,                 -- [in]
         mAxiClkRst      => rst200,                 -- [in]
         mAxiReadMaster  => heaterAxilReadMaster,   -- [out]
         mAxiReadSlave   => heaterAxilReadSlave,    -- [in]
         mAxiWriteMaster => heaterAxilWriteMaster,  -- [out]
         mAxiWriteSlave  => heaterAxilWriteSlave);  -- [in]

   -- Reb heater PWM controls on ch 0
   U_RebPwmCtrl_1 : entity work.RebPwmCtrl
      generic map (
         TPD_G => TPD_G)
      port map (
         clk200          => clk200,                 -- [in]
         rst200          => rst200,                 -- [in]
         axilReadMaster  => heaterAxilReadMaster,   -- [in]
         axilReadSlave   => heaterAxilReadSlave,    -- [in]
         axilWriteMaster => heaterAxilWriteMaster,  -- [out]
         axilWriteSlave  => heaterAxilWriteSlave,   -- [in]
         outputEn        => rebOutputEn,            -- [out]
         pwm             => rebPwm);                -- [out]

   -------------------------------------------------------------------------------------------------
   -- REB channel power monitoring
   -- AXIL CH 1
   -- LTC2945
   -------------------------------------------------------------------------------------------------
   U_REB_Xbar : entity work.AxiLiteCrossbar
      generic map (
         TPD_G              => TPD_G,
         NUM_SLAVE_SLOTS_G  => 1,
         NUM_MASTER_SLOTS_G => 12,
         MASTERS_CONFIG_G   => genAxiLiteConfig(12, x"0004_0000", 18, 12))
      port map (
         axiClk              => axilClk,
         axiClkRst           => axilRst,
         sAxiWriteMasters(0) => axilWriteMasters(1),
         sAxiWriteSlaves(0)  => axilWriteSlaves(1),
         sAxiReadMasters(0)  => axilReadMasters(1),
         sAxiReadSlaves(0)   => axilReadSlaves(1),
         mAxiWriteMasters    => ltc2945AxilWriteMasters,
         mAxiWriteSlaves     => ltc2945AxilWriteSlaves,
         mAxiReadMasters     => ltc2945AxilReadMasters,
         mAxiReadSlaves      => ltc2945AxilReadSlaves);

   U_StartConv : entity work.Heartbeat
      generic map(
         TPD_G        => 1 ns,
         PERIOD_IN_G  => 8.0E-9,                             --units of seconds
         PERIOD_OUT_G => ite(SIMULATION_G, 1.0E-3, 1.0E-0))  --units of seconds
      port map (
         clk => axilClk,
         rst => axilRst,
         o   => startConv);


   LTC2495_GEN : for i in 11 downto 0 generate
--       U_Ltc2945I2cMap : entity work.Ltc2945I2cMap
--          generic map (
--             TPD_G           => TPD_G,
--             AXI_CLK_FREQ_G  => 125.0E6,
--             I2C_SCL_FREQ_G  => 100.0E+3,
--             I2C_MIN_PULSE_G => 100.0E-9)
--          port map (
--             axiClk         => axilClk,                    -- [in]
--             axiRst         => axilRst,                    -- [in]
--             axiReadMaster  => ltc2945AxilReadMasters(i),   -- [in]
--             axiReadSlave   => ltc2945AxilReadSlaves(i),    -- [out]
--             axiWriteMaster => ltc2945AxilWriteMasters(i),  -- [in]
--             axiWriteSlave  => ltc2945AxilWriteSlaves(i),   -- [out]
--             scl            => ltc2945Scl(i),
--             sda            => ltc2945Sda(i));


      U_LTC2945Axil_1 : entity work.LTC2945Axil
         generic map (
            TPD_G => TPD_G)
         port map (
            axilClk         => axilClk,                     -- [in]
            axilRst         => axilRst,                     -- [in]
            axilReadMaster  => ltc2945AxilReadMasters(i),   -- [in]
            axilReadSlave   => ltc2945AxilReadSlaves(i),    -- [out]
            axilWriteMaster => ltc2945AxilWriteMasters(i),  -- [in]
            axilWriteSlave  => ltc2945AxilWriteSlaves(i),   -- [out]
            i2ci            => ltc2945I2cIn(i),             -- [inout]
            i2co            => ltc2945I2cOut(i),            -- [inout]
            StartConv       => startConv,                   -- [in]
            LTC2945ComFault => ltc2945ComFault(i));         -- [out]

      BOARD_SDA_IOBUFT : IOBUF
         port map (
            I  => ltc2945I2cOut(i).sda,
            O  => ltc2945I2cIn(i).sda,
            IO => ltc2945Sda(i),
            T  => ltc2945I2cOut(i).sdaoen);

      BOARD_SCL_IOBUFT : IOBUF
         port map (
            I  => ltc2945I2cOut(i).scl,
            O  => ltc2945I2cIn(i).scl,
            IO => ltc2945Scl(i),
            T  => ltc2945I2cOut(i).scloen);

   end generate LTC2495_GEN;


   -------------------------------------------------------------------------------------------------
   -- Lambda PS monitoring on ch 2
   -------------------------------------------------------------------------------------------------
   U_LAMBDA_XBAR : entity work.AxiLiteCrossbar
      generic map (
         TPD_G              => TPD_G,
         NUM_SLAVE_SLOTS_G  => 1,
         NUM_MASTER_SLOTS_G => 7,
         MASTERS_CONFIG_G   => genAxiLiteConfig(7, x"0008_0000", 18, 12))
      port map (
         axiClk              => axilClk,
         axiClkRst           => axilRst,
         sAxiWriteMasters(0) => axilWriteMasters(2),
         sAxiWriteSlaves(0)  => axilWriteSlaves(2),
         sAxiReadMasters(0)  => axilReadMasters(2),
         sAxiReadSlaves(0)   => axilReadSlaves(2),
         mAxiWriteMasters    => lambdaAxilWriteMasters,
         mAxiWriteSlaves     => lambdaAxilWriteSlaves,
         mAxiReadMasters     => lambdaAxilReadMasters,
         mAxiReadSlaves      => lambdaAxilReadSlaves);

   LAMBDA_GEN : for i in 5 downto 0 generate
      U_LambdaAxil_1 : entity work.LambdaAxil
         generic map (
            TPD_G => TPD_G)
         port map (
            axilClk         => axilClk,                    -- [in]
            axilRst         => axilRst,                    -- [in]
            axilReadMaster  => lambdaAxilReadMasters(i),   -- [in]
            axilReadSlave   => lambdaAxilReadSlaves(i),    -- [out]
            axilWriteMaster => lambdaAxilWriteMasters(i),  -- [in]
            axilWriteSlave  => lambdaAxilWriteSlaves(i),   -- [out]
            i2ci            => lambdaI2cIn(i),             -- [inout]
            i2co            => lambdaI2cOut(i),            -- [inout]
            StartConv       => startConv,                  -- [in]
            LambdaComFault  => lambdaComFault(i));         -- [out]

      LAMBDA_SDA_IOBUFT : IOBUF
         port map (
            I  => lambdaI2cOut(i).sda,
            O  => lambdaI2cIn(i).sda,
            IO => lambdaSda(i),
            T  => lambdaI2cOut(i).sdaoen);

      LAMBDA_SCL_IOBUFT : IOBUF
         port map (
            I  => lambdaI2cOut(i).scl,
            O  => lambdaI2cIn(i).scl,
            IO => lambdaScl(i),
            T  => lambdaI2cOut(i).scloen);
   end generate LAMBDA_GEN;


   U_LambdaIO_1 : entity work.LambdaIO
      generic map (
         TPD_G => TPD_G)
      port map (
         axilClk         => axilClk,                    -- [in]
         axilRst         => axilRst,                    -- [in]
         axilReadMaster  => lambdaAxilReadMasters(6),   -- [in]
         axilReadSlave   => lambdaAxilReadSlaves(6),    -- [out]
         axilWriteMaster => lambdaAxilWriteMasters(6),  -- [in]
         axilWriteSlave  => lambdaAxilWriteSlaves(6),   -- [out]
         lambdaEnabled   => lambdaEnabled,              -- [in]
         lambdaAcOk      => lambdaAcOk,                 -- [in]
         lambdaPwrOk     => lambdaPwrOk,                -- [in]
         lambdaOtw       => lambdaOtw,                  -- [in]
         lambdaRemoteOnL => lambdaRemoteOnL);           -- [out]

   -------------------------------------------------------------------------------------------------
   -- Interlocks on ch 3
   -------------------------------------------------------------------------------------------------
   U_AxiLiteRegs_1 : entity work.AxiLiteRegs
      generic map (
         TPD_G           => TPD_G,
         NUM_WRITE_REG_G => 1,
         NUM_READ_REG_G  => 1)
      port map (
         axiClk                       => axilClk,              -- [in]
         axiClkRst                    => axilRst,              -- [in]
         axiReadMaster                => axilReadMasters(3),   -- [in]
         axiReadSlave                 => axilReadSlaves(3),    -- [out]
         axiWriteMaster               => axilWriteMasters(3),  -- [in]
         axiWriteSlave                => axilWriteSlaves(3),   -- [out]
         readRegister(0)(0)           => cryoEnL,              -- [in]
         readRegister(0)(1)           => coldplateEnL,         -- [in]
         readRegister(0)(31 downto 2) => (others => '0'));     -- [in]

   -------------------------------------------------------------------------------------------------
   -- Temperature on ch 4
   -------------------------------------------------------------------------------------------------
   U_AxiI2cRegMaster_1 : entity work.AxiI2cRegMaster
      generic map (
         TPD_G                         => TPD_G,
         DEVICE_MAP_G                  => (0 =>
                          (i2cAddress  => "0001010000",
                           i2cTenbit   => '0',
                           dataSize    => 8,
                           addrSize    => 8,
                           endianness  => '0',
                           repeatStart => '0')),
         I2C_SCL_FREQ_G                => 100.0E+3,
         I2C_MIN_PULSE_G               => 100.0E-9,
         AXI_CLK_FREQ_G                => 125.0E+6)
      port map (
         axiClk         => axilClk,              -- [in]
         axiRst         => axilRst,              -- [in]
         axiReadMaster  => axilReadMasters(4),   -- [in]
         axiReadSlave   => axilReadSlaves(4),    -- [out]
         axiWriteMaster => axilWriteMasters(4),  -- [in]
         axiWriteSlave  => axilWriteSlaves(4),   -- [out]
         scl            => tempScl,              -- [inout]
         sda            => tempSda);             -- [inout]


end top_level;
