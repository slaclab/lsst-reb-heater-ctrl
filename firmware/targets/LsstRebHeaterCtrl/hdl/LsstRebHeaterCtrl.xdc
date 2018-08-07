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

create_clock -name ethClk -period 8.000 [get_ports {ethClkP}]

set_property -dict { PACKAGE_PIN B4  } [get_ports { ethTxP[0]}]
set_property -dict { PACKAGE_PIN A4  } [get_ports { ethTxN[0]}]
set_property -dict { PACKAGE_PIN B8  } [get_ports { ethRxP[0]}]
set_property -dict { PACKAGE_PIN A8  } [get_ports { ethRxN[0]}]

set_property -dict { PACKAGE_PIN D5  } [get_ports { ethTxP[1]}]
set_property -dict { PACKAGE_PIN C5  } [get_ports { ethTxN[1]}]
set_property -dict { PACKAGE_PIN D11 } [get_ports { ethRxP[1]}]
set_property -dict { PACKAGE_PIN C11 } [get_ports { ethRxN[1]}]

set_property -dict { PACKAGE_PIN F15 IOSTANDARD LVCMOS33} [get_ports { on[0] }]
set_property -dict { PACKAGE_PIN C15 IOSTANDARD LVCMOS33} [get_ports { on[1] }]
set_property -dict { PACKAGE_PIN D15 IOSTANDARD LVCMOS33} [get_ports { on[2] }]
set_property -dict { PACKAGE_PIN A16 IOSTANDARD LVCMOS33} [get_ports { on[3] }]
set_property -dict { PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports { on[4] }]
set_property -dict { PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports { on[5] }]
set_property -dict { PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports { on[6] }]
set_property -dict { PACKAGE_PIN K22 IOSTANDARD LVCMOS33} [get_ports { on[7] }]
set_property -dict { PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports { on[8] }]
set_property -dict { PACKAGE_PIN AB13 IOSTANDARD LVCMOS33} [get_ports {on[9] }]
set_property -dict { PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports { on[10] }]
set_property -dict { PACKAGE_PIN A11 IOSTANDARD LVCMOS33} [get_ports { on[11] }]

set_property -dict { PACKAGE_PIN F13 IOSTANDARD LVCMOS33}  [get_ports { alertL[0] }]
set_property -dict { PACKAGE_PIN E13 IOSTANDARD LVCMOS33}  [get_ports { alertL[1] }]
set_property -dict { PACKAGE_PIN B15 IOSTANDARD LVCMOS33}  [get_ports { alertL[2] }]
set_property -dict { PACKAGE_PIN A13 IOSTANDARD LVCMOS33}  [get_ports { alertL[3] }]
set_property -dict { PACKAGE_PIN H13 IOSTANDARD LVCMOS33}  [get_ports { alertL[4] }]
set_property -dict { PACKAGE_PIN H14 IOSTANDARD LVCMOS33}  [get_ports { alertL[5] }]
set_property -dict { PACKAGE_PIN H18 IOSTANDARD LVCMOS33}  [get_ports { alertL[6] }]
set_property -dict { PACKAGE_PIN M21 IOSTANDARD LVCMOS33}  [get_ports { alertL[7] }]
set_property -dict { PACKAGE_PIN Y16 IOSTANDARD LVCMOS33}  [get_ports { alertL[8] }]
set_property -dict { PACKAGE_PIN AA15 IOSTANDARD LVCMOS33} [get_ports { alertL[9] }]
set_property -dict { PACKAGE_PIN AB11 IOSTANDARD LVCMOS33} [get_ports { alertL[10] }]
set_property -dict { PACKAGE_PIN V10 IOSTANDARD LVCMOS33}  [get_ports { alertL[11] }]

set_property -dict { PACKAGE_PIN F14  IOSTANDARD LVCMOS33}  [get_ports { pwm[0] }]
set_property -dict { PACKAGE_PIN E14  IOSTANDARD LVCMOS33}  [get_ports { pwm[1] }]
set_property -dict { PACKAGE_PIN B16  IOSTANDARD LVCMOS33}  [get_ports { pwm[2] }]
set_property -dict { PACKAGE_PIN A14  IOSTANDARD LVCMOS33}  [get_ports { pwm[3] }]
set_property -dict { PACKAGE_PIN G13  IOSTANDARD LVCMOS33}  [get_ports { pwm[4] }]
set_property -dict { PACKAGE_PIN G18  IOSTANDARD LVCMOS33}  [get_ports { pwm[5] }]
set_property -dict { PACKAGE_PIN H22  IOSTANDARD LVCMOS33}  [get_ports { pwm[6] }]
set_property -dict { PACKAGE_PIN L21  IOSTANDARD LVCMOS33}  [get_ports { pwm[7] }]
set_property -dict { PACKAGE_PIN AA16 IOSTANDARD LVCMOS33}  [get_ports { pwm[8] }]
set_property -dict { PACKAGE_PIN AB15 IOSTANDARD LVCMOS33}  [get_ports { pwm[9] }]
set_property -dict { PACKAGE_PIN AB12 IOSTANDARD LVCMOS33}  [get_ports { pwm[10] }]
set_property -dict { PACKAGE_PIN W10  IOSTANDARD LVCMOS33}  [get_ports { pwm[11] }]

