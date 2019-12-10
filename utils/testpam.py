import serial
from math import pi, sin
import numpy as np
import argparse
import struct
import time

max_value = 255

def send_data_forever(tty, data):
    while True:
        for d in data.tobytes():
            tty.write(d)
            # tty.write(0struct.pack(">H", data[i]))
            # print(d)
            # time.sleepo(2)

def get_sin_period(fo, fs, max_value):
    a = np.array(range(0, 255), dtype=np.uint8)
    return a

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--fs', type=float, default=1e6, help='Sampling frequency (default: 1e6)')
    parser.add_argument('--fo', type=float, default=1e3, help='Tone frequency (default: 1e3)')
    parser.add_argument('--max', type=int, default=255, help='Max value (default: 255)')
    parser.add_argument('tty', type=str, help='tty')
    args = parser.parse_args()

    data = get_sin_period(args.fo, args.fs, args.max)
    with serial.Serial(args.tty) as tty:
        send_data_forever(tty, data)
