%% Parametry modelu symulacyjnego aeropendulum
%kwantyzacja 4095
m = 0.120;   % masa wahadla [kg]

g = 9.81;    % przyspieszenie grawitacyjne [m/s^2]

c = 0.007;   % tarcie wiskotyczne [Nms/rad]
             % https://koyo.jtekt.co.jp/en/support/bearing-knowledge/8-4000.html
             
l = 0.25;    % dlugosc wahadla [m]

J = m*l*l;   % moment bezwladnosci [kgm^2] 
             % https://www.youtube.com/watch?v=scIVIhChL1I
             
d = 0.25;    % odleglosc osi od srodka masy 
             % https://youtu.be/2KCuR6kIrfI?t=294
             
%alfa=0.014;    % wspolczynnik dla smigla w "nieprawidlowa" strone 

%alfa_rev=0.019; % wspolczynnik dla smigla w "prawidlowa" strone

Ts=0.1;

%% Parametry symulacji
mdl = 'Aeropendulum_new_model';
%open_system(mdl)

obsInfo = rlNumericSpec([4 1]); % vector of 4 observations: sin(theta), cos(theta), thetaD, thetaDD
% Continuous ActInfo
%actInfo = rlNumericSpec([1 1],'LowerLimit',0,'UpperLimit',4600); %single value RPMs
% Disc ActInfo
%Min
actMin = -3000;
%Max
actMax = 3000;
%Step
actStep = 30;
actInfo = rlFiniteSetSpec([actMin:actStep:actMax]);

Num_of_actions = actMax/actStep + abs(actMin)/actStep + 1;

obsInfo.Name = 'observations';
actInfo.Name = 'RPMs';

agentBlk = [mdl '/RL Agent'];
env = rlSimulinkEnv(mdl,agentBlk,obsInfo,actInfo);

env.ResetFcn = @(in) setVariable(in,'theta',0);

%wartosc referencyjna
yref=35;

rate_max = yref/10;
rate_min = -yref/10;

input_yref_vector = [10*ones(100,1); 15*ones(100,1); 20*ones(100,1); 25*ones(100,1); 30*ones(100,1);].';
%input_yref_vector = [10*ones(100,1); 20*ones(100,1); 30*ones(100,1); 40*ones(100,1); 50*ones(100,1); 60*ones(100,1); 70*ones(100,1); 80*ones(100,1)].';