set_property -dict { PACKAGE_PIN F16  IOSTANDARD LVCMOS33}  [get_ports { chSda[0] }]
set_property -dict { PACKAGE_PIN E16  IOSTANDARD LVCMOS33}  [get_ports { chSda[1] }]
set_property -dict { PACKAGE_PIN C13  IOSTANDARD LVCMOS33}  [get_ports { chSda[2] }]
set_property -dict { PACKAGE_PIN B17  IOSTANDARD LVCMOS33}  [get_ports { chSda[3] }]
set_property -dict { PACKAGE_PIN G15  IOSTANDARD LVCMOS33}  [get_ports { chSda[4] }]
set_property -dict { PACKAGE_PIN J15  IOSTANDARD LVCMOS33}  [get_ports { chSda[5] }]
set_property -dict { PACKAGE_PIN H20  IOSTANDARD LVCMOS33}  [get_ports { chSda[6] }]
set_property -dict { PACKAGE_PIN J20  IOSTANDARD LVCMOS33}  [get_ports { chSda[7] }]
set_property -dict { PACKAGE_PIN AB16  IOSTANDARD LVCMOS33}  [get_ports { chSda[8] }]
set_property -dict { PACKAGE_PIN Y13  IOSTANDARD LVCMOS33}  [get_ports { chSda[9] }]
set_property -dict { PACKAGE_PIN AA9  IOSTANDARD LVCMOS33}  [get_ports { chSda[10] }]
set_property -dict { PACKAGE_PIN Y11  IOSTANDARD LVCMOS33}  [get_ports { chSda[11] }]

set_property -dict { PACKAGE_PIN E17  IOSTANDARD LVCMOS33}  [get_ports { chScl[0] }]
set_property -dict { PACKAGE_PIN D16  IOSTANDARD LVCMOS33}  [get_ports { chScl[1] }]
set_property -dict { PACKAGE_PIN B13  IOSTANDARD LVCMOS33}  [get_ports { chScl[2] }]
set_property -dict { PACKAGE_PIN B18  IOSTANDARD LVCMOS33}  [get_ports { chScl[3] }]
set_property -dict { PACKAGE_PIN G16  IOSTANDARD LVCMOS33}  [get_ports { chScl[4] }]
set_property -dict { PACKAGE_PIN H15  IOSTANDARD LVCMOS33}  [get_ports { chScl[5] }]
set_property -dict { PACKAGE_PIN G20  IOSTANDARD LVCMOS33}  [get_ports { chScl[6] }]
set_property -dict { PACKAGE_PIN J21  IOSTANDARD LVCMOS33}  [get_ports { chScl[7] }]
set_property -dict { PACKAGE_PIN AB17  IOSTANDARD LVCMOS33}  [get_ports { chScl[8] }]
set_property -dict { PACKAGE_PIN AA14  IOSTANDARD LVCMOS33}  [get_ports { chScl[9] }]
set_property -dict { PACKAGE_PIN AB10  IOSTANDARD LVCMOS33}  [get_ports { chScl[10] }]
set_property -dict { PACKAGE_PIN Y12  IOSTANDARD LVCMOS33}  [get_ports { chScl[11] }]

set_property -dict { PACKAGE_PIN C17  IOSTANDARD LVCMOS33}  [get_ports { acOk[0] }]
set_property -dict { PACKAGE_PIN C18  IOSTANDARD LVCMOS33}  [get_ports { acOk[1] }]
set_property -dict { PACKAGE_PIN C19  IOSTANDARD LVCMOS33}  [get_ports { acOk[2] }]
set_property -dict { PACKAGE_PIN E19  IOSTANDARD LVCMOS33}  [get_ports { acOk[3] }]
set_property -dict { PACKAGE_PIN D19  IOSTANDARD LVCMOS33}  [get_ports { acOk[4] }]
set_property -dict { PACKAGE_PIN F18  IOSTANDARD LVCMOS33}  [get_ports { acOk[5] }]

