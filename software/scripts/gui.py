import rogue
import RebHeater
import pyrogue.gui
import PyQt4.QtGui
import sys

rogue.Logging.setFilter('pyrogue.SrpV3', rogue.Logging.Debug)

with RebHeater.LsstRebHeaterCtrlRoot() as root:
    # Create GUI
    appTop = PyQt4.QtGui.QApplication(sys.argv)
    guiTop = pyrogue.gui.GuiTop(group='GUI')
    guiTop.addTree(root)
    guiTop.resize(1000,1000)

    # Run gui
    appTop.exec_()
