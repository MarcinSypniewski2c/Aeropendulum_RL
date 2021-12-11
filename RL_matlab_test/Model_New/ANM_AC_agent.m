%% Agent

% Create the network to be used as approximator in the critic.
criticNetwork = [
    featureInputLayer(4,'Normalization','none','Name','state')
    fullyConnectedLayer(3,'Name','HL1')
    fullyConnectedLayer(3,'Name','HL2')
    fullyConnectedLayer(1,'Name','CriticFC')];

% Set options for the critic.
criticOpts = rlRepresentationOptions('LearnRate',8e-3,'GradientThreshold',1);

% Create the critic.
critic = rlValueRepresentation(criticNetwork,obsInfo,'Observation',{'state'},criticOpts);

% Create the network to be used as approximator in the actor.
actorNetwork = [
    featureInputLayer(4,'Normalization','none','Name','state')
    fullyConnectedLayer(3,'Name','HL1')
    fullyConnectedLayer(2,'Name','HL2')
    fullyConnectedLayer(201,'Name','action')];

% Set options for the actor.
actorOpts = rlRepresentationOptions('LearnRate',8e-3,'GradientThreshold',1);

% Create the actor.
actor = rlStochasticActorRepresentation(actorNetwork,obsInfo,actInfo,...
    'Observation',{'state'},actorOpts);

%agent
agentOpts = rlACAgentOptions();
agentOpts.NumStepsToLookAhead = 32;
agentOpts.DiscountFactor = 0.99;
agentOpts.EntropyLossWeight = 0.3;
agentOpts.SampleTime = Ts;

agent = rlACAgent(actor,critic,agentOpts);

%Plotting
actorNet = getModel(getActor(agent));
criticNet = getModel(getCritic(agent));

%Plot critic and actor networks
%criticNet.Layers
%actorNet.Layers
%plot(layerGraph(criticNet))
%plot(layerGraph(actorNet))

