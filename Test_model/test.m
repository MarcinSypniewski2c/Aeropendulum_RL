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
%open_system(mdl)

t1=0:0.01:20
input_yref_vector = square(t1, 50);
Rs = 5;

python_output = readmatrix('C:\Users\Lenovo\PycharmProjects\pythonProject\python_output.csv');
B = python_output.'

plot(t1,input_yref_vector, 'g')
hold on;
plot(t1,out.theta, 'b')
hold on;
plot(t1,B, 'r-')
csvwrite("square_signal",input_yref_vector)