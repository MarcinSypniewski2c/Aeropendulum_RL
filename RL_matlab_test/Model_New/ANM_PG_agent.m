%% Agent

% create a network to be used as underlying critic approximator
baselineNetwork = [
    featureInputLayer(4, 'Normalization', 'none', 'Name', 'state')
    fullyConnectedLayer(2, 'Name', 'BaselineFC')
    fullyConnectedLayer(1, 'Name', 'BaselineFC2', 'BiasLearnRateFactor', 0)];

% set some options for the critic
baselineOpts = rlRepresentationOptions('LearnRate',5e-3,'GradientThreshold',1);

% create the critic based on the network approximator
baseline = rlValueRepresentation(baselineNetwork,obsInfo,'Observation',{'state'},baselineOpts);

% create a network to be used as underlying actor approximator
actorNetwork = [
    featureInputLayer(4, 'Normalization', 'none', 'Name', 'state')
    fullyConnectedLayer(3,'Name','HL1')
    fullyConnectedLayer(2,'Name','HL2')
    fullyConnectedLayer(201, 'Name', 'action', 'BiasLearnRateFactor', 0)];

% set some options for the actor
actorOpts = rlRepresentationOptions('LearnRate',5e-3,'GradientThreshold',1);

% create the actor based on the network approximator
actor = rlStochasticActorRepresentation(actorNetwork,obsInfo,actInfo,...
    'Observation',{'state'},actorOpts);

agentOpts = rlPGAgentOptions();
agentOpts.UseBaseline = true;
agentOpts.DiscountFactor = 0.99;
agentOpts.SampleTime = Ts;
agentOpts.EntropyLossWeight = 0.3;

agent = rlPGAgent(actor,baseline,agentOpts);
