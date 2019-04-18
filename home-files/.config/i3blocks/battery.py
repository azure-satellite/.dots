#! /usr/bin/env python3.7

import os

with open(os.environ['FILE']) as f:
    info = dict(map(
        lambda l: tuple(l.split('=')),
        f.read().splitlines()))

charge = int(info['POWER_SUPPLY_CHARGE_NOW']) # µAh
full = int(info['POWER_SUPPLY_CHARGE_FULL']) # µAh
voltage = int(info['POWER_SUPPLY_VOLTAGE_NOW']) # V
current = int(info['POWER_SUPPLY_CURRENT_NOW']) # µA

remain_perc = charge * 100 / full
disch_rate = ((voltage / 1000) * (current / 1000) / 10**6)
hours = charge / current
mins = (hours % 1) * 60

print(f'{remain_perc:.2f}% — {disch_rate:.2f}W — {int(hours):02d}:{int(mins):02d}')
print('')
if remain_perc < os.environ.get('LOW', 5):
    print('#FF0000')
