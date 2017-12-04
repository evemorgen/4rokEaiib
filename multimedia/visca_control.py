import time
import serial
import yaml
import fire
import sys
import subprocess
import struct

mock = False


class Commands(object):

    def __init__(self):
        self.commands = yaml.load(open('commands.yaml'))["commands"]
        self.cam = 1
        if mock is False:
            self.ser = serial.Serial('/dev/tty.wchusbserial1420', 9600)
            pass
        else:
            print("Would open serial port: %s with speed %s" % ('/dev/tty.wchusbserial1420', 9600))

    def call_command(self, command):
        if mock is False:
            print("Sending %s to camera" % command)
            # "0x81 0x01 0x06 0x01 0x05 0x05 0x03 0x01 0xFF"
            # self.ser.write(bytearray("0x88 0x01 0x06 0x04 0xFF"))
            self.ser.write(bytearray([int(x, 16) for x in command.split(" ")]))
            #while True:
            time.sleep(1)
            out = self.ser.read(self.ser.inWaiting())
            codes = struct.unpack("<" + "B" * len(out), out)
            if len(codes) > 0 and codes[1] == 96:
                print("ERROR FOUND -  %s" % str(codes))
            else:
                print("OK - %s" % str(codes))
        else:
            print("Would send command to camera %s: %s" % (self.cam, command))

    def up(self, pan_speed=None, tilt_speed=None):
        pan_speed = self.commands["up"]["defaults"][0] if pan_speed is None else pan_speed
        tilt_speed = self.commands["up"]["defaults"][1] if tilt_speed is None else tilt_speed
        self.call_command(self.commands["up"]["command"] % (self.cam, pan_speed, tilt_speed))
        return self

    def down(self, pan_speed=None, tilt_speed=None):
        pan_speed = self.commands["up"]["defaults"][0] if pan_speed is None else pan_speed
        tilt_speed = self.commands["up"]["defaults"][1] if tilt_speed is None else tilt_speed
        self.call_command(self.commands["down"]["command"] % (self.cam, pan_speed, tilt_speed))
        return self

    def left(self, pan_speed=None, tilt_speed=None):
        pan_speed = self.commands["up"]["defaults"][0] if pan_speed is None else pan_speed
        tilt_speed = self.commands["up"]["defaults"][1] if tilt_speed is None else tilt_speed
        self.call_command(self.commands["left"]["command"] % (self.cam, pan_speed, tilt_speed))
        return self

    def right(self, pan_speed=None, tilt_speed=None):
        pan_speed = self.commands["up"]["defaults"][0] if pan_speed is None else pan_speed
        tilt_speed = self.commands["up"]["defaults"][1] if tilt_speed is None else tilt_speed
        self.call_command(self.commands["right"]["command"] % (self.cam, pan_speed, tilt_speed))
        return self

    def home(self):
        self.call_command(self.commands["home"]["command"] % self.cam)
        return self

    def tele(self, speed=None):
        speed = self.commands["tele"]["defaults"][0] if speed is None else speed
        self.call_command(self.commands["tele"]["command"] % (self.cam, speed))
        return self

    def wide(self, speed=None):
        speed = self.commands["tele"]["defaults"][0] if speed is None else speed
        self.call_command(self.commands["wide"]["command"] % (self.cam, speed))
        return self

    def camera(self, num=None):
        self.cam = num
        return self

    def sleep(self, period=1):
        if mock is False:
            time.sleep(period)
        else:
            print("Would sleep for %s seconds" % period)
        return self

    def end(self):
        pass


if __name__ == '__main__':
    macros = yaml.load(open('macros.yaml'))
    if "macro" in sys.argv:
        macros[sys.argv[2]] = sys.argv[3]
        with open('macros.yaml', 'w') as yaml_file:
            yaml.dump(macros, yaml_file, default_flow_style=False)
    else:
        for arg in sys.argv:
            if arg in macros:
                command = "python3 `pwd`/visca_control.py %s" % macros[arg]
                process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
                outs, errs = process.communicate(timeout=10)
                if outs is not None:
                    print(outs.decode('utf-8'))
                if errs is not None:
                    print(errs.decode('utf-8'))
                sys.exit(0)
        fire.Fire(Commands)
