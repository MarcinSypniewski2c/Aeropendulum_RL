%Training Options for multiple ref value steps
trainOpts = rlTrainingOptions;

max_eps = 1;
max_steps=length(input_yref_vector);

trainOpts.MaxEpisodes = max_eps;
trainOpts.MaxStepsPerEpisode = max_steps;
trainOpts.StopTrainingCriteria = "AverageReward";
trainOpts.StopTrainingValue = 0;
trainOpts.ScoreAveragingWindowLength = 5;

%Save agent
agent_number = 0;
save_dir = "savedAgents/Agent" + agent_number;

trainOpts.SaveAgentCriteria = "EpisodeCount";
trainOpts.SaveAgentValue = max_eps;
trainOpts.SaveAgentDirectory = save_dir;

%Plot
trainOpts.Verbose = false;
trainOpts.Plots = "training-progress";

%Training with save loop
for e = (1:1:20)
    trainingInfo = train(agent,env,trainOpts);
    agent_number = agent_number + 1;
    save_dir = "savedAgents/Agent" + agent_number;
    trainOpts.SaveAgentDirectory = save_dir;
end