%% Agent

% Create the network to be used as approximator in the critic.
criticNetwork = [
    featureInputLayer(obsInfo.Dimension(1),'Normalization','none','Name','state')
    fullyConnectedLayer(3,'Name','HL1')
    fullyConnectedLayer(2,'Name','HL2')
    fullyConnectedLayer(1,'Name','CriticFC')];

% Set options for the critic.
criticOpts = rlRepresentationOptions('LearnRate',8e-3,'GradientThreshold',1);

% Create the critic.
critic = rlValueRepresentation(criticNetwork,obsInfo,'Observation',{'state'},criticOpts);

% Create the network to be used as approximator in the actor.
actorNetwork = [
    featureInputLayer(obsInfo.Dimension(1),'Normalization','none','Name','state')
    fullyConnectedLayer(3,'Name','HL1')
    fullyConnectedLayer(2,'Name','HL2')
    fullyConnectedLayer(Num_of_actions,'Name','action')];

% Set options for the actor.
actorOpts = rlRepresentationOptions('LearnRate',8e-3,'GradientThreshold',1);

% Create the actor.
actor = rlStochasticActorRepresentation(actorNetwork,obsInfo,actInfo,'Observation',{'state'},actorOpts);

agentOpts = rlPPOAgentOptions();

agentOpts.ExperienceHorizon = 1024;
agentOpts.DiscountFactor = 0.95;
agentOpts.MiniBatchSize = 128;
agentOpts.ClipFactor = 0.15;
agentOpts.EntropyLossWeight = 0.02;
agentOpts.SampleTime = Ts;

agent = rlPPOAgent(actor,critic,agentOpts);

%actorNet = getModel(getActor(agent));
%criticNet = getModel(getCritic(agent));

%Plot critic and actor networks
%criticNet.Layers
%actorNet.Layers
%plot(layerGraph(criticNet))
%plot(layerGraph(actorNet))