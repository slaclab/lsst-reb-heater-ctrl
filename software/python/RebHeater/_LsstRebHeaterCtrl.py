import rogue
import pyrogue as pr

import LsstPwrCtrlCore as lsst
import LsstPwrCtrlCore.i2c as i2c

BASE_FREQUENCY = 200e6
BASE_PERIOD = 1/BASE_FREQUENCY

class RebHeaterPwmChannel(pr.Device):
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
            value = 249,
            disp = '{:d}'))

        self.add(pr.RemoteVariable(
            name = 'LowCount',
            mode = 'RW',
            offset = 0,
            bitOffset = 9,
            bitSize = 9,
            base = pr.UInt,
            value = 249,
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
            disp = '{:.4f}',            
            #value = 500,
            dependencies = deps,
            linkedGet = lambda: 1.0e-3 / (BASE_PERIOD * (2+self.HighCount.value()+self.LowCount.value())),
            linkedSet = setFreq))

        self.add(pr.LinkVariable(
            name = 'DutyCycle',
            mode = 'RW',
            units = 'frac-high',
            disp = '{:1.4f}',
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
            linkedSet = lambda value: self.DelayCount.set(round((value / 360) * (self.HighCount.value() + self.LowCount.value() + 2)))))

        self.add(pr.RemoteVariable(
            name = 'HighCountRB',
            mode = 'RO',
            disp = '{:d}',
            hidden = True,
            offset = 0x4,
            bitOffset = 0,
            bitSize = 9,
            base = pr.UInt))

        self.add(pr.RemoteVariable(
            name = 'LowCountRB',
            mode = 'RO',
            disp = '{:d}',
            hidden = True,
            offset = 0x4,
            bitOffset = 9,
            bitSize = 9,
            base = pr.UInt))

        self.add(pr.RemoteVariable(
            name = 'DelayCountRb',
            mode = 'RO',
            disp = '{:d}',
            hidden = True,
            offset = 0x4,
            bitOffset = 18,
            bitSize = 9,
            base = pr.UInt))
                

class RebPwmCtrl(pr.Device):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        for i in range(12):
            self.add(RebHeaterPwmChannel(
                name = f'Channel[{i}]',
                enabled = False,
                offset = i*8))

        self.add(pr.RemoteCommand(
            name = 'AlignChannels',
            offset = 12*8,
            bitSize = 12,
            function = pr.RemoteCommand.touch))

        
class RebHeaterCtrlChannel(pr.Device):
    def __init__(self, pwm, ltc2945, **kwargs):
        super().__init__(**kwargs)

        self.add(pr.LinkVariable(
            name = 'OutputEnable',
            variable = pwm.OutputEnable))            

        self.add(pr.LinkVariable(
            name = 'Frequency',
            variable = pwm.Frequency))

        self.add(pr.LinkVariable(
            name = 'DutyCycle',
            variable = pwm.DutyCycle))

        self.add(pr.LinkVariable(
            name = 'PhaseOffset',
            variable = pwm.PhaseOffset))

        self.add(pr.LinkVariable(
            name = 'Power',
            variable = ltc2945.Power))

        self.add(pr.LinkVariable(
            name = 'Current',
            variable = ltc2945.Current))

        self.add(pr.LinkVariable(
            name = 'Voltage',
            variable = ltc2945.Vin))
        
        

class LambdaChannel(pr.Device):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.add(pr.RemoteVariable(
            name = 'RemoteOn',
            mode = 'RW',
            offset = 0,
            bitOffset = 0,
            bitSize = 1,
            enum = {1: 'False', 0: 'True'})) # Active Low
            
        self.add(pr.RemoteVariable(
            name = 'Enabled',
            mode = 'RO',
            offset = 0,
            bitOffset = 1,
            bitSize = 1,
            base = pr.Bool))

        self.add(pr.RemoteVariable(
            name = 'AcOk',
            mode = 'RO',
            offset = 0,
            bitOffset = 2,
            bitSize = 1,
            base = pr.Bool))

        self.add(pr.RemoteVariable(
            name = 'PwrOk',
            mode = 'RO',
            offset = 0,
            bitOffset = 3,
            bitSize = 1,
            base = pr.Bool))

        self.add(pr.RemoteVariable(
            name = 'Otw',
            mode = 'RO',
            offset = 0,
            bitOffset = 4,
            bitSize = 1,
            base = pr.Bool))
        
class LambdaIO(pr.Device):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        for i in range(6):
            self.add(LambdaChannel(
                name = f'Channel[{i}]',
                offset = i*4))

class Interlocks(pr.Device):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.add(pr.RemoteVariable(
            name = "CryoEn",
            offset = 0,
            bitOffset = 0,
            bitSize = 1,
            base = pr.Bool))
        
        self.add(pr.RemoteVariable(
            name = "ColdplateEn",
            offset = 0,
            bitOffset = 1,
            bitSize = 1,
            base = pr.Bool))

        
class LsstRebHeaterCtrl(pr.Device):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        self.add(lsst.LsstPwrCtrlCore())

        self.add(Interlocks(
            offset = lsst.AXIL_OFFSETS[3]))

        self.add(RebPwmCtrl(
            hidden = False,
            enabled = False,
            offset = lsst.AXIL_OFFSETS[0]))

        self.add(pr.Device(
            name = 'HeaterADCs',
            offset = lsst.AXIL_OFFSETS[1]))
        
        for i in range(12):
            self.HeaterADCs.add(i2c.Ltc2945(
                name = f'Ltc2945[{i}]',
                enabled = False,
                hidden = False,
                offset = (i * 0x1000),
                shunt = 0.02
            ))

        self.add(pr.Device(name='RebHeaterChannels'))
        for i in range(12):
            self.RebHeaterChannels.add(RebHeaterCtrlChannel(
                name = f'RebHeaterChannel[{i}]',
                pwm = self.RebPwmCtrl.Channel[i],
                ltc2945 = self.HeaterADCs.Ltc2945[i]))

        for i in range(6):
            self.add(i2c.LambdaSupply(
                name = f'LambdaSupply[{i}]',
                offset = lsst.AXIL_OFFSETS[2]+(i*1000)))
        #self.add(LambdaIO(
        #    offset = lsst.AXIL_OFFSETS[2]+0x6000))

        
class LsstRebHeaterCtrlRoot(lsst.LsstPwrCtrlRoot):
    def __init__(self, pollEn=False, **kwargs):
        super().__init__(**kwargs)

        print(kwargs)
        
        self.add(LsstRebHeaterCtrl(
            memBase = self.srp))

        self.start(timeout=10000000, pollEn=pollEn)
        self.LsstRebHeaterCtrl.LsstPwrCtrlCore.Xadc.enable.set(False)
        self.LsstRebHeaterCtrl.LsstPwrCtrlCore.AxiMicronN25Q.enable.set(False)

    
    
                 
                 
