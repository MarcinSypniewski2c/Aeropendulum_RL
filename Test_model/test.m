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

mdl = 'Aeropendulum_test_simple';
open_system(mdl)

% Now make one cycle with amplitude 1000 and 200 elements.
a = ones(1, 200)
b = a.*-1
onePeriod = 2 * [ones(1, 200), b];
% 200 elements is supposed to be 0.1 seconds so find out delta t.
dt = 4 / numel(onePeriod);
% Define number of cycles.
numCycles = 5;
% Copy this period that many times.
input = repmat(onePeriod, [1, numCycles]);





t = 0:0.01:20-0.01
t2 = 0:0.01:20
Rs = 5;

writematrix(input,"square_signal.csv")

python_output = readmatrix('C:\Users\Lenovo\PycharmProjects\pythonProject\python_output.csv');

plot(t,input, 'g')
hold on;
plot(t,python_output, 'r-')
hold on;

plot(t2,out.theta, 'b')

