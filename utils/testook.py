import serial
from math import pi, sin
import numpy as np
import argparse

def send_data_forever(tty, data):
    while True:
        tty.write(data)

def get_sin_period():
    packet = bytearray()
    symbol_repeat = 10

    carrier_frequency = 150000000 / (4*10);
    symbol_rate = carrier_frequency / symbol_repeat

    print('Carrier frequency : ' + str(carrier_frequency))
    print('Symbol rate : ' + str(symbol_rate))

    for i in range(1, symbol_repeat):
        packet.append(0x01) # 0001 = 0x01

    for i in range(1, symbol_repeat):
        packet.append(0x00) # 0000 = 0x00
    return packet

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('tty', type=str, help='tty')
    args = parser.parse_args()

    data = get_sin_period()
    with serial.Serial(args.tty) as tty:
        send_data_forever(tty, data)
