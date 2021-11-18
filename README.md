# Aeropendulum_RL
## MATLAB

### Symulacja
Aby symulacja zadziałała musimy uruchomić plik ***custom_env_test.m*** w którym są podane  parametry aeropendulum, symulacji oraz zdefiniowane środowisko.    
Następnie musimy otworzyć **Reinforcement Learning Designer** z zakładki **APPS**, otworzyć sesję ***Aero_session.mat*** i wyeksportować naszego
agenta ***aero_agent_v1_Trained*** do Workspace.

### Uwagi
(11.11) Agent jest wytrenowany dość słabo ale na ten moment da się zauważyć, że podejmuje on próbę regulacji mimo iż końcowo uchyb zostaje całkiem duży. 
Póki co trenowany był tylko dla jedenj wartości referencyjnej *yref = 60*.

(13.11) Agent teraz może zadziałać na środowisko dowolną wartością z przedziału [-4, 4] jednak nadal regulacja jest mało dokładna. Agent nie rozróżnia czy aeropendulum jest np. o 10 stopni za wysoko czy o 10 za nisko. Nagroda jest zbyt prosta. Sesja ***Aero_session_v2.mat*** zawiera nową wersję agenta z algorytmem **DDPG**.

(15.11) Sprawdziliśmy działanie modelu z wykorzsytaniem algorytmu **PPO**. Końcowo uchyb jest mniejszy ale występują oscylacje w zakresie około +/- 10 stopni. Uprościliśmy obserwacje odrzucając dtheta. W przeciwieństwie do algorytmu **DDPG**, który skutkował zadaniem najwyższej możliwej wartości momentu na aeropendulum, agent stara się manipulować tym momentem ale nie daje rady go ustalić na jednej wartości.

## Komunikacja

### UDP 
(18.11) Przesłany sinus z Serwera do Klienta (RPi -> Windows) w Pythonie - przetestowane, klient odebrał każdy pakiet
