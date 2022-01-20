%Training Options for multiple ref value steps
trainOpts = rlTrainingOptions;

max_eps = 3000;
max_steps=10/Ts;

trainOpts.MaxEpisodes = max_eps;
trainOpts.MaxStepsPerEpisode = max_steps;
trainOpts.StopTrainingCriteria = "AverageReward";
trainOpts.StopTrainingValue = 0;
trainOpts.ScoreAveragingWindowLength = 5;

%Save agent
agent_number = 3;
save_dir = "savedAgents/Agent" + agent_number;

trainOpts.SaveAgentCriteria = "EpisodeReward";
trainOpts.SaveAgentValue = -130;
trainOpts.SaveAgentDirectory = save_dir;

%Plot
trainOpts.Verbose = false;
trainOpts.Plots = "training-progress";

%Training with save loop
trainingInfo = train(agent,env,trainOpts);