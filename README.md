# Aeropendulum_RL
## MATLAB

### Symulacja
Aby symulacja zadziałała musimy uruchomić plik ***custom_env_test.m*** w którym są podane  parametry aeropendulum, symulacji oraz zdefiniowane środowisko.    
Następnie musimy otworzyć **Reinforcement Learning Designer** z zakładki **APPS**, otworzyć sesję ***Aero_session.mat*** i wyeksportować naszego
agenta ***aero_agent_v1_Trained*** do Workspace.

### Uwagi
Agent jest wytrenowany dość słabo ale na ten moment da się zauważyć, że podejmuje on próbę regulacji mimo iż końcowo uchyb zostaje całkiem duży. 
Póki co trenowany był tylko dla jedenj wartości referencyjnej *yref = 60*.
