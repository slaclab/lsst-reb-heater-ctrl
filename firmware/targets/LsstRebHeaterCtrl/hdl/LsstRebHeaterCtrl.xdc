##############################################################################
## This file is part of 'LSST Firmware'.
## It is subject to the license terms in the LICENSE.txt file found in the 
## top-level directory of this distribution and at: 
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
## No part of 'LSST Firmware', including this file, 
## may be copied, modified, propagated, or distributed except according to 
## the terms contained in the LICENSE.txt file.
##############################################################################

###########################################################################################

set_property -dict { PACKAGE_PIN P22 IOSTANDARD LVCMOS33 } [get_ports { bootMosi}]
set_property -dict { PACKAGE_PIN R22 IOSTANDARD LVCMOS33 } [get_ports { bootMiso}]
set_property -dict { PACKAGE_PIN P21 IOSTANDARD LVCMOS33 } [get_ports { bootWpL}]
set_property -dict { PACKAGE_PIN R21 IOSTANDARD LVCMOS33 } [get_ports { bootHdL}]
set_property -dict { PACKAGE_PIN T19 IOSTANDARD LVCMOS33 } [get_ports { bootCsL}]

set_property -dict { PACKAGE_PIN F10} [get_ports { ethClkP}]
set_property -dict { PACKAGE_PIN E10} [get_ports { ethClkN}]

create_generated_clock -name clk200 [get_pins {U_ClockManager7_1/MmcmGen.U_Mmcm/CLKOUT0}]

set_clock_groups -asynchronous \ 
-group [get_clocks {axilClk}] \
    -group [get_clocks {clk200}]

set_property -dict { PACKAGE_PIN B4  } [get_ports { ethTxP[0]}]
set_property -dict { PACKAGE_PIN A4  } [get_ports { ethTxN[0]}]
set_property -dict { PACKAGE_PIN B8  } [get_ports { ethRxP[0]}]
set_property -dict { PACKAGE_PIN A8  } [get_ports { ethRxN[0]}]

set_property -dict { PACKAGE_PIN D5  } [get_ports { ethTxP[1]}]
set_property -dict { PACKAGE_PIN C5  } [get_ports { ethTxN[1]}]
set_property -dict { PACKAGE_PIN D11 } [get_ports { ethRxP[1]}]
set_property -dict { PACKAGE_PIN C11 } [get_ports { ethRxN[1]}]

set_property -dict { PACKAGE_PIN F15 IOSTANDARD LVCMOS33} [get_ports { rebOutputEn[0] }]
set_property -dict { PACKAGE_PIN C15 IOSTANDARD LVCMOS33} [get_ports { rebOutputEn[1] }]
set_property -dict { PACKAGE_PIN D15 IOSTANDARD LVCMOS33} [get_ports { rebOutputEn[2] }]
set_property -dict { PACKAGE_PIN A16 IOSTANDARD LVCMOS33} [get_ports { rebOutputEn[3] }]
set_property -dict { PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports { rebOutputEn[4] }]
set_property -dict { PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports { rebOutputEn[5] }]
set_property -dict { PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports { rebOutputEn[6] }]
set_property -dict { PACKAGE_PIN K22 IOSTANDARD LVCMOS33} [get_ports { rebOutputEn[7] }]
set_property -dict { PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports { rebOutputEn[8] }]
set_property -dict { PACKAGE_PIN AB13 IOSTANDARD LVCMOS33} [get_ports {rebOutputEn[9] }]
set_property -dict { PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports { rebOutputEn[10] }]
set_property -dict { PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports { rebOutputEn[11] }]

set_property -dict { PACKAGE_PIN F13 IOSTANDARD LVCMOS33}  [get_ports { ltc2945AlertL[0] }]
set_property -dict { PACKAGE_PIN E13 IOSTANDARD LVCMOS33}  [get_ports { ltc2945AlertL[1] }]
set_property -dict { PACKAGE_PIN B15 IOSTANDARD LVCMOS33}  [get_ports { ltc2945AlertL[2] }]
set_property -dict { PACKAGE_PIN A13 IOSTANDARD LVCMOS33}  [get_ports { ltc2945AlertL[3] }]
set_property -dict { PACKAGE_PIN H13 IOSTANDARD LVCMOS33}  [get_ports { ltc2945AlertL[4] }]
set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33}  [get_ports { ltc2945AlertL[5] }]
set_property -dict { PACKAGE_PIN J22 IOSTANDARD LVCMOS33}  [get_ports { ltc2945AlertL[6] }]
set_property -dict { PACKAGE_PIN M21 IOSTANDARD LVCMOS33}  [get_ports { ltc2945AlertL[7] }]
set_property -dict { PACKAGE_PIN Y16 IOSTANDARD LVCMOS33}  [get_ports { ltc2945AlertL[8] }]
set_property -dict { PACKAGE_PIN AA15 IOSTANDARD LVCMOS33} [get_ports { ltc2945AlertL[9] }]
set_property -dict { PACKAGE_PIN AB11 IOSTANDARD LVCMOS33} [get_ports { ltc2945AlertL[10] }]
set_property -dict { PACKAGE_PIN V10 IOSTANDARD LVCMOS33}  [get_ports { ltc2945AlertL[11] }]

