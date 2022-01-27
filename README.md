# Aeropendulum_RL
## MATLAB

### Symulacja
Aby symulacja zadziałała musimy uruchomić plik ***ANM_params.m*** aby wczytać parametry symulacji. Potem importujemy plik ***PG_Agent_good.mat*** i upewniamy się, że w bloku *RL_Agent* w modelu ***Aeropendulum_new_model_v2.slx*** w Simulinku wpisane jest *saved_agent*. Obserwujemy wtedy działanie najlepszego wytrenowanego agenta. Aby zmienić wartość zadaną musimy zmienić parametr *yref*. Wszystkie potrzebne pliki znajdują się w */RL_matlab_test/Model_New*.

### Uwagi
(26.11) Symulacja ma krok **Ts=0.01s** i problem pętli algebraicznej już nie występuje. Mamy w tej chwili 3 różne algorytmy, które testujemy, sprawdzając ich efektywność przy różnych wartościach ich parametrów. Algorytmy ***PPO*** oraz ***AC*** jeszcze z nieznanych przyczyn nie trzymają się ustalonych granic możliwych akcji agenta. Mimo to udało się pokazowy model agenta ***AC*** wytrenować.

(04.12) Obszar akcji został zmieniony na dyskretny co pozwili przyspieszyć symulacje. Dodaliśmy 4 algorytmy dla dyskretnego obszaru akcji. Aby poprawić proces nauczania dodaliśmy blok *rate limiter* aby skok był "schodkowy". Na ten moment nie ma żadnego wytrenowanego agenta dla dyskretnego obszaru akcji.

(13.12) Odchylenie dodane do obserwacji. Stworzony model ***Aeropendulum_new_model_v2***, który oczekuje na pozytywnie zapowiadające się testy.

(14.12) Zmiana parametru *Entropy Loss Weight* na mniejszy, odpowiadającego za stosunek exploration to exploitation, daje znaczą poprawę podczas nauki agentów.

(17.12) Zmiana zakresu akcji i sygnału referencyjnego aby objąć zakres kątów od -75 do 75 stopni.

## Komunikacja

### UDP 
(18.11) Przesłany sinus z Serwera do Klienta (RPi -> Windows) w Pythonie - przetestowane, klient odebrał każdy pakiet


(22.11) Matlab przyjmuje liczby od serwera. Uzywalem RAW_SOCKET więć nie mogłem nasłuchiwać -> serwer czekał na cokolwiek wyslane ze strony klienta i odpowiadał odesłaniem wartości. ~~Problemem ze strony Matlaba (przynajmniej u mnie) jest to, że udało mi się odbierać dane tylko za pomocą biblioteki udpport a wysylac przy dsp.UdpSender - biblioteki wzajemnie blokuja sobie porty dlatego odbieranie i wysylanie musi odbywać się na innych portach - narazie to zostawiam bo biorę się za implementacje serwera w C++~~ EDIT: działa z wykorzystaniem udpport i C++, z pythonem dalej nie.

(27.11) Z użyciem C++ działa poprawnie biblioteki matlaba się już nie gryzą i wszystko działa poprawnie na jednym porcie

(3.01) Rpi przesyła dane które matlab przetwarza i odsyła do rpi w zapętleniu (gotowy do uzycia modelu jako regulatora)

(4.01) Na podstawie bibliotek z pracy o Aeropendulum stworzone programy do odczytu kąta i zadawania prędkości w C++

(13.01) Pierwsza wersja działająca zmiana prędkości od kąta

### TCP
(22.01) Działa analogicznie do UDP

## Model RL Python

(9.01) Dodanie skryptu do RL w jezyku python bez pelnej implementacji modelu aeropendulum

(21.01) Poprawienie działania modelu pendulum. Porównanie odpowiedzi modelu matlab z modelem python. Model aeropendulum zaimplementowany dla pełnego zakresu sygnału (-180,180). 

(24.01) W pełni działający model pendulum 
