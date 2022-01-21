import numpy as np
from scipy.integrate import odeint
import csv
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt
from numpy import polyval

i = 0.0
# Odczyt sygnalu
with open('square_signal.csv', 'r') as file:
    signal = file.readline()

tt = np.arange(0.0, 20.00, 0.01)
input_signal = np.zeros(len(tt))
square_signal = signal.split(',', maxsplit=2000)
#quare_signal.pop(2000)

for i in range(len(square_signal)):
    square_signal[i] = int(square_signal[i])
    print(square_signal[i])
    # polyval
    if square_signal[i] > 0:
        square_signal[i] = polyval([0.00000304986021927422, -0.00476887717971010, 2.51670431281220], square_signal[i])
    else:
        square_signal[i] = polyval([-5.46944010985214e-06, -0.00938361577873603, -2.43262552689868], square_signal[i])

    square_signal[i] = square_signal[i] * (np.pi / 180)  # deg to rad


#good
plt.plot(tt, square_signal, 'b')
plt.grid()
plt.show()

# Create linear interpolator
func = interp1d(tt, square_signal, bounds_error=False, fill_value="extrapolate")

#good
#plt.plot(tt, func(tt), 'g')



def function(y, t, a, b, c):
    u = func(t)
    dydt1 = y[1]
    dydt2 = -a * y[1] - b * np.sin(y[0]) + c * u
    dydt = [dydt1, dydt2]
    return dydt


y0 = [0.0, 0.0]
a = 0.933333
b = 39.2400
c = 33.3333

#ODEINT
x1 = odeint(function, y0, tt, args=(a, b, c))

#print(x1[:, 0])

theta_deg = x1[:, 0] * (180 / np.pi)  # radToDeg

#plt.plot(tt, x1[:, 1], 'g')
#plt.grid()
#plt.show()

out = [theta_deg]
#print(out)
f = open('python_output.csv', 'w', newline='')
writer = csv.writer(f, delimiter=',')
writer.writerows(out)

file.close()
f.close()
