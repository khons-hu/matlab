% funkcia performNewtonMethodAndSaveInformationToFile spraví newtonovú metódu s danou funkciou, s daným
% intervalom a s daným epsilónom a vráti nám informácie o výsledok bisekcie
% 
%
% vstup: f, intervals, epsilon, a, b, c, d - vstupná
% anonymná funkcia v matlabe, doľné ohraničenie pre bisekciu, horné
% ohraničenie, presnosť (epsilon), koeficienty polynómu a, b, c , d
%
% výstup: newtonOutputMatrix - matlabová matica
function [newtonOutputMatrix, timeOfNewtonMethod, errorEstimateMatrix, newtonRootsVector] = performNewtonMethodAndSaveInformationToFile(f, intervals, epsilon, a, b, c, d)
    % inicializácia matice, ktorú budeme vrátiť, bude to obsahovať
    % informácie o vykonanej newtonovej metody
    newtonOutputMatrix = [];

    % inicializacia 
    newtonRootsVector = [];

    % Otvoríme, prípadne vytvoríme súbor Rovnica.txt v adresári OutputFiles
    % (v režimu append, zaručuje aby sa to vytvorilo v prípade ak to neexistuje)
    EquationTxt = fopen('OutputFiles/Rovnica.txt', 'a');

    %errorEstimateMatrix kde uložíme odhady absolútnej chyby
    errorEstimateMatrix = [];

    % Zapíšeme informácií o Newtonovej metóde do súboru
    fprintf(EquationTxt, "\n\n");
    fprintf(EquationTxt, "----------------------------------------------------\n");
    fprintf(EquationTxt, "                Newtonova metóda                     \n");
    fprintf(EquationTxt, "----------------------------------------------------\n");
    fprintf(EquationTxt, "\n");
    % Zapíšeme našu rovnicu do súboru
    fprintf(EquationTxt, "Rovnica: %g * x^3 + %g * x^2 + %g * x + %g\n\n", a, b, c, d);

    % Symbolické výrazy pre derivácie
    syms ff(x)
    % symbolický výraz pre našu rovnicu
    ff(x) = a * x^3 + b * x^2 + c * x + d;
    % prvá derivácia našej symbolickej rovnice
    Dff1(x) = diff(ff(x));
    % druhá derivácia našej symbolickej rovnice
    Dff2(x) = diff(ff(x), 2);

    % Prevedenie symbolických výrazov na funkcie pre numerický výpočet

    % prevedieme prvú symbolickú deriváciu našej rovnice na matlabovú
    % numerickú funkciu pomocou funkcie formula a matlabFunction
    expresion1 = formula(Dff1);
    f1 = matlabFunction(expresion1);
    % prevedieme druhú symbolickú deriváciu našej rovnice na matlabovú
    % numerickú funkciu pomocou funkcie formula a matlabFunction
    expresion2 = formula(Dff2);
    f2 = matlabFunction(expresion2);

    % zaznamenáme čas pred výpočtom bisekcie
    timeOfNewtonMethod = 0;

    % Prechádzame všetkými intervalmi
    for i = 1 : size(intervals, 1)
        % doľné ohraničenie z našej matici intervals v danom riadku
        a_interval = intervals(i, 2);
        % horné ohraničenie z našej matici intervals v danom riadku
        b_interval = intervals(i, 3);

        % Fourierove podmienky

        % pomocné hodnoty pre druhu podmienku:
        % minimum druhej derivácie z nášho intervalu
        min_val = fminbnd(f2, a_interval, b_interval);
        % maximum druhej derivácie z nášho intervalu, keďže nemáme funkciu
        % fmaxbnd() v matlabe, musíme jej odovzdať našu funkciu v zápornej
        % podobe s parametrom a tak dostaneme maximum
        max_val = fminbnd(@(x) -f2(x), a_interval, b_interval);

        % pomocné hodnoty pre tretiu Furierovu podmienku

        % druhá derivácia doľného ohraničenia intervalu
        u1 = f2(a_interval);
        % druhá derivácia horného ohraničenia intervalu
        v1 = f2(b_interval);

        fprintf(EquationTxt, "\n%d. Interval: [%g, %g]\n", i, a_interval, b_interval);

        % Kontrola Fourierových podmienok (Ak sú splnené Furierove podmienky, vyberieme vhodné x0 na základe týchto podmienok)

        % V prípade ak prvá podmienka vráti záporné číslo, druhá podmienka
        % vráti väčšie číslo ako nula, a znamienko sa nezmenilo na
        % intervalu s druhou deriváciou (druhé derivácie s max a min majú rovnaké znamienko)
        if f(a_interval) * f(b_interval) < 0 && f(a_interval) * u1 > 0 && sign(f2(min_val)) == sign(f2(max_val))
            % tak naša x0 bude doľné ohraničenie
            x0 = a_interval;
        elseif f(a_interval) * f(b_interval) < 0 && f(b_interval) * v1 > 0 && sign(f2(min_val)) == sign(f2(max_val))
            % v prípade ak prvá podmienka vráti záporné číslo a tretia
            % kladné číslo, a takisto sa nezmenilo znamienko na intervale s
            % druhou deriváciou tak naša x0 buďe horné ohraničenie
            x0 = b_interval;
        else
            % v prípade, ak neplatí Furierova podmienka tak informujeme
            % používateľa o tom
            fprintf(EquationTxt, "\nInterval nesplňal Furierove podmienky, pokračoval som s ďalším koreňom, ak existovala \n");
            disp(['Interval <' num2str(a_interval) ', ' num2str(b_interval) '> nesplňal Furierove podmienky, pokračujem s ďalším koreňom, ak existuje']);
            errorEstimateMatrix = [errorEstimateMatrix, NaN];
            newtonRootsVector = [newtonRootsVector, NaN];
            % a pokračujeme s ďaľšími intervalmi
            continue;
        end

        fprintf(EquationTxt, "\n-------------------------------------\n");
        fprintf(EquationTxt, "Jednotlivé kroky Newtonovej metódy:\n");
        fprintf(EquationTxt, "-------------------------------------\n");

        % Newtonova metóda

        % Inicializácia počítadla iterácií
        k = 0;
        % Inicializácia podmienky zastavenia
        Stop = f(x0-epsilon)*f(x0+epsilon);
        % Spustenie Newtonovej metódy (beží to pokiaľ podmienka vráti väčšie číslo ako 0)

        % začiatok merania času
        tic;
        while (Stop > 0)
            % Aktuálna hodnota x
            xk = x0;

            % Nová hodnota x (xk+1)
            xkk = xk - f(xk)/f1(xk);

            % Aktualizácia podmienky zastavenia
            Stop = f(xkk-epsilon)*f(xkk+epsilon);

            % Aktualizujeme newtonOutputMatrix a zaznamenáme informácie o iterácii
            newtonOutputMatrix = [newtonOutputMatrix; i, k, xkk, f(xkk), f1(xkk), Stop];

            % Zvýšime počet iterácií a nastavíme nové x0
            k = k + 1;

            % Nastavenie nového x0
            x0 = xkk;

            fprintf(EquationTxt, "%d. krok\n", k);
            fprintf(EquationTxt, "x%d = %g\n", k, x0);
            fprintf(EquationTxt, "f(x%d) = %g\n", k, f(x0));
            fprintf(EquationTxt, "f'(x%d) = %g\n", k, f1(x0));
            fprintf(EquationTxt, "Stop = %g\n\n", Stop);
        end
        % koniec merania času
        endTime = toc;
        % zaznamenáme čas Newtonovej metódy
        timeOfNewtonMethod = timeOfNewtonMethod + endTime;

        % Informujeme používateľa o tom, že sme našli koreň
        disp([newline, 'Našiel som koreň Newtonovou metódou na ', num2str(k), '. iteráciu']);
        % Vypíšeme koreň používateľovi
        disp(['Nájdený koreň je: ', num2str(x0), newline]);

        newtonRootsVector = [newtonRootsVector, x0];

        % Odhad chyby Newtonovej metódy

        % pomocná premenná m na minimum absolutnej hodnoty prvej derivacie
        % funkcie na našom intervale
        m = 0; 
        % pomocná premenná M na minimum absolutnej hodnoty druhej derivacie
        % opačnej funkcie na našom intervale
        M = 0;

        % Dff1m je prvá derivácia opačnej funkcie
        Dff1m(x) = diff((-1) * ff(x));

        % Prevedieme Dff1m na funkciu vhodnú pre Matlab
        expresion = formula(Dff1m);
        f1m = matlabFunction(expresion);

        % Nájdeme minimum absolútnej hodnoty prvej derivácie funkcie na danom intervale
        m = fminbnd(f1, a_interval, b_interval);

        % Nájdeme minimum absolútnej hodnoty druhej derivácie opačnej funkcie na danom intervale
        M = fminbnd(f1m, a_interval, b_interval);

        % Nájdeme menšiu z hodnôt absolútnych hodnôt prvej derivácie funkcie a druhej derivácie opačnej funkcie
        m1 = min(abs(f1(m)), abs(f1(M)));

        % Vypočítame odhad absolútnej chyby pre Newtonovu metódu
        if m1 == 0 || isnan(m1) || isinf(m1) || isempty(newtonOutputMatrix) || isnan(newtonOutputMatrix(end, 4))
            errorEstimate = NaN;
        else
            errorEstimate = abs(newtonOutputMatrix(end, 4)) / m1;
        end

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
        stopStr = sprintf(['%.', num2str(decimals), 'f'], Stop);

        % Vypíšeme výsledok Newtonovej metódy používateľovi
        % vo forme riadkov počet krokov, doľná hranica, horná hranica, koreň,
        % hodnota zastavenia
        disp(['Výsledok Newtonovej metódy:', newline]);
        disp(['Koreň: ', num2str(x0)]);
        disp(['Funkčná hodnota pre koreň: ', num2str(f(x0))]);
        disp(['Počet krokov: ', num2str(k)]);
        disp(['Doľná hranica: ', num2str(a_interval)]);
        disp(['Horná hranica: ', num2str(b_interval)]);
        disp(['Hodnota zastavenia: ', stopStr, newline]);
        disp(['Odhad absolútnej chyby pre Newtonovu metódu je ER = ', errorEstimateStr, '.']);

        % Zapíšeme príslušné informácie o vykonanej Newtonovej metóde pre konkrétny

        fprintf(EquationTxt, '\n---------------------------\n');
        fprintf(EquationTxt, 'Výsledky Newtonovej metódy:\n');
        fprintf(EquationTxt, '---------------------------\n');

        % konkrétny koreň ktorý sme našli
        fprintf(EquationTxt, "\nKoreň: %.*g\n", decimals, x0);
        % funkčná hodnota pre koreň
        fprintf(EquationTxt, "Funkčná hodnota pre koreň: %.*g\n", decimals, f(x0));
        % epsilon
        fprintf(EquationTxt, "epsilon: %.*g\n", decimals, epsilon);
        % počet krokov
        fprintf(EquationTxt, 'Počet krokov: %d\n', k);
        % interval
        fprintf(EquationTxt, 'Interval, v ktorom bol nájdený koreň: [%.*g, %.*g]\n', decimals, a_interval, decimals, b_interval);
        % veľkosť intervalu
        fprintf(EquationTxt, "Velkosť intervalu: %.*g\n", decimals, abs(b_interval - a_interval));
        % hodnota zastavenia
        fprintf(EquationTxt, 'Hodnota zastavenia: %s\n', stopStr);
        % Zapíšeme odhad chyby Newtonovej metódy do súboru
        fprintf(EquationTxt, 'Odhad absolútnej chyby pre Newtonovu metódu je ER = %s.\n', errorEstimateStr);
    end

    % Vypíšeme čas newtonovej metódy používateľovi a zapíšeme to aj do súboru
    disp([newline, 'Čas newtonovej metódy: ', num2str(timeOfNewtonMethod), 'sekúnd.', newline]);
    fprintf(EquationTxt, '\nČas newtonovej metódy: %f sekúnd\n', timeOfNewtonMethod);

    fprintf(EquationTxt, "<------------------------------------------>\n\n");
    
    % Zavrieme súbor Rovnica.txt
    fclose(EquationTxt);
end
