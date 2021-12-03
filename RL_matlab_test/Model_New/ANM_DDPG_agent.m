%% Agent
Ts=0.01;

%number of hidden units in each fully conected layer
initOpts = rlAgentInitializationOptions('NumHiddenUnit',24);

%Critic Net
statePath = imageInputLayer([obsInfo.Dimension(1) 1 1],'Normalization','none','Name','state');
actionPath = imageInputLayer([numel(actInfo) 1 1],'Normalization','none','Name','action');
commonPath = [concatenationLayer(1,2,'Name','concat')
             quadraticLayer('Name','quadratic')
             fullyConnectedLayer(1,'Name','StateValue','BiasLearnRateFactor', 0, 'Bias', 0)];
criticNetwork = layerGraph(statePath);
criticNetwork = addLayers(criticNetwork, actionPath);
criticNetwork = addLayers(criticNetwork, commonPath);
criticNetwork = connectLayers(criticNetwork,'state','concat/in1');
criticNetwork = connectLayers(criticNetwork,'action','concat/in2');

% set some options for the critic
criticOpts = rlRepresentationOptions('LearnRate',5e-3,'GradientThreshold',1);

% create the critic based on the network approximator
critic = rlQValueRepresentation(criticNetwork,obsInfo,actInfo,...
    'Observation',{'state'},'Action',{'action'},criticOpts);

%Actor Net
actorNetwork = [
    imageInputLayer([obsInfo.Dimension(1) 1 1],'Normalization','none','Name','state')
    fullyConnectedLayer(numel(actInfo),'Name','action','BiasLearnRateFactor',0,'Bias',0)];

% set some options for the actor
actorOpts = rlRepresentationOptions('LearnRate',1e-04,'GradientThreshold',1);

% create the actor based on the network approximator
actor = rlDeterministicActorRepresentation(actorNetwork,obsInfo,actInfo,'Observation',{'state'},'Action',{'action'},actorOpts);

%agent Options
agentOpts = rlDDPGAgentOptions("SampleTime", Ts);
agentOpts.TargetSmoothFactor = 1e-1;
agentOpts.ExperienceBufferLength = 1e6;
agentOpts.DiscountFactor = 0.99;
agentOpts.MiniBatchSize = 16;
agentOpts.NoiseOptions.Variance = 20e4;
agentOpts.NoiseOptions.VarianceDecayRate = 1e-3;

%agent
agent = rlDDPGAgent(actor, critic, agentOpts);

%Set critic learn rate, Get critic and actor networks
%critic = getCritic(agent);
%critic.Options.LearnRate = 1e-3;
%agent  = setCritic(agent,critic);

actorNet = getModel(getActor(agent));
criticNet = getModel(getCritic(agent));

%Plot critic and actor networks
%criticNet.Layers
%actorNet.Layers
%plot(layerGraph(criticNet))
%plot(layerGraph(actorNet))

