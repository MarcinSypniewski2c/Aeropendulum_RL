mdl = 'test_aero_model';
open_system(mdl)

obsInfo = rlNumericSpec([2 1]); % vector of 3 observations: sin(theta), cos(theta) dtheta

actInfo = rlNumericSpec(1); % single value

actInfo.LowerLimit = -4;
actInfo.UpperLimit = 4;

obsInfo.Name = 'observations';
actInfo.Name = 'torque';

agentBlk = [mdl '/RL Agent'];
env = rlSimulinkEnv(mdl,agentBlk,obsInfo,actInfo);

%wartosc referencyjna
yref=60;

%Dane do wahadla
Tsym=30;
Ts=0.1;
N=Tsym/Ts;  % Maximum number of time steps
m=0.36; %masa wahadla
l=0.06; %dlugosc wahadla
d=0.03; %odleglosc osi od srodka
c=0.0076; %tarcie wiskotyczne 
J=0.0106; %moment bezwladnosci
g=9.81; %przyspieszenie grawitacyjne

%%
%uklad napedowy
%%rownanie opisujace napiecie do moementu
%%T(s)=Km*V(s)
%Dane ukladu napedowego
U=24; %napiecie wej silnika
P=30; %moc silnika
dp=0.15; %długosc smigla
ne=0.9; %sprawnosc silnika
np=0.85; %sprawnosc smigla
p=1.225; %gestosc powietrza
T=((P^2)*(np^2)*(ne^2)*pi*(dp^2)/2*p)^(1/3);
Km=T/U;

%macierze stanu
A=[0 1; -m*l*g*d/J -c/J];
B=[0; Km/J];
C=[1 0];

teta=10;