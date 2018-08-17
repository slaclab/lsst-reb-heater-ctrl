import rogue
import pyrogue as pr

import LsstPwrCtrlCore as lsst
import LsstPwrCtrlCore.i2c as i2c

BASE_FREQUENCY = 200e6
BASE_PERIOD = 1/BASE_FREQUENCY

class RebHeaterChannel(pr.Device):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        self.add(pr.RemoteVariable(
            name = 'OutputEnable',
            mode = 'RW',
            offset = 0,
            bitOffset = 27,
            bitSize = 1,
            base = pr.Bool))

        self.add(pr.RemoteVariable(
            name = 'HighCount',
            mode = 'RW',
            offset = 0,
            bitOffset = 0,
            bitSize = 9,
            base = pr.UInt,
            disp = '{:d}'))

        self.add(pr.RemoteVariable(
            name = 'LowCount',
            mode = 'RW',
            offset = 0,
            bitOffset = 9,
            bitSize = 9,
            base = pr.UInt,
            disp = '{:d}'))

        self.add(pr.RemoteVariable(
            name = 'DelayCount',
            mode = 'RW',
            offset = 0,
            bitOffset = 18,
            bitSize = 9,
            base = pr.UInt,
            disp = '{:d}'))

        def setDutyFreq(frequency, dutyFrac):
            totalCounts = int(BASE_FREQUENCY / frequency - 2)
            highCounts = int(totalCounts * dutyFrac )
            lowCounts = totalCounts - highCounts

            self.HighCount.set(highCounts, write=False)
            self.LowCount.set(lowCounts, write=True)

        def setFreq(value):
            setDutyFreq(value*1000, self.DutyCycle.value())

        def setDuty(value):
            setDutyFreq(self.Frequency.value()*1000, value)

        deps = [self.HighCount, self.LowCount, self.DelayCount]

        self.add(pr.LinkVariable(
            name = 'Frequency',
            mode = 'RW',
            units = 'kHz',
            #value = 500,
            dependencies = deps,
            linkedGet = lambda: 1.0e-3 / (BASE_PERIOD * (2+self.HighCount.value()+self.LowCount.value())),
            linkedSet = setFreq))

        self.add(pr.LinkVariable(
            name = 'DutyCycle',
            mode = 'RW',
            units = 'frac-high',
            disp = '{:1.2f}',
            #value = .5,
            dependencies = deps,
            linkedGet = lambda: ((self.HighCount.value()+1) / (self.HighCount.value() + self.LowCount.value() + 2)),
            linkedSet = setDuty))

        self.add(pr.LinkVariable(
            name = 'PhaseOffset',
            mode = 'RW',
            units = 'deg',
            dependencies = deps,
            linkedGet = lambda: ((self.DelayCount.value()) * 360) / (self.HighCount.value() + self.LowCount.value() + 2),
            linkedSet = lambda value: self.DelayCount.set(int(value / 360) * (self.HighCount.value() + self.LowCount.value() + 2))))

        self.add(pr.RemoteVariable(
            name = 'HighCountRB',
            mode = 'RO',
            disp = '{:d}',
            offset = 0xc,
            bitOffset = 0,
            bitSize = 9,
            base = pr.UInt))

        self.add(pr.RemoteVariable(
            name = 'LowCountRB',
            mode = 'RO',
            disp = '{:d}',
            offset = 0xc,
            bitOffset = 9,
            bitSize = 9,
            base = pr.UInt))

        self.add(pr.RemoteVariable(
            name = 'DelayCountRb',
            mode = 'RO',
            disp = '{:d}',
            offset = 0xc,
            bitOffset = 18,
            bitSize = 9,
            base = pr.UInt))
        



class RebPwmCtrl(pr.Device):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        for i in range(12):
            self.add(RebHeaterChannel(
                name = f'Channel[{i}]',
                offset = i*4))
                

class LsstRebHeaterCtrl(pr.Device):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        self.add(lsst.LsstPwrCtrlCore())

        self.add(RebPwmCtrl(
            offset = lsst.AXIL_OFFSETS[0]))

        for i in range(12):
            self.add(i2c.Ltc2945(
                name = f'Ltc2945[{i}]',
                enabled = False,
                offset = lsst.AXIL_OFFSETS[1] + (i * 0x1000),
                shunt = 0.02
            ))

        
class LsstRebHeaterCtrlRoot(lsst.LsstPwrCtrlRoot):
    def __init__(self, pollEn=False, **kwargs):
        super().__init__(**kwargs)

        self.add(LsstRebHeaterCtrl(
            memBase = self.srp))

        self.start(pollEn=pollEn)

    
    
                 
                 
