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

set_property -dict { PACKAGE_PIN B4  } [get_ports { ethTxP[0]}]
set_property -dict { PACKAGE_PIN A4  } [get_ports { ethTxN[0]}]
set_property -dict { PACKAGE_PIN B8  } [get_ports { ethRxP[0]}]
set_property -dict { PACKAGE_PIN A8  } [get_ports { ethRxN[0]}]

set_property -dict { PACKAGE_PIN D5  } [get_ports { ethTxP[1]}]
set_property -dict { PACKAGE_PIN C5  } [get_ports { ethTxN[1]}]
set_property -dict { PACKAGE_PIN D11 } [get_ports { ethRxP[1]}]
set_property -dict { PACKAGE_PIN C11 } [get_ports { ethRxN[1]}]

###########################################################################################
