%Training Options
trainOpts = rlTrainingOptions;

max_eps = 55;
max_steps=2000;

%startowa i koncowa wartosc referencyjna
yref_min = 10;
yref_max = 50;
delta_yref = abs(yref_max - yref_min);
%krok zmiany wartości referencyjnej
yref_Step = 10;
%ilosc scenariuszy (roznch wartosci referencyjnych) do uczenia
num_yrefs = delta_yref/yref_Step;

trainOpts.MaxEpisodes = max_eps;
trainOpts.MaxStepsPerEpisode = max_steps;
trainOpts.StopTrainingCriteria = "AverageReward";
trainOpts.StopTrainingValue = 0;
trainOpts.ScoreAveragingWindowLength = 5;
trainOpts.StopOnError = "on";

%Save agent
trainOpts.SaveAgentCriteria = "EpisodeCount";
trainOpts.SaveAgentValue = max_eps*num_yrefs;
trainOpts.SaveAgentDirectory = "savedAgents";

%Plot
trainOpts.Verbose = false;
trainOpts.Plots = "training-progress";

yref=yref_min;

%Training loop
for i = yref_min:yref_Step:yref_max
trainingInfo = train(agent,env,trainOpts);
yref = yref + yref_Step;
end
