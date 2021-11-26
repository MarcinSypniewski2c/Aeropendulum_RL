# Old annotations
## MATLAB 
(11.11) Agent jest wytrenowany dość słabo ale na ten moment da się zauważyć, że podejmuje on próbę regulacji mimo iż końcowo uchyb zostaje całkiem duży. 
Póki co trenowany był tylko dla jedenj wartości referencyjnej *yref = 60*.

(13.11) Agent teraz może zadziałać na środowisko dowolną wartością z przedziału [-4, 4] jednak nadal regulacja jest mało dokładna. Agent nie rozróżnia czy aeropendulum jest np. o 10 stopni za wysoko czy o 10 za nisko. Nagroda jest zbyt prosta. Sesja ***Aero_session_v2.mat*** zawiera nową wersję agenta z algorytmem **DDPG**.

(15.11) Sprawdziliśmy działanie modelu z wykorzsytaniem algorytmu **PPO**. Końcowo uchyb jest mniejszy ale występują oscylacje w zakresie około +/- 10 stopni. Uprościliśmy obserwacje odrzucając dtheta. W przeciwieństwie do algorytmu **DDPG**, który skutkował zadaniem najwyższej możliwej wartości momentu na aeropendulum, agent stara się manipulować tym momentem ale nie daje rady go ustalić na jednej wartości.

(19.11) Modyfikacje nagrody: dodanie ujemnej nagrody od większego przyspieszenia i ujemnych nagród od uchybu od konkretnych jego wartości.
