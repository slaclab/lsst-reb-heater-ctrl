import rogue
import RebHeater
import pyrogue.gui
import PyQt4.QtGui
import sys
import argparse

rogue.Logging.setFilter('pyrogue.SrpV3', rogue.Logging.Debug)
# Set the argument parser
parser = argparse.ArgumentParser()

parser.add_argument(
    "--ip", 
    type     = str,
    required = False,
    default = '192.168.1.10',
    help     = "IP address",
)  

parser.add_argument(
    "--hwEmu", 
    required = False,
    action = 'store_true',
    help     = "hardware emulation (false=normal operation, true=emulation)",
)

parser.add_argument(
    "--sim", 
    required = False,
    action = 'store_true',
    help     = "hardware emulation (false=normal operation, true=emulation)",
)  

parser.add_argument(
    "--pollEn", 
    required = False,
    action = 'store_true',
    help     = "enable auto-polling",
)

args = parser.parse_args()
print(args)

with RebHeater.LsstRebHeaterCtrlRoot(**vars(args)) as root:
    # Create GUI
    appTop = PyQt4.QtGui.QApplication(sys.argv)
    guiTop = pyrogue.gui.GuiTop(group='GUI')
    guiTop.addTree(root)
    guiTop.resize(1000,1000)

    # Run gui
    appTop.exec_()
