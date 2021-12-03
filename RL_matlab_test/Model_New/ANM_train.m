%Training Options
trainOpts = rlTrainingOptions;

max_eps = 31;
max_steps=2000;

trainOpts.MaxEpisodes = max_eps;
trainOpts.MaxStepsPerEpisode = max_steps;
trainOpts.StopTrainingCriteria = "AverageReward";
trainOpts.StopTrainingValue = 0;
trainOpts.ScoreAveragingWindowLength = 5;

%Save agent
trainOpts.SaveAgentCriteria = "EpisodeCount";
trainOpts.SaveAgentValue = max_eps;
trainOpts.SaveAgentDirectory = "savedAgents";

%Plot
trainOpts.Verbose = false;
trainOpts.Plots = "training-progress";

%Training single
trainingInfo = train(agent,env,trainOpts);