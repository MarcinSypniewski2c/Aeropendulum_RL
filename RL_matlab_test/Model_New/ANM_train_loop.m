%Training Options for single value loop
trainOpts = rlTrainingOptions;

max_eps = 100;
max_steps=1000;

%startowa i koncowa wartosc referencyjna
yref_min = 5;
yref_max = 45;
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
trainOpts.SaveAgentValue = max_eps;
trainOpts.SaveAgentDirectory = "savedAgents";

%Plot
trainOpts.Verbose = false;
trainOpts.Plots = "training-progress";


%Training loop
for j = (1:1:8)
yref=yref_min;
Rs = yref;
    for i = yref_min:yref_Step:yref_max
    trainingInfo = train(agent,env,trainOpts);
    yref = yref + yref_Step;
    Rs = yref;
    max_eps = max_eps + 1;
    trainOpts.MaxEpisodes = max_eps;
    trainOpts.SaveAgentValue = max_eps;
    end
end