set_property -dict { PACKAGE_PIN A20  IOSTANDARD LVCMOS33}  [get_ports { pwrOk[0] }]
set_property -dict { PACKAGE_PIN A18  IOSTANDARD LVCMOS33}  [get_ports { pwrOk[1] }]
set_property -dict { PACKAGE_PIN A19  IOSTANDARD LVCMOS33}  [get_ports { pwrOk[2] }]
set_property -dict { PACKAGE_PIN F19  IOSTANDARD LVCMOS33}  [get_ports { pwrOk[3] }]
set_property -dict { PACKAGE_PIN F20  IOSTANDARD LVCMOS33}  [get_ports { pwrOk[4] }]
set_property -dict { PACKAGE_PIN D20  IOSTANDARD LVCMOS33}  [get_ports { pwrOk[5] }]

set_property -dict { PACKAGE_PIN C22  IOSTANDARD LVCMOS33}  [get_ports { otw[0] }]
set_property -dict { PACKAGE_PIN B22  IOSTANDARD LVCMOS33}  [get_ports { otw[1] }]
set_property -dict { PACKAGE_PIN B21  IOSTANDARD LVCMOS33}  [get_ports { otw[2] }]
set_property -dict { PACKAGE_PIN A21  IOSTANDARD LVCMOS33}  [get_ports { otw[3] }]
set_property -dict { PACKAGE_PIN E22  IOSTANDARD LVCMOS33}  [get_ports { otw[4] }]
set_property -dict { PACKAGE_PIN D22  IOSTANDARD LVCMOS33}  [get_ports { otw[5] }]

set_property -dict { PACKAGE_PIN H19  IOSTANDARD LVCMOS33}  [get_ports { remoteOnL[0] }]
set_property -dict { PACKAGE_PIN K18  IOSTANDARD LVCMOS33}  [get_ports { remoteOnL[1] }]
set_property -dict { PACKAGE_PIN K19  IOSTANDARD LVCMOS33}  [get_ports { remoteOnL[2] }]
set_property -dict { PACKAGE_PIN L19  IOSTANDARD LVCMOS33}  [get_ports { remoteOnL[3] }]
set_property -dict { PACKAGE_PIN L20  IOSTANDARD LVCMOS33}  [get_ports { remoteOnL[4] }]
set_property -dict { PACKAGE_PIN N22  IOSTANDARD LVCMOS33}  [get_ports { remoteOnL[5] }]

set_property -dict { PACKAGE_PIN M18  IOSTANDARD LVCMOS33}  [get_ports { psSda[0] }]
set_property -dict { PACKAGE_PIN L18  IOSTANDARD LVCMOS33}  [get_ports { psSda[1] }]
set_property -dict { PACKAGE_PIN N18  IOSTANDARD LVCMOS33}  [get_ports { psSda[2] }]
set_property -dict { PACKAGE_PIN N19  IOSTANDARD LVCMOS33}  [get_ports { psSda[3] }]
set_property -dict { PACKAGE_PIN N20  IOSTANDARD LVCMOS33}  [get_ports { psSda[4] }]
set_property -dict { PACKAGE_PIN M20  IOSTANDARD LVCMOS33}  [get_ports { psSda[5] }]

set_property -dict { PACKAGE_PIN K14  IOSTANDARD LVCMOS33}  [get_ports { psScl[0] }]
set_property -dict { PACKAGE_PIN M13  IOSTANDARD LVCMOS33}  [get_ports { psScl[1] }]
set_property -dict { PACKAGE_PIN L13  IOSTANDARD LVCMOS33}  [get_ports { psScl[2] }]
set_property -dict { PACKAGE_PIN K17  IOSTANDARD LVCMOS33}  [get_ports { psScl[3] }]
set_property -dict { PACKAGE_PIN J17  IOSTANDARD LVCMOS33}  [get_ports { psScl[4] }]
set_property -dict { PACKAGE_PIN L14  IOSTANDARD LVCMOS33}  [get_ports { psScl[5] }]

set_property -dict { PACKAGE_PIN T14  IOSTANDARD LVCMOS33}  [get_ports { psEnable[0] }]
set_property -dict { PACKAGE_PIN T15  IOSTANDARD LVCMOS33}  [get_ports { psEnable[1] }]
set_property -dict { PACKAGE_PIN W15  IOSTANDARD LVCMOS33}  [get_ports { psEnable[2] }]
set_property -dict { PACKAGE_PIN W16  IOSTANDARD LVCMOS33}  [get_ports { psEnable[3] }]
set_property -dict { PACKAGE_PIN T16  IOSTANDARD LVCMOS33}  [get_ports { psEnable[4] }]
set_property -dict { PACKAGE_PIN U16  IOSTANDARD LVCMOS33}  [get_ports { psEnable[5] }]

set_property -dict { PACKAGE_PIN V13  IOSTANDARD LVCMOS33}  [get_ports { cryoEnL }]
set_property -dict { PACKAGE_PIN V14  IOSTANDARD LVCMOS33}  [get_ports { coldplateEnL }]





###########################################################################################
