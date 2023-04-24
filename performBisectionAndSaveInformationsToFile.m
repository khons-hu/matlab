% funkcia performBisectionAndSaveInformationsToFile spraví bisekciu s danou funkciou, s daným
% intervalom a s daným epsilónom a vráti nám informácie o výsledku bisekcie
% vo forme: krok, doľná hranica, horná hranica, stred, rozdiel medzi dolnou
% a hornou hranicou, funkčnú hodnotu stredy, takisto informácie zapíše aj
% do súboru
%
% vstup: f, intervals, epsilon, a, b, c, d - vstupná
% anonymná funkcia v matlabe, doľné ohraničenie pre bisekciu, horné
% ohraničenie, presnosť (epsilon), koeficienty polynómu a, b, c , d
%
% výstup: bisectionOutputMatrix - matlabová matica - krok, doľná hranica, horná hranica, stred, rozdiel medzi dolnou
% a hornou hranicou (velkosť intervalu)
function [bisectionOutputMatrix, timeOfBisection, errorEstimateMatrix, bisectionRootsVector] = performBisectionAndSaveInformationsToFile(f, intervals, epsilon, a, b, c, d)
    % inicializácia matice, ktorú budeme vrátiť, bude to obsahovať
    % informácie o vykonanej metódy bisekcií
    bisectionOutputMatrix = [];

    % Otvoríme, prípadne vytvoríme súbor Rovnica.txt v adresári OutputFiles
    % (v režimu append, zaručuje aby sa to vytvorilo v prípade ak to neexistuje)
    EquationTxt = fopen('OutputFiles/Rovnica.txt', 'a');

    %errorEstimateMatrix kde uložíme odhady absolútnej chyby
    errorEstimateMatrix = [];

    % premenná bisectionRootsVector, kde budeme ukladať nájdené korene
    bisectionRootsVector = [];

    % Zapíšeme informácií o bisekcii do súboru
    fprintf(EquationTxt, "\n\n");
    fprintf(EquationTxt, "----------------------------------------------------\n");
    fprintf(EquationTxt, "                  Metóda bisekcie                   \n");
    fprintf(EquationTxt, "----------------------------------------------------\n");
    fprintf(EquationTxt, "\n");
    % Zapíšeme našu rovnicu do súboru
    fprintf(EquationTxt, "Rovnica: %g * x^3 + %g * x^2 + %g * x + %g\n\n", a, b, c, d);

    % čas pred začiatkom bisekcie
    timeOfBisection = 0;

    % pre kazdy interval v matici intervals robime bisekciu
    for root = 1 : size(intervals, 1)
        % premenná iterator, slúži to ako krok, po vykonaní počet krokov
        iterator = 0;

        % premenná middle, kďe budeme ukladať stred a po vykonaní bisekcie to
        % bude náš nájdený koreň funkcie pomocou bisekcie
        middle = 0;

        % dolná hranica bude z daného riadku kde sa nachádzame druhý stlpec
        lowerBisectionBound = intervals(root, 2);
        % horná hranica bude z daného riadku kde sa nachádzame tretí stlpec
        upperBisectionBound = intervals(root, 3);

        % Zapíšeme interval, ktorý bol použitý v bisekcii
        fprintf(EquationTxt, "\n%d. Interval: [%g, %g]\n\n", root, lowerBisectionBound, upperBisectionBound);

        fprintf(EquationTxt, "\n--------------------------\n");
        fprintf(EquationTxt, "Jednotlivé kroky bisekcie:\n");
        fprintf(EquationTxt, "--------------------------");

        % zaznamenáme čas pred výpočtom bisekcie pre daný interval
        tic;
        % Vykonáme bisekciu, kým sa nedosiahne naša presnosť * 2
        % teda zastavovacia podmienka je: abs(upperBisectionBound - lowerBisectionBound) >= (2 * epsilon)
        while (abs(upperBisectionBound - lowerBisectionBound) >= (2 * epsilon))

            % Ak sme prekročili počet krokov 1000, tak vypíšeme chybové
            % hlásenie a ukončíme súčasnú bisekciu
            if iterator >= 1000
                fprintf(EquationTxt, "     Bisekcia prekročila 1000 krokov, preto som pokračoval s ďalším intervalom\n");
                disp("Bisekcia prekročila 1000 krokov, preto pokračujem s ďalším intervalom");
                bisectionRootsVector = [bisectionRootsVector; NaN];
                errorEstimateMatrix = [errorEstimateMatrix; NaN];
                break;
            end

            % vypočítame stred so spočítaním doľnej a hornej hranici a videlíme
            % to s 2 a uložíme to do premennej middle
            middle = (lowerBisectionBound + upperBisectionBound) / 2;

            % zvýšime počet krokov o 1 (jeden)
            iterator = iterator + 1;
    
            % Pridáme výsledky do riadku matice
            % Riadok v matici reprezentuje: krok, doľná hranica, horná hranica,
            % stred, veľkosť intervalu
            bisectionOutputMatrix = [bisectionOutputMatrix; iterator, lowerBisectionBound, upperBisectionBound, middle, abs(upperBisectionBound - lowerBisectionBound), f(middle)];
    
            % Vypíšeme informácie bisekcií v danej iterácii používaťeľovi
            disp([num2str(iterator), '. iterácia: ', newline, 'Interval: [', num2str(lowerBisectionBound), ', ', num2str(upperBisectionBound), '] ,' , newline, 'stred: ', num2str(middle), newline, 'rozdieľ medzi hranicami (veľkosť intervalu): ', num2str(abs(upperBisectionBound - lowerBisectionBound)), newline]);
    
            % Informujeme používateľa o tom, že aký stred sme dostali
            disp(['Vypočítal som stred pre ', num2str(iterator), '. iteráciu, (horná hranica - doľná hranica) / 2 = ', num2str(middle) , newline]);

            % Aktualizujeme intervaly podľa znamienka funkcie v stredovom bode
             
            %V prípade, ak funkčná hodnota stredu vráti nulu, našli sme koreň, nemusíme
            % pokračovať s bisekciou
            if (f(middle) == 0)
                % kedže nemusíme pokračovať s bisekciou, použijeme príkaz
                % break, čo nám pozastaví celú iteráciu a vystúpi z nej

                % Ak sme našli koreň na prvý krok tak uložíme informácie
                % do súboru
                if (iterator == 1)
                    fprintf(EquationTxt, "\n%d. krok\n", iterator);
                    fprintf(EquationTxt, "     Interval: [%g, %g]\n", lowerBisectionBound, upperBisectionBound);
                    fprintf(EquationTxt, "     Stred: %g\n", middle);
                    fprintf(EquationTxt, "     f(stred): %g\n", f(middle));
                end

                break;
            elseif (f(middle) * f(lowerBisectionBound) < 0)
                % V prípade, ak funkčná hodnota stredu vynásobená s funkčnou
            %hodnotou doľného ohraničenia vráti záporné číslo, nastavíme horné
            %ohraničenie na stred, teda posunieme interval
                disp('Nastavujem horné ohraničenie na stred, lebo f(stred) * f(doľná hranica) < 0...');
                upperBisectionBound = middle;
            else
                % V prípade, ak funkčná hodnota stredu vynásobená s funkčnou
            %hodnotou doľného ohraničenia vráti kladné číslo, nastavíme horné
            %ohraničenie na stred, teda posunieme interval
                disp('Nastavujem doľné ohraničenie na stred, lebo f(stred) * f(doľná hranica) > 0...');
                lowerBisectionBound = middle;
            end

            fprintf(EquationTxt, "\n%d. krok\n", iterator);
            fprintf(EquationTxt, "     Interval: [%g, %g]\n", lowerBisectionBound, upperBisectionBound);
            fprintf(EquationTxt, "     Stred: %g\n", middle);
            fprintf(EquationTxt, "     f(stred): %g\n", f(middle));
        end
        % zaznamenáme čas po výpočte bisekcie pre daný interval
        endTime = toc;
        % pridáme čas do celkového času bisekcie
        timeOfBisection = timeOfBisection + endTime;
    
        % Informujeme používateľa o tom, že sme našli koreň
        disp([newline, 'Našiel som koreň, f(stred) = 0, ', 'na ', num2str(iterator), '. iteráciu']);
        % Vypíšeme koreň používateľovi
        disp(['Nájdený koreň je: ', num2str(middle), newline]);

        % Pridáme koreň do vektoru koreňov
        bisectionRootsVector = [bisectionRootsVector, middle];
    
        % Vypíšeme výsledok bisekcie používateľovi
        % vo forme riadkov počet krokov, doľná hranica, horná hranica, koreň,
        % veľkosť intervalu
        disp(['Výsledok bisekcie:', newline]);
        disp(['     Koreň: ', num2str(middle)]);
        disp(['     Funkčná hodnota pre koreň: ', num2str(f(middle))]);
        disp(['     Počet krokov: ', num2str(iterator)]);
        disp(['     Doľná hranica: ', num2str(lowerBisectionBound)]);
        disp(['     Horná hranica: ', num2str(upperBisectionBound)]);
        disp(['     Veľkosť intervalu: ', num2str(abs(upperBisectionBound - lowerBisectionBound)), newline]);

        % odhad chyby (|b - a| / 2^(k + 1))
        % intervals(root, 3) je horné ohraničenie v matici intervals daného
        % intervalu, intervals(root, 2) je dolné ohraničenie v matici intervals daného
        % intervalu
        errorEstimate = abs(intervals(root, 3) - intervals(root, 2)) / (2.^(iterator + 1));

        errorEstimateMatrix = [errorEstimateMatrix, errorEstimate];

        % Vypočítame počet desatinných miest pre epsilon a pridáme 10
        % abs je funkcia v matlabe ktorá vypočíta absolutnú hodnotu
        % log10 je funkcia v matlabe ktorá vypočíta desatinný logaritmus
        % ceil je funkcia v matlabe ktorá zaokrúhľuje číslo nahor
        % + 10 je preto, aby sme mali aspoň 10 desatinných miest
        decimals = ceil(abs(log10(epsilon))) + 10;

        % reťazec na reprezetnáciu odhadnutej chyby s nastavením
        % desatinných miest
        errorEstimateStr = sprintf(['%.', num2str(decimals), 'f'], errorEstimate);

        % vypíšeme odhadnutú chybu
        disp(['     Odhadnutá chyba použitím vzorca: |b - a| / 2^(k + 1) = ', errorEstimateStr, newline]);

        % Zapíšeme príslušné informácie o vykonanej bisekcií pre konkrétny
        % koreň

        fprintf(EquationTxt, "\n--------------------");
        fprintf(EquationTxt, "\nVýsledky bisekcie: \n");
        fprintf(EquationTxt, "--------------------");

        % konkrétny koreň ktorú sme našli
        fprintf(EquationTxt, "\n   Koreň: %.*g\n", decimals, middle);
        % funkčná hodnota pre koreň
        fprintf(EquationTxt, "     Funkčná hodnota pre koreň: %.*g\n", decimals, f(middle));
        % presnosť
        fprintf(EquationTxt, "     Epsilon (presnosť): %.*g\n", decimals, epsilon);
        % počet krokov bisekcii
        fprintf(EquationTxt, "     Počet krokov: %d\n", iterator);
        % Interval, v ktorom bol nájdený koreň
        fprintf(EquationTxt, "     Interval, v ktorom bol najdený koreň: [%.*g, %.*g]\n", decimals, lowerBisectionBound, decimals, upperBisectionBound);
        % Velkosť intervalu
        fprintf(EquationTxt, "     Velkosť intervalu: %.*g\n", decimals, abs(upperBisectionBound - lowerBisectionBound));
        % Odhad chyby
        fprintf(EquationTxt, "     Odhadnutá chyba použitím vzorca: |b - a| / 2^(k + 1) = %s\n", errorEstimateStr);
        fprintf(EquationTxt, "------------------------------------------------------------\n\n");
    end

    % zaznamenáme čas po výpočte bisekcie, uložíme ho to premennej
    % timeOfBisection
    timeOfBisection = toc;

    % Vypíšeme čas bisekcie používateľovi a zapíšeme to aj do súboru
    disp([newline, 'Čas bisekcie: ', num2str(timeOfBisection), 'sekúnd.', newline]);
    fprintf(EquationTxt, '\nČas bisekcie: %f sekúnd\n\n', timeOfBisection);
    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
    pause(1);

    % Zatvoríme súbor Rovnica.txt
    fclose(EquationTxt);
end