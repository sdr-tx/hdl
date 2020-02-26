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

    # qpsk
    # packet.append(0x33) # 1100 -> 0011 = 0x03
    # packet.append(0x66) # 0110 -> 0110 = 0x06
    # packet.append(0x99) # 1001 -> 1001 = 0x09
    # packet.append(0xCC) # 0011 -> 1100 = 0x0C

    # 8psk
    packet.append(0x0F) # 1100 -> 0011 = 0x03
    packet.append(0x1E) # 0110 -> 0110 = 0x06
    packet.append(0x3C) # 1001 -> 1001 = 0x09
    packet.append(0x78) # 0011 -> 1100 = 0x0C

    packet.append(0xF0) # 1100 -> 0011 = 0x03
    packet.append(0xE1) # 0110 -> 0110 = 0x06
    packet.append(0xC3) # 1001 -> 1001 = 0x09
    packet.append(0x87) # 0011 -> 1100 = 0x0C

    # for i in range(1, symbol_repeat):
    #     packet.append(0x33) # 1100 -> 0011 = 0x03

    # for i in range(1, symbol_repeat):
    #     packet.append(0x66) # 0110 -> 0110 = 0x06

    # for i in range(1, symbol_repeat):
    #     packet.append(0xCC) # 0011 -> 1100 = 0x0C

    # for i in range(1, symbol_repeat):
    #     packet.append(0x99) # 1001 ->  1001 = 0x09
    return packet

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('tty', type=str, help='tty')
    args = parser.parse_args()

    data = get_sin_period()
    with serial.Serial(args.tty) as tty:
        send_data_forever(tty, data)
