from AeroEnv import AeroEnv
import numpy as np
from scipy.integrate import odeint
import csv


def inercja(y, t, u):
    dydt = u
    return dydt

square_signal = []
with open('square_signal.csv', 'r') as file:
    signal = file.readline()

square_signal = signal.split(',')

# perform conversion
for i in range(0, len(square_signal)):
    square_signal[i] = int(square_signal[i])

env = AeroEnv()
m = 0.120  # masa wahadla [kg]
g = 9.81  # przyspieszenie grawitacyjne [m/s^2]
c = 0.007  # tarcie wiskotyczne [Nms/rad]
l = 0.25  # dlugosc wahadla [m]
J = m * l * l  # moment bezwladnosci [kgm^2]
d = 0.25  # odleglosc osi od srodka masy
y = 0.0
Ts = 0.01

theta = [0.0]
thetaD = 0.0
thetaDD = 0.0

f = open('python_output.csv', 'w', newline='')
writer = csv.writer(f, delimiter=',')

for x in range(0, len(square_signal)):
    deg = np.polyval([3.04986021927422e-06, -0.00476887717971010, 2.51670431281220], x)
    rad = deg * (np.pi / 180)
    # thrust
    x = rad * (l / J)

    thetaDD = x - (thetaD * c / J) - (np.sin(theta) * m * g * d / J)

    x1 = odeint(inercja, thetaD, [0.0, Ts], args=(thetaDD,))

    thetaD = x1[1]

    x2 = odeint(inercja, theta, [0.0, Ts], args=(thetaD,))
    theta = x2[1]

    theta_deg = theta * (180 / np.pi)  # radToDeg

    # Quantizer
    #theta = 0.08791209 * np.round(theta_deg * 0.08791209)
    writer.writerow(theta_deg)


file.close()
f.close()