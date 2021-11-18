%% Parametry modelu symulacyjnego aeropendulum
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

%alfa_rev=0.019 % wspolczynnik dla smigla w "prawidlowa" strone

%% Parametry symulacji
mdl = 'Aeropendulum_new_model';
open_system(mdl)

obsInfo = rlNumericSpec([3 1]); % vector of 2 observations: sin(theta), cos(theta) thetaD

actInfo = rlNumericSpec(1); % single value [RPM]

actInfo.LowerLimit = 3000;
actInfo.UpperLimit = 4600;

obsInfo.Name = 'observations';
actInfo.Name = 'RPMs';

agentBlk = [mdl '/RL Agent'];
env = rlSimulinkEnv(mdl,agentBlk,obsInfo,actInfo);

%wartosc referencyjna
yref=30;