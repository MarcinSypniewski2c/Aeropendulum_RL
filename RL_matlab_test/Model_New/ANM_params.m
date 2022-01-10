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
mdl = 'Aeropendulum_new_model_v2';
%open_system(mdl)

%Observations
obsInfo = rlNumericSpec([5 1]); % vector of 5 observations: sin(theta), cos(theta), thetaD, thetaDD, err_theta

% Disc ActInfo
%Min
actMin = -4000;
%Max
actMax = 4900;
%Step
actStep = 50;
actInfo = rlFiniteSetSpec([actMin:actStep:actMax]);

Num_of_actions = actMax/actStep + abs(actMin)/actStep + 1;

obsInfo.Name = 'observations';
actInfo.Name = 'RPMs';

agentBlk = [mdl '/RL Agent'];
env = rlSimulinkEnv(mdl,agentBlk,obsInfo,actInfo);

env.ResetFcn = @(in) setVariable(in,'theta',0);

%wartosc referencyjna
yref=35;
%Rising slew rate
Rs = 5;

%Vector of ones
single_theta_time = 10; %s
Num_ones = (single_theta_time/Ts);
Ov = ones(Num_ones,1);

%input_yref_vector = [5*Ov; 10*Ov; 15*Ov; 20*Ov; 25*Ov; 30*Ov; 35*Ov; 40*Ov; 45*Ov; 50*Ov; 45*Ov; 40*Ov; 35*Ov; 30*Ov; 25*Ov; 20*Ov; 15*Ov; 10*Ov; 5*Ov; -5*Ov; -10*Ov; -15*Ov; -20*Ov; -25*Ov; -30*Ov; -35*Ov; -40*Ov; -45*Ov; -50*Ov; -45*Ov; -40*Ov; -35*Ov; -30*Ov; -25*Ov; -20*Ov; -15*Ov; -10*Ov; -5*Ov].';
input_yref_vector = [5*Ov; 10*Ov; 15*Ov; 20*Ov; 25*Ov; 30*Ov; 35*Ov; 40*Ov; 45*Ov; 50*Ov].';