import gym
from gym import Env
from gym.spaces import Discrete, Box
import numpy as np
import random
import os
from stable_baselines3 import PPO
import torch as th
from stable_baselines3.common.vec_env import VecFrameStack
from stable_baselines3.common.evaluation import evaluate_policy
from scipy.integrate import odeint


class AeroEnv(Env):
    def __init__(self):
        self.theta = 0.0
        #self.thetaD = 0.0
        #self.thetaDD = 0.0
        self.rpm = 0
        self.theta_ref = 35

        # RPM action
        self.action_space = Discrete(111)
        # vector of 5 observations: sin(theta), cos(theta), thetaD, thetaDD, err_theta
        self.observation_space = Box(-10000, 10000, shape=(2, 1), dtype=float)

        self.m = 0.120  # masa wahadla [kg]
        self.g = 9.81  # przyspieszenie grawitacyjne [m/s^2]
        self.c = 0.007  # tarcie wiskotyczne [Nms/rad]
        self.l = 0.25  # dlugosc wahadla [m]
        self.J = self.m * self.l * self.l  # moment bezwladnosci [kgm^2]
        self.d = 0.25  # odleglosc osi od srodka masy
        self.y = 0.0
        self.RPM = 0

        self.ts = 0.01

    # def inercja(y, t, u):
    #    dydt = -y + u
    #   return dydt

    def step(self, action):
        # set rpm (-5000 to 6000)
        self.rpm = (action - 50) * 100  # zakres
        theta = 0
        # Reward
        theta_err = self.theta_ref - theta
        reward = np.power(theta_err, 2) * (-0.001)

        # Observations
        m = self.m
        g = self.g
        c = self.c
        l = self.l
        J = self.J
        d = self.d
        Ts = self.ts
        y0 = [0.0]
        y1 = [0.0]

        # thetaDD = rad*(l/J)

        # SUM1 = thedaDD - (thedaD*c/J) - (np.sinus(theta)*(m*g*d/J))

        # thetaD = odeint(inercja, y0, [0.0,Ts], args=(SUM1))
        # y0 = thetaD[1]
        # theta_rad = odeint(inercja, y1, [0.0,Ts], args=(thetaD,1))
        # theta = theta_rad*(180/np.pi) #radToDeg

        obs = np.array([np.cos(theta), np.sin(theta)], dtype=np.float32)  # thetaD, thetaDD todo

        return obs, reward, self.rpm

    def reset(self):
        self.theta = 0
        return self.theta

    def render(self):
        pass


env = AeroEnv()

from stable_baselines3.common.env_checker import check_env
check_env(env, warn=True)

#PPO
policy_kwargs = dict(activation_fn=th.nn.ReLU,
                     net_arch=[dict(pi=[3, 2, 111], vf=[3, 3, 1])])
model = PPO("MlpPolicy",
            env,
            verbose=1,
            policy_kwargs=policy_kwargs,
            learning_rate=0.008,
            batch_size=32,
            gamma=0.95, #discout factor,
            clip_range=0.2, #clip factor??
            ent_coef=0.01 #entropy coef
            )
#Training
model.learn(total_timesteps=4000)

#model.save("ppo_aero")

#obs = env.reset()
#action_rpm = 0
#while True:
#    action, _states = model.predict(obs)
#    obs, rewards, action_rpm = env.step(action)



