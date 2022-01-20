%% Agent

% create critic
criticNetwork = [
    featureInputLayer(obsInfo.Dimension(1), 'Normalization', 'none', 'Name', 'state')
    fullyConnectedLayer(4, 'Name', 'BaselineFC')
    fullyConnectedLayer(1, 'Name', 'BaselineFC2', 'BiasLearnRateFactor', 0)];

% set some options for the critic
criticOpts = rlRepresentationOptions('LearnRate',5e-3,'GradientThreshold',1);

% create the critic based on the network approximator
critic = rlValueRepresentation(criticNetwork,obsInfo,'Observation',{'state'},criticOpts);

% create a network to be used as underlying actor approximator
actorNetwork = [
    featureInputLayer(obsInfo.Dimension(1), 'Normalization', 'none', 'Name', 'state')
    fullyConnectedLayer(3,'Name','HL1')
    fullyConnectedLayer(2,'Name','HL2')
    fullyConnectedLayer(Num_of_actions, 'Name', 'action', 'BiasLearnRateFactor', 0)];

% set some options for the actor
actorOpts = rlRepresentationOptions('LearnRate',5e-3,'GradientThreshold',1);

% create the actor based on the network approximator
actor = rlStochasticActorRepresentation(actorNetwork,obsInfo,actInfo,...
    'Observation',{'state'},actorOpts);

agentOpts = rlPGAgentOptions();
agentOpts.UseBaseline = false;
agentOpts.DiscountFactor = 0.95;
agentOpts.SampleTime = Ts;
agentOpts.EntropyLossWeight = 0.03;

agent = rlPGAgent(actor,critic,agentOpts);