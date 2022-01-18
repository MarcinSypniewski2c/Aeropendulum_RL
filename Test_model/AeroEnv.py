from gym import Env
from gym.spaces import Discrete, Box
import numpy as np
from scipy.integrate import odeint


def inercja(y, t, u):
    dydt = u
    return dydt


class AeroEnv(Env):
    def __init__(self):
        # RPM action
        self.action_space = Discrete(179)
        # vector of 5 observations: sin(theta), cos(theta), thetaD, thetaDD, err_theta
        self.observation_space = Box(-10000, 10000, shape=(6,), dtype=float)

        self.m = 0.120  # masa wahadla [kg]
        self.g = 9.81  # przyspieszenie grawitacyjne [m/s^2]
        self.c = 0.007  # tarcie wiskotyczne [Nms/rad]
        self.l = 0.25  # dlugosc wahadla [m]
        self.J = self.m * self.l * self.l  # moment bezwladnosci [kgm^2]
        self.d = 0.25  # odleglosc osi od srodka masy
        self.y = 0.0
        self.ts = 0.01

    def step(self, action):
        # Parameters
        m = self.m
        g = self.g
        c = self.c
        l = self.l
        J = self.J
        d = self.d
        Ts = self.ts

        thetaD = 0.0
        thetaDD = 0.0
        rpm = 0
        theta_ref = 35
        reward = 0.0
        theta = [0.0]

        # set rpm (-4000:50:4900)
        rpm = (action - 81) * 50  # zakres
        # Aeropendulum
        deg = np.polyval([3.04986021927422e-06, -0.00476887717971010, 2.51670431281220], rpm)
        rad = deg * (np.pi / 180)
        print("Theta_in_rad:{}".format(rad))
        # thrust
        x = rad * (l / J)

        thetaDD = x - (thetaD * c / J) - (np.sin(theta) * m * g * d / J)

        x1 = odeint(inercja, thetaD, [0.0, Ts], args=(thetaDD,))

        thetaD = x1[1]
        print("ThetaD:{}".format(thetaD))

        x2 = odeint(inercja, theta, [0.0, Ts], args=(thetaD,))
        theta = x2[1]

        theta_deg = theta * (180 / np.pi)  # radToDeg
        print("Theta:{}".format(theta))

        # Quantizer
        theta = 0.08791209 * np.round(theta_deg * 0.08791209)

        # Calc Reward
        theta_err = theta_ref - theta
        print("Theta_err:{}".format(theta_err))
        reward = float(theta_err * theta_err * (-0.001))

        # Observations
        obs = np.array([np.sin(theta), np.cos(theta), thetaD, thetaDD, theta_err, rpm], dtype=np.float32)

        done = False

        info = {}

        return obs, reward, done, info

    def reset(self):
        theta = 0.0
        thetad = 0.0
        thetadd = 0.0
        theta_err = 0.0
        rpm = 0
        return np.array([np.cos(theta), np.sin(theta), thetad, thetadd, theta_err, rpm], dtype=np.float32)

    def render(self):
        pass
