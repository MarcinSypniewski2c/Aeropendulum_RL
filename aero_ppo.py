from AeroEnv import AeroEnv
import os
from stable_baselines3 import PPO
import torch as th
from stable_baselines3.common.evaluation import evaluate_policy
from stable_baselines3.common.monitor import Monitor
from stable_baselines3.common.env_checker import check_env


with open('square_signal.csv', 'r') as file:
    signal = file.readlines()

# Create env
env = AeroEnv()
env = Monitor(env)

check_env(env)


# PPO
actions = 179
log_path = os.path.join('Logs')
policy_kwargs = dict(activation_fn=th.nn.ReLU,
                     net_arch=[dict(pi=[6, 3, 2, actions], qf=[6, 3, 3, 1])])

model = PPO("MlpPolicy",
            env,
            verbose=1,
            policy_kwargs=policy_kwargs,
            n_steps=32,  # The number of steps to run for each environment per update
            learning_rate=0.008,
            batch_size=32,
            gamma=0.95,  # discount factor,
            clip_range=0.2,  # clip factor??
            ent_coef=0.01,  # entropy coef
            tensorboard_log=log_path
            )
# Training

model.learn(total_timesteps=4000)

PPO_path = os.path.join('Saved Models', 'PPO_model')
model.save(PPO_path)

#Evaluate
#avg_reward, x = evaluate_policy(model, env, n_eval_episodes=50) #returns average reward
#print(avg_reward)

# Test model
obs = env.reset()
for i in range(5):
    action, _states = model.predict(obs)
    obs, reward, done, info = env.step(action)
    print("Iteration: {} ------------".format(i))
    print("Reward:{}".format(reward))
    print("RPM:{}".format(obs[5]))
    print("Obs::{}".format(obs))





