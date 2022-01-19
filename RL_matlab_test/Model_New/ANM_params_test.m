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

%Sample Time
Ts=0.01;

%% Parametry symulacji
mdl = 'test_aero_v2';
load_system(mdl)
%open_system(mdl)

%Observations
obsInfo = rlNumericSpec([4 1]); % theta, thetaD, thetaDD, err_theta

% Disc ActInfo
%Min
actMin = -4000;
%Max
actMax = 4000;
%Step
actStep = 500;
actInfo = rlFiniteSetSpec([-4000, -1000, 0, 1000, 4000]);

actions = size(actInfo.Elements());

Num_of_actions = actions(1);

obsInfo.Name = 'observations';
actInfo.Name = 'actions';

agentBlk = [mdl '/RL Agent'];

env = rlSimulinkEnv(mdl,agentBlk,obsInfo,actInfo);

env.ResetFcn = @(in) setVariable(in,'theta',0);

%wartosc referencyjna
yref=25;
