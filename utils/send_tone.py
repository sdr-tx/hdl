import serial
from math import pi, sin
import numpy as np
import argparse

max_value = 255

def send_data_forever(tty, data):
    while True:
 #       print(data)
        tty.write(data)
#        return


def get_sin_period():#fo, fs, max_value):
#    N = int(fs / fo)
#    integer_sin = lambda x: round(max_value * (sin(pi * 2 * x / N) / 2 + 1/2))
    N = 2
    packet = bytearray()
    packet.append(0x03)
    packet.append(0x06)
    packet.append(0x09)
    packet.append(0x0C)
#    integer_sin[0] = 6 # 1100
#    integer_sin[1] = 3 # 0011
#    integer_sin[2] = 12 # 0110 0xC
#    integer_sin[3] = 9 # 1001
#    return b''.join([integer_sin(i).to_bytes(1, 'little') for i in range(N)])
    return packet
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
#    parser.add_argument('--fs', type=float, default=1e6, help='Sampling frequency (default: 1e6)')
#    parser.add_argument('--fo', type=float, default=1e3, help='Tone frequency (default: 1e3)')
#    parser.add_argument('--max', type=int, default=255, help='Max value (default: 255)')
    parser.add_argument('tty', type=str, help='tty')
    args = parser.parse_args()

    data = get_sin_period()#args.fo, args.fs, args.max)
    with serial.Serial(args.tty) as tty:
        send_data_forever(tty, data)
