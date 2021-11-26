# Aeropendulum_RL
## MATLAB

### Symulacja
Aby symulacja zadziałała musimy uruchomić plik ***ANM_params.m*** aby wczytać parametry symulacji. Potem wybieramy plik ***ANM_..._agent.m*** dla wybranego przez nas algorytmu aby stworzyć agenta i potrzebne do jego działania elementy. Następnie uruchamiamy plik ***ANM_train.m*** aby rozpocząć trenowanie. Z folderu **savedAgents** importujemy klikając na wybrany przez nas plik z agentem i upewniamy się, że w bloku *RL_Agent* w modelu symulacyjnym jest wpisana jego nazwa czyli *saved_Agent*.

### Uwagi
(26.11) Symulacja ma krok **Ts=0.01s** i problem pętli algebraicznej już nie występuje. Mamy w tej chwili 3 różne algorytmy, które testujemy, sprawdzając ich efektywność przy różnych wartościach ich parametrów. Algorytmy ***PPO*** oraz ***AC*** jeszcze z nieznanych przyczyn nie trzymają się ustalonych granic możliwych akcji agenta. Mimo to udało się pokazowy model agenta ***AC*** wytrenować.

## Komunikacja

### UDP 
(18.11) Przesłany sinus z Serwera do Klienta (RPi -> Windows) w Pythonie - przetestowane, klient odebrał każdy pakiet


(22.11) Matlab przyjmuje liczby od serwera. Uzywalem RAW_SOCKET więć nie mogłem nasłuchiwać -> serwer czekał na cokolwiek wyslane ze strony klienta i odpowiadał odesłaniem wartości. Problemem ze strony Matlaba (przynajmniej u mnie) jest to, że udało mi się odbierać dane tylko za pomocą biblioteki udpport a wysylac przy dsp.UdpSender - biblioteki wzajemnie blokuja sobie porty dlatego odbieranie i wysylanie musi odbywać się na innych portach - narazie to zostawiam bo biorę się za implementacje serwera w C++