set_property -dict { PACKAGE_PIN F14  IOSTANDARD LVCMOS33}  [get_ports { rebPwm[0] }]
set_property -dict { PACKAGE_PIN E14  IOSTANDARD LVCMOS33}  [get_ports { rebPwm[1] }]
set_property -dict { PACKAGE_PIN B16  IOSTANDARD LVCMOS33}  [get_ports { rebPwm[2] }]
set_property -dict { PACKAGE_PIN A14  IOSTANDARD LVCMOS33}  [get_ports { rebPwm[3] }]
set_property -dict { PACKAGE_PIN G13  IOSTANDARD LVCMOS33}  [get_ports { rebPwm[4] }]
set_property -dict { PACKAGE_PIN G18  IOSTANDARD LVCMOS33}  [get_ports { rebPwm[5] }]
set_property -dict { PACKAGE_PIN H22  IOSTANDARD LVCMOS33}  [get_ports { rebPwm[6] }]
set_property -dict { PACKAGE_PIN L21  IOSTANDARD LVCMOS33}  [get_ports { rebPwm[7] }]
set_property -dict { PACKAGE_PIN AA16 IOSTANDARD LVCMOS33}  [get_ports { rebPwm[8] }]
set_property -dict { PACKAGE_PIN AB15 IOSTANDARD LVCMOS33}  [get_ports { rebPwm[9] }]
set_property -dict { PACKAGE_PIN AB12 IOSTANDARD LVCMOS33}  [get_ports { rebPwm[10] }]
set_property -dict { PACKAGE_PIN W10  IOSTANDARD LVCMOS33}  [get_ports { rebPwm[11] }]

set_property -dict { PACKAGE_PIN F16  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Sda[0] }]
set_property -dict { PACKAGE_PIN E16  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Sda[1] }]
set_property -dict { PACKAGE_PIN C13  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Sda[2] }]
set_property -dict { PACKAGE_PIN B17  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Sda[3] }]
set_property -dict { PACKAGE_PIN G15  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Sda[4] }]
set_property -dict { PACKAGE_PIN J15  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Sda[5] }]
set_property -dict { PACKAGE_PIN H20  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Sda[6] }]
set_property -dict { PACKAGE_PIN J20  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Sda[7] }]
set_property -dict { PACKAGE_PIN AB16  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Sda[8] }]
set_property -dict { PACKAGE_PIN Y13  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Sda[9] }]
set_property -dict { PACKAGE_PIN AA9  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Sda[10] }]
set_property -dict { PACKAGE_PIN Y11  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Sda[11] }]

set_property -dict { PACKAGE_PIN E17  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Scl[0] }]
set_property -dict { PACKAGE_PIN D16  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Scl[1] }]
set_property -dict { PACKAGE_PIN B13  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Scl[2] }]
set_property -dict { PACKAGE_PIN B18  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Scl[3] }]
set_property -dict { PACKAGE_PIN G16  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Scl[4] }]
set_property -dict { PACKAGE_PIN H15  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Scl[5] }]
set_property -dict { PACKAGE_PIN G20  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Scl[6] }]
set_property -dict { PACKAGE_PIN J21  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Scl[7] }]
set_property -dict { PACKAGE_PIN AB17  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Scl[8] }]
set_property -dict { PACKAGE_PIN AA14  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Scl[9] }]
set_property -dict { PACKAGE_PIN AB10  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Scl[10] }]
set_property -dict { PACKAGE_PIN Y12  IOSTANDARD LVCMOS33}  [get_ports { ltc2945Scl[11] }]

set_property -dict { PACKAGE_PIN C17  IOSTANDARD LVCMOS33}  [get_ports { lambdaAcOk[0] }]
set_property -dict { PACKAGE_PIN C18  IOSTANDARD LVCMOS33}  [get_ports { lambdaAcOk[1] }]
set_property -dict { PACKAGE_PIN C19  IOSTANDARD LVCMOS33}  [get_ports { lambdaAcOk[2] }]
set_property -dict { PACKAGE_PIN E19  IOSTANDARD LVCMOS33}  [get_ports { lambdaAcOk[3] }]
set_property -dict { PACKAGE_PIN D19  IOSTANDARD LVCMOS33}  [get_ports { lambdaAcOk[4] }]
set_property -dict { PACKAGE_PIN F18  IOSTANDARD LVCMOS33}  [get_ports { lambdaAcOk[5] }]

