from gym import Env
from gym.spaces import Discrete, Box
import numpy as np
from scipy.integrate import odeint
from numpy import polyval

y1 = 0.0
y2 = 0.0, 0.0
i = 0


class AeroEnv(Env):
    def __init__(self):
        # RPM action
        self.action_space = Discrete(7)
        # vector of 5 observations: sin(theta), cos(theta), thetaD, thetaDD, err_theta
        self.observation_space = Box(-10000, 10000, shape=(6,), dtype=float)
        # Parameters
        self.m = 0.120  # masa wahadla [kg]
        self.g = 9.81  # przyspieszenie grawitacyjne [m/s^2]
        self.c = 0.007  # tarcie wiskotyczne [Nms/rad]
        self.l = 0.25  # dlugosc wahadla [m]
        self.J = self.m * self.l * self.l  # moment bezwladnosci [kgm^2]
        self.d = 0.25  # odleglosc osi od srodka masy
        self.y = 0.0
        self.ts = 0.01
        # Ode coef
        self.a = self.c / self.J
        self.b = self.m * self.g * self.d / self.J
        self.c = self.l / self.J

        self.rpm = 0.0

        self.thetaD_old = 0.0
        self.theta_old = 0.0

        self.reward = 0.0
        self.val = 0.0
        self.theta = 0.0
        self.thetaD = 0.0
        self.thetaDD = 0.0
        self.theta_err = 0.0


    def step(self, action):
        theta_ref = 35
        global i

        # Calc rpm
        action = (action - 3) * 1000  # zakres -2000:1000:4000
        print("Action: {}.".format(action))

        # integrate action
        def func0(y, t):
            dydt = action
            return dydt

        x = odeint(func0, y1, [0.0, self.ts])
        print("RPM_calc: {}.".format(x[1]))

        self.rpm += x[1]
        print("RPM_sum: {}.".format(self.rpm))

        val = 0.0
        if self.rpm > 0:
            val = polyval([0.00000304986021927422, -0.00476887717971010, 2.51670431281220], self.rpm)
        else:
            val = polyval([-5.46944010985214e-06, -0.00938361577873603, -2.43262552689868], self.rpm)
        val = val * (np.pi / 180)  # deg to rad

        def function(y, t, a, b, c, u):
            dydt1 = y[1]
            dydt2 = -a * y[1] - b * np.sin(y[0]) + c * u
            dydt = [dydt1, dydt2]
            return dydt

        global y2

        self.thetaDD = -self.a * self.thetaD_old - self.b * np.sin(self.theta_old) + self.c * val
        print("ThetaDD: {}.".format(self.thetaDD))
        # ODEINT
        x1 = odeint(function, y2, [0.0, self.ts], args=(self.a, self.b, self.c, val))
        y2 = x1[1]

        self.thetaD = y2[1]
        print("ThetaD: {}.".format(self.thetaD))
        self.thetaD_old = self.thetaD

        self.theta = y2[0]
        self.theta_old = self.theta
        print("Theta: {}.".format(self.theta))

        self.theta = self.theta * (180 / np.pi)  # radToDe

        # Calc Reward
        self.theta_err = theta_ref - self.theta
        self.reward = float(self.theta_err * self.theta_err * (-0.001))

        # Observations
        obs = np.array([np.sin(self.theta), np.cos(self.theta), self.thetaD, float(self.thetaDD), self.theta_err, action], dtype=np.float32)

        done = False

        info = {}

        return obs, self.reward, done, info

    def reset(self):
        self.theta = 0.0
        self.thetaD = 0.0
        self.thetaDD = 0.0
        self.theta_err = 0.0
        self.rpm= 0
        return np.array([np.cos(self.theta), np.sin(self.theta), self.thetaD,
                         self.thetaDD, self.theta_err, self.rpm], dtype=np.float32)

    def render(self):
        pass
