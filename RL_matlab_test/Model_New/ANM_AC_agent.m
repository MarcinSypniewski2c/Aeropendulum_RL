%% Agent
Ts=0.01;

% create the network to be used as approximator in the critic
% it must take the observation signal as input and produce a scalar value
criticNet = [
    imageInputLayer([obsInfo.Dimension 1],'Normalization','none','Name','state')
    fullyConnectedLayer(10,'Name', 'fc_in')
    reluLayer('Name', 'relu')
    fullyConnectedLayer(1,'Name','out')];

% set some training options for the critic
criticOpts = rlRepresentationOptions('LearnRate',8e-3,'GradientThreshold',1);

% create the critic representation from the network
critic = rlValueRepresentation(criticNet,obsInfo,'Observation',{'state'},criticOpts);

% input path layers (2 by 1 input and a 1 by 1 output)
inPath = [ 
    imageInputLayer([obsInfo.Dimension 1], 'Normalization','none','Name','state')
    fullyConnectedLayer(10,'Name', 'ip_fc')  % 10 by 1 output
    reluLayer('Name', 'ip_relu')             % nonlinearity
    fullyConnectedLayer(1,'Name','ip_out') ];% 1 by 1 output

% path layers for mean value (1 by 1 input and 1 by 1 output)
% use scalingLayer to scale the range
meanPath = [
    fullyConnectedLayer(15,'Name', 'mp_fc1') % 15 by 1 output
    reluLayer('Name', 'mp_relu')             % nonlinearity
    fullyConnectedLayer(1,'Name','mp_fc2');  % 1 by 1 output
    tanhLayer('Name','tanh');                % output range: (-1,1)
    scalingLayer('Name','mp_out','Scale',actInfo.UpperLimit) ]; % output range: (-2N,2N)

% path layers for standard deviation (1 by 1 input and output)
% use softplus layer to make output non negative
sdevPath = [
    fullyConnectedLayer(15,'Name', 'vp_fc1') % 15 by 1 output
    reluLayer('Name', 'vp_relu')             % nonlinearity
    fullyConnectedLayer(1,'Name','vp_fc2');  % 1 by 1 output
    softplusLayer('Name', 'vp_out') ];       % output range: (0,+Inf)

% concatenate two inputs (along dimension #3) to form a single (2 by 1) output layer
outLayer = concatenationLayer(3,2,'Name','mean&sdev');

% add layers to layerGraph network object
actorNet = layerGraph(inPath);
actorNet = addLayers(actorNet,meanPath);
actorNet = addLayers(actorNet,sdevPath);
actorNet = addLayers(actorNet,outLayer);

% connect layers: the mean value path output must be connected to the first input of the concatenation layer
actorNet = connectLayers(actorNet,'ip_out','mp_fc1/in');   % connect output of inPath to meanPath input
actorNet = connectLayers(actorNet,'ip_out','vp_fc1/in');   % connect output of inPath to sdevPath input
actorNet = connectLayers(actorNet,'mp_out','mean&sdev/in1');% connect output of meanPath to mean&sdev input #1
actorNet = connectLayers(actorNet,'vp_out','mean&sdev/in2');% connect output of sdevPath to mean&sdev input #2

% set some training options for the actor
actorOpts = rlRepresentationOptions('LearnRate',8e-3,'GradientThreshold',1);

% create the actor using the network
actor = rlStochasticActorRepresentation(actorNet,obsInfo,actInfo,...
    'Observation',{'state'},actorOpts);

%agnet
agentOpts = rlACAgentOptions('NumStepsToLookAhead',32,'DiscountFactor',0.99,'SampleTime',Ts);
agent = rlACAgent(actor,critic,agentOpts);

%Plotting
actorNet = getModel(getActor(agent));
criticNet = getModel(getCritic(agent));

%Plot critic and actor networks
%criticNet.Layers
%actorNet.Layers
%plot(layerGraph(criticNet))
%plot(layerGraph(actorNet))