set_property -dict { PACKAGE_PIN A20  IOSTANDARD LVCMOS33}  [get_ports { lambdaPwrOk[0] }]
set_property -dict { PACKAGE_PIN A18  IOSTANDARD LVCMOS33}  [get_ports { lambdaPwrOk[1] }]
set_property -dict { PACKAGE_PIN A19  IOSTANDARD LVCMOS33}  [get_ports { lambdaPwrOk[2] }]
set_property -dict { PACKAGE_PIN F19  IOSTANDARD LVCMOS33}  [get_ports { lambdaPwrOk[3] }]
set_property -dict { PACKAGE_PIN F20  IOSTANDARD LVCMOS33}  [get_ports { lambdaPwrOk[4] }]
set_property -dict { PACKAGE_PIN D20  IOSTANDARD LVCMOS33}  [get_ports { lambdaPwrOk[5] }]

set_property -dict { PACKAGE_PIN C22  IOSTANDARD LVCMOS33}  [get_ports { lambdaOtw[0] }]
set_property -dict { PACKAGE_PIN B22  IOSTANDARD LVCMOS33}  [get_ports { lambdaOtw[1] }]
set_property -dict { PACKAGE_PIN B21  IOSTANDARD LVCMOS33}  [get_ports { lambdaOtw[2] }]
set_property -dict { PACKAGE_PIN A21  IOSTANDARD LVCMOS33}  [get_ports { lambdaOtw[3] }]
set_property -dict { PACKAGE_PIN E22  IOSTANDARD LVCMOS33}  [get_ports { lambdaOtw[4] }]
set_property -dict { PACKAGE_PIN D22  IOSTANDARD LVCMOS33}  [get_ports { lambdaOtw[5] }]

set_property -dict { PACKAGE_PIN H19  IOSTANDARD LVCMOS33}  [get_ports { lambdaRemoteOnL[0] }]
set_property -dict { PACKAGE_PIN K18  IOSTANDARD LVCMOS33}  [get_ports { lambdaRemoteOnL[1] }]
set_property -dict { PACKAGE_PIN K19  IOSTANDARD LVCMOS33}  [get_ports { lambdaRemoteOnL[2] }]
set_property -dict { PACKAGE_PIN L19  IOSTANDARD LVCMOS33}  [get_ports { lambdaRemoteOnL[3] }]
set_property -dict { PACKAGE_PIN L20  IOSTANDARD LVCMOS33}  [get_ports { lambdaRemoteOnL[4] }]
set_property -dict { PACKAGE_PIN N22  IOSTANDARD LVCMOS33}  [get_ports { lambdaRemoteOnL[5] }]

set_property -dict { PACKAGE_PIN M18  IOSTANDARD LVCMOS33}  [get_ports { lambdaSda[0] }]
set_property -dict { PACKAGE_PIN L18  IOSTANDARD LVCMOS33}  [get_ports { lambdaSda[1] }]
set_property -dict { PACKAGE_PIN N18  IOSTANDARD LVCMOS33}  [get_ports { lambdaSda[2] }]
set_property -dict { PACKAGE_PIN N19  IOSTANDARD LVCMOS33}  [get_ports { lambdaSda[3] }]
set_property -dict { PACKAGE_PIN N20  IOSTANDARD LVCMOS33}  [get_ports { lambdaSda[4] }]
set_property -dict { PACKAGE_PIN M20  IOSTANDARD LVCMOS33}  [get_ports { lambdaSda[5] }]

set_property -dict { PACKAGE_PIN K14  IOSTANDARD LVCMOS33}  [get_ports { lambdaScl[0] }]
set_property -dict { PACKAGE_PIN M13  IOSTANDARD LVCMOS33}  [get_ports { lambdaScl[1] }]
set_property -dict { PACKAGE_PIN L13  IOSTANDARD LVCMOS33}  [get_ports { lambdaScl[2] }]
set_property -dict { PACKAGE_PIN K17  IOSTANDARD LVCMOS33}  [get_ports { lambdaScl[3] }]
set_property -dict { PACKAGE_PIN J17  IOSTANDARD LVCMOS33}  [get_ports { lambdaScl[4] }]
set_property -dict { PACKAGE_PIN L14  IOSTANDARD LVCMOS33}  [get_ports { lambdaScl[5] }]

set_property -dict { PACKAGE_PIN T14  IOSTANDARD LVCMOS33}  [get_ports { lambdaEnabled[0] }]
set_property -dict { PACKAGE_PIN T15  IOSTANDARD LVCMOS33}  [get_ports { lambdaEnabled[1] }]
set_property -dict { PACKAGE_PIN W15  IOSTANDARD LVCMOS33}  [get_ports { lambdaEnabled[2] }]
set_property -dict { PACKAGE_PIN W16  IOSTANDARD LVCMOS33}  [get_ports { lambdaEnabled[3] }]
set_property -dict { PACKAGE_PIN T16  IOSTANDARD LVCMOS33}  [get_ports { lambdaEnabled[4] }]
set_property -dict { PACKAGE_PIN U16  IOSTANDARD LVCMOS33}  [get_ports { lambdaEnabled[5] }]

set_property -dict { PACKAGE_PIN V13  IOSTANDARD LVCMOS33}  [get_ports { cryoEnL }]
set_property -dict { PACKAGE_PIN V14  IOSTANDARD LVCMOS33}  [get_ports { coldplateEnL }]





###########################################################################################
