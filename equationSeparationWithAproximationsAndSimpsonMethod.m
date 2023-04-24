% Hlavná funkcia programu
% ktorá spustí úlohu 1
% teda separáciu rovnice, aproximaciu koreňov a výpočet určitého integrálu
function equationSeparationWithAproximationsAndSimpsonMethod()
    % ----------------------------------------------------------------------------------------------------------------------------
    % Načítavanie DataParametre.txt do matice
    DataParametersInputFile = 'InputFiles/DataParametre.txt';

    if isfile(DataParametersInputFile)
        % Použitím funkcie readmatrix()
        DataParametersInputMatrix = readmatrix(DataParametersInputFile);

        % Výpis o vstupu
        disp('Váš vstupný súbor so vstupnými parametrami pre vašu rovnicu a pre určitý integrál vyzerá nasledovne: ');
        disp(DataParametersInputMatrix);

        disp('Kde štruktúra jeho riadkov je: info, a, b, c, d, k, p, q, r, s, LB, UB, ε (teda má 13 stĺpcov).');
        disp('Pre úlohy s rovnicou a s aproximáciami budú používané riadky, prektoré je hodnota info rovná 1,' );
        disp(['pre úlohu na výpočet určitého integrálu budú používané, pre ktoré je hodnota info rovná 2', newline]);
    else
        disp('Váš vstupný súbor so vstupnými parametrami pre vašu rovnicu a pre určitý integrál neexistuje.');
        disp('Vytvorte si súbor DataParametre.txt v priečinku InputFiles a spustite program znovu.');
        return;
    end
    % ----------------------------------------------------------------------------------------------------------------------------

    % ----------------------------------------------------------------------------------------------------------------------------

    % Vypíšeme informácie o danej rovnice
    disp(['######################################################################################', newline]);
    disp('Daná rovnica vyzerá nasledovne:');
    disp(['a * x^3 + b * x^2 + c * x + d = 0', newline]);
    disp('Kde "x" je neznáma premenná a "a", "b", "c", "d" sú reálne parametre.');
    disp(['Aspoň dva (2) z parametrov b, c, d sú nenulové a parameter a je vždy nenulový.', newline]);
    disp(['######################################################################################', newline]);

    % ----------------------------------------------------------------------------------------------------------------------------

    % Prechádzame cez všetky riadky vstupnej matice, ak náš súbor bol validný
    if (checkValidityOfInputMatrix(DataParametersInputMatrix))   
        for iterator = 1 : size(DataParametersInputMatrix, 1)
            % Načítame i-ty riadok
            row = DataParametersInputMatrix(iterator, :);
        
            % Určíme prvý prvok v riadku (teda 1. stlpec), ktorý reprezentuje info
            % o tom, že či to je na úlohu (a) alebo na úlohu (b)
            info = row(1);
            
            % V prípade, že info nie je ani 1 ani 2, tak vypíšeme chybovú hlášku a preskočíme tento riadok
            if (info ~= 1 && info ~= 2)
                % Používateľ si môže zvoliť, či chce pokračovať s ďalším riadkom alebo nie
                userChoiceOutput = userChoiceOnInvalidInfo(iterator);

                % ak chce zvoliť medzi rovnicou alebo integrálom
                if userChoiceOutput == true 
                    EquationOrIntegral = userChoiceOnEquationOrIntegral();

                    % ak chce rovnicu
                    if EquationOrIntegral == true
                        % nastavíme info na 1
                        info = 1;
                    % inak integrál
                    else
                        % nastavíme info na 2
                        info = 2;
                    end
                else
                    % v inom prípade pokračujeme s ďalším riadkom, ak existuje
                    disp(['Pokračujem s ďalším riadkom.', newline']);
                    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                    pause(1);
                    continue;
                end
            end

            % switch aby na rozhodnutie či máme info 1 alebo 2 v danom riadku
            switch info
                % V prípade ak info je 1, praćujeme s našou rovnicou
                case 1
                    disp(['-------------------------------------------', newline]);
                    disp(['Vstupný súbor DataParametre.txt ', num2str(iterator), '. riadok: ', newline]);
                    disp(['-------------------------------------------', newline]);

                    disp(['Keďže hodnota info je rovná 1, tak budeme pracovať s rovnicou.', newline]);

                    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                    pause(1);

                    % ----------------------------------------------------------------------------------------------------------------------------
                    % úloha (a):
                    % Je daná rovnica v tvare a · x^3 + b · x^2 + c · x + d = 0, kde x je neznáma premenná a a, b, c, d sú reálne
                    % parametre, kde aspoň dva z parametrov b, c, d sú nenulové a parameter a je vždy nenulový.
                    % Na tú úlohu budeme používať DataParametre.txt ako vstupný súbor, ale dáme
                    % možnosť aj používateľovi zadať vstupy na jednotlivé parametre
                    disp(['úloha (a):', newline]);
                    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                    pause(1);

                    % Získame parametre a, b, c, d s našimi pomocnými funkciami
                    disp(['Vstupná matica - ', num2str(iterator), '. riadok: ']);
                    
                    if ~isnan(DataParametersInputMatrix(iterator, 2)) && (DataParametersInputMatrix(iterator, 2)) ~= 0 && isreal((DataParametersInputMatrix(iterator, 2)))
                        parameterA = getParameterA(iterator, DataParametersInputMatrix);
                    else
                        disp(['V stlpci ', num2str(iterator), ' sa nachádza neplatný vstup pre parameter a, pretože je nulový alebo neplatný.']);
                        userChoice = input('v prípade, že chcete zadať vstup pre parameter a, zadajte y, ak pokračovať, zadajte n: ', 's');

                        if strcmpi(userChoice, 'y')
                            parameterA = getParameterAFromUser();
                        else
                            disp(['Pokračujem s ďalším riadkom.', newline]);
                            % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                            pause(1);
                            continue;
                        end
                    end

                    % V prípade, že parametre b, c, d nie sú platné
                    if (((DataParametersInputMatrix(iterator, 3)) ~= 0 && (DataParametersInputMatrix(iterator, 4)) ~= 0) || ((DataParametersInputMatrix(iterator, 3)) ~= 0 && (DataParametersInputMatrix(iterator, 5)) ~= 0) || ((DataParametersInputMatrix(iterator, 4)) ~= 0 && (DataParametersInputMatrix(iterator, 5)) ~= 0)) && ~isnan(DataParametersInputMatrix(iterator, 3)) && ~isnan(DataParametersInputMatrix(iterator, 4))  && ~isnan(DataParametersInputMatrix(iterator, 5)) && isreal((DataParametersInputMatrix(iterator, 3))) && isreal((DataParametersInputMatrix(iterator, 4))) && isreal((DataParametersInputMatrix(iterator, 5)))
                        [parameterB, parameterC, parameterD] = getParametersBCD(iterator, DataParametersInputMatrix);
                    else
                        disp(['V stĺpcoch ', num2str(iterator), ' sa nachádzajú neplatné vstupy pre parametre b, c, d, pretože aspoň dva z nich sú nulové alebo neplatné.']);
                        disp(['V prípade, že chcete zadať vstupy pre parametre b, c, d, zadajte y, ak chcete pokračovať s ďalším riadkom, zadajte hocičo iné.']);
                        userChoice = input('zadajte y ak zadať, zadajte hocičo iné, ak pokračovať: ', 's');

                        if strcmpi(userChoice, 'y')
                            [parameterB, parameterC, parameterD] = getParametersBCDFromUser();
                        else
                            disp(['Pokračujem s ďalším riadkom.', newline]);
                            % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                            pause(1);
                            continue;
                        end
                    end

                    % Zadefinujeme našu rovnicu a * x^3 + b * x^2 + c * x + d = 0 vo forme
                    % anonymnej funkcie s jedným parametrom x a s našimi zadanými reálnymi parametrami
                    f = @(x) (parameterA * x.^3 + parameterB * x.^2 + parameterC * x + parameterD);
                    % výpisom zobrazíme zápis rovnice používateľovi s hláškou
                    % že funkcia bola zadefinovaná ako anonynmná funkcia v
                    % matlabe
                    displayEquation(parameterA, parameterB, parameterC, parameterD, f);
                    % ----------------------------------------------------------------------------------------------------------------------------

                    % ----------------------------------------------------------------------------------------------------------------------------
                    % úloha (b):
                    % Separujte všetky korene vyššie uvedenej rovnice. Určte, koľko rôznych reálnych koreňov táto rovnica má
                    % a pre každý z nich určte interval separácie, t. j. interval separácie obsahuje práve jeden reálny koreň. (Pri
                    % separácii koreňov môžete používať analytické nástroje, grafické výstupy a vstupy od užívateľa.)
                    disp(['úloha (b):', newline]);
                    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                    pause(1);

                    % Separácia všetkých koreňov funkcie

                    % opýtame sa používateľa, že či chce rozdeliť funkciu na
                    % dve funkcie, teda g a h, kde h bude záporná, aby potom
                    % mohol odhadnúť reálne koreňe
                    askForSeparation(parameterA, parameterB, parameterC, parameterD, f);
                    % Počet koreňov od používateľa
                    rootsCountFromUser = getRootsCountFromUser();
                    % skutočná počet reálnych koreňov
                    rootsCount = getRootsCount(parameterA, parameterB, parameterC, parameterD);
                    % informujeme používateľa, či zadal dobrý počet koreňov a
                    % pokračujeme ďalej
                    compareRootCounts(rootsCountFromUser, rootsCount);

                    % V prípade ak počet koreňov je 0, tak sa vypíše hláška
                    if rootsCount == 0
                        disp('Rovnica nemá žiadne reálne korene, pokračujem ďalej...');
                        % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                        pause(1);
                        % pokračujeme s ďalším riadkom
                        continue;
                    end

                    % Zapíšeme do súboru Rovnica.txt že na ktorom riadku sa
                    % nachádzame v stupnom matici

                    % Otvoríme, prípadne vytvoríme súbor Rovnica.txt v adresári OutputFiles
                    % (v režimu append, zaručuje aby sa to vytvorilo v prípade ak to neexistuje)
                    EquationTxt = fopen('OutputFiles/Rovnica.txt', 'a');
                
                    % Zapíšeme relevantné informácie do súboru Rovnica.txt
                    fprintf(EquationTxt, "\n");
                    fprintf(EquationTxt, "##########################################################\n");
                    fprintf(EquationTxt, "###     Vstupný súbor Dataparametre.txt %d. riadok      ###\n", iterator);
                    fprintf(EquationTxt, "##########################################################\n");
                    fprintf(EquationTxt, "\n");
                    fclose(EquationTxt);

                    % získanie intervalov od používateľa, ich uloženie do
                    % matice intervals so stlpcami koreň, dolná hranica, horná
                    % hranica, takisto ich uložíme do súboru Rovnica.txt v
                    % adresári OutputFiles
                    intervals = getIntervalsAndSaveThemIntoFile(f, rootsCount, parameterA, parameterB, parameterC, parameterD);
                    % ----------------------------------------------------------------------------------------------------------------------------

                    % ----------------------------------------------------------------------------------------------------------------------------
                    % úloha (c) a (d):
                    % Metódou bisekcie (metóda polovičného delenia intervalu) a Newtonovou metódou aproximujte separované
                    % korene s presnosťou ε a odhadnite chyby aproximácií.
                    % Výsledky separácie, aproximačných metód a všetky relevantné informácie prehľadne zapíšte do súboru
                    % s názvom Rovnica.txt, ktorý je umiestnený v adresári OutputFiles.

                    disp(['úloha (c):', newline]);
                    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                    pause(1);

                    % Opýtame sa od používateľa, či on chce zadat epsilon,
                    % alebo či to chce načítať zo súboru, a uložíme epsilon do
                    % premennej s menom epsilon

                    disp(['Metóda bisekcie:', newline]);

                    % V prípade ak epsilon je neplatná hodnota v súbore DataParametre.txt
                    % tak sa používateľovi zobrazí hláška, že epsilon je neplatná hodnota
                    % a opýtame sa ho, či chce epsilon zadať vy alebo či chce pokračovať ďalej
                    epsilon = -1;
                    if ~isnan(DataParametersInputMatrix(iterator, 13)) && isreal(DataParametersInputMatrix(iterator, 13)) && DataParametersInputMatrix(iterator, 13) > 0
                        epsilon = getEpsilon(iterator, DataParametersInputMatrix);
                    else
                        disp(['V stlpci Epsilon v súbore Dataparametre.txt na riadku ', num2str(iterator), ' nie je zadaná hodnota epsilon alebo je zadaná zlá hodnota epsilon.']);

                        userChoice = input('Chcete epsilon zadať vy alebo chcete pokračovať s ďalším riadkom? (y/n), ak zadáte y, tak máte možnosť epsilon zadať, ak zadáte n, tak pokračujete ďalej: ', 's');
                        if strcmpi(userChoice, 'y')
                            epsilon = getEpsilonFromUser();
                        else
                            disp(['Pokračujem s ďalším riadkom.', newline]);
                            % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                            pause(1);
                            continue;
                        end
                    end

                    % Riešime aproximáciu metódou bisekcie

                    % spravíme aproximáciu pomocou bisekcie s intervalmi ktore sme ulozili do matice intervals a ulozime jeho
                    % vysledky do matici, vrátime aj celkový čas bisekcie pre
                    % všetke koreňe spolu, aj odhadnutú chybu
                    % krok, lava hranica, prava hranica, stred medzi nimi,
                    % koreň, následne zapíšeme informácie do súboru Rovnica.txt
                    [bisectionOutputMatrix, timeOfBisection, errorEstimateBisectionMatrix, bisectionRootsVector] = performBisectionAndSaveInformationsToFile(f, intervals, epsilon, parameterA, parameterB, parameterC, parameterD);

                    % Riešime aproximáciu metódou newtonovej metódy

                    % spravíme aproximáciu pomocou newtonovej metody uložíme
                    % vysledky do matici, vrátime aj celkový čas newtonove metódy pre
                    % všetke koreňe spolu, aj odhadnutú chybu
                    % následne zapíšeme informácie do súboru Rovnica.txt
                    [newtonOutputMatrix, timeOfNewtonMethod, errorEstimateNewtonMethodMatrix, newtonRootsVector] = performNewtonMethodAndSaveInformationToFile(f, intervals, epsilon, parameterA, parameterB, parameterC, parameterD);
                    
                    % úloha (e):
                    % Na základe výsledkov z bodu (c) porovnajte uvedené metódy a výsledky porovnania vhodne prezentujte
                    %v súbore s názvom Porovnania.txt, ktorý je umiestnený v adresári OutputFiles.

                    % Porovnávame bisekciu a newtonovu metodu a zapiseme
                    % vysledky do suboru Porovnania.txt v adresári OutputFiles
                    compareBisectionAndNewtonMethodsAndSaveResultsIntoFile(bisectionOutputMatrix, timeOfBisection, errorEstimateBisectionMatrix, bisectionRootsVector, newtonOutputMatrix, timeOfNewtonMethod, errorEstimateNewtonMethodMatrix, newtonRootsVector, iterator, parameterA, parameterB, parameterC, parameterD);

                % V prípade ak info je 2, pracujeme s našim integrálom
                case 2
                    disp(['-------------------------------------------', newline]);
                    disp(['Vstupný súbor DataParametre.txt ', num2str(iterator), '. riadok: ', newline]);
                    disp(['-------------------------------------------', newline]);
                    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                    pause(1);

                    disp(['Keďže info je 2, pracujeme s našim integrálom.', newline]);
                    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                    pause(1);

                    % % V prípade, že jeden z parametrov a, b, c, k, p, q, r, s, LB, UB, epsilon je NaN (Not a Number), alebo dolná hranica je vacsia ako horná, alebo menovatel je 0, alebo epsilon je záporné tak vypíšeme chybovú hlášku a preskočíme tento riadok
                    % if isnan(DataParametersInputMatrix(iterator, 2)) || isnan(DataParametersInputMatrix(iterator, 3)) || isnan(DataParametersInputMatrix(iterator, 4)) || isnan(DataParametersInputMatrix(iterator, 6)) || isnan(DataParametersInputMatrix(iterator, 8)) || isnan(DataParametersInputMatrix(iterator, 9)) || isnan(DataParametersInputMatrix(iterator, 10)) || isnan(DataParametersInputMatrix(iterator, 11)) || isnan(DataParametersInputMatrix(iterator, 12)) || isnan(DataParametersInputMatrix(iterator, 13)) || DataParametersInputMatrix(iterator, 13) < 0 || (DataParametersInputMatrix(iterator, 11) > DataParametersInputMatrix(iterator, 12)) || (DataParametersInputMatrix(iterator, 6) == 0 && DataParametersInputMatrix(iterator, 8) == 0) || (DataParametersInputMatrix(iterator, 9) == 0 && DataParametersInputMatrix(iterator, 10) == 0)
                    %     disp(['V súbore DataParametre.txt na riadku ', num2str(iterator), ' nie je zadaná hodnota niektorého z parametrov a, b, c, k, q, r, s, LB, UB, epsilon alebo je zadaná zlá hodnota niektorého z parametrov.']);
                    %     continue;
                    % end

                    % úloha (f):
                    % Vypočítajte určitý integrál
                    % I = LB-UB∫ (ax^2 + bx + c) / (kx + q)*(rx + s) dx

                    disp(['úloha (f):', newline]);
                    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                    pause(1);

                    % Parametre integrálu

                    % premenné parameterA, do ktorej uložíme hodnotu z
                    % DataParametersInputMatrix v stĺpci 2

                    % ak je hodnota NaN alebo nie je realne číslo, tak opýtame
                    % sa užívateľa, či chce zadať hodnotu parametra a, ak
                    % zvolí 1, tak zavoláme funkciu getParameterAForIntegral, ktorá
                    % nám vráti hodnotu parametra a, ak zvolí niečo iné, tak
                    % preskočíme tento riadok
                    if isnan(DataParametersInputMatrix(iterator, 2)) || ~isreal(DataParametersInputMatrix(iterator, 2))
                        disp(['V súbore DataParametre.txt na riadku ', num2str(iterator), ' nie je správna hodnota parametra a.']);
                        disp('Chcete zadať hodnotu parametra a alebo pokračovať s ďalším riadkom?');
                        userChoice = input('( zadajte 1 - zadať parameter a, zadajte hocičo iné ak chcete pokračovať s ďalším riadkom ): ', 's');

                        if strcmpi(userChoice, '1')
                            parameterA = getParameterAForIntegral();
                        else
                            % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                            disp(['Preskočíme tento riadok.', newline]);
                            pause(1);
                            continue;
                        end
                    else 
                        parameterA = DataParametersInputMatrix(iterator, 2);
                    end


                    % premenné parameterB, do ktorej uložíme hodnotu z
                    % DataParametersInputMatrix v stĺpci 3

                    % ak je hodnota NaN alebo nie je realne číslo, tak opýtame
                    % sa užívateľa, či chce zadať hodnotu parametra b, ak
                    % zvolí 1, tak zavoláme funkciu getParameterBForIntegral, ktorá
                    % nám vráti hodnotu parametra b, ak zvolí niečo iné, tak
                    % preskočíme tento riadok
                    if isnan(DataParametersInputMatrix(iterator, 3)) || ~isreal(DataParametersInputMatrix(iterator, 3))
                        disp(['V súbore DataParametre.txt na riadku ', num2str(iterator), ' nie je správna hodnota parametra b.']);
                        disp('Chcete zadať hodnotu parametra b alebo pokračovať s ďalším riadkom?');
                        userChoice = input('( zadajte 1 - zadať parameter b, zadajte hocičo iné ak chcete pokračovať s ďalším riadkom ): ', 's');

                        if strcmpi(userChoice, '1')
                            parameterB = getParameterBForIntegral();
                        else
                            % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                            disp(['Preskočíme tento riadok.', newline]);
                            pause(1);
                            continue;
                        end
                    else 
                        parameterB = DataParametersInputMatrix(iterator, 3);
                    end

                    % premenné parameterC, do ktorej uložíme hodnotu z
                    % DataParametersInputMatrix v stĺpci 4

                    % ak je hodnota NaN alebo nie je realne číslo, tak opýtame
                    % sa užívateľa, či chce zadať hodnotu parametra c, ak
                    % zvolí 1, tak zavoláme funkciu getParameterCForIntegral, ktorá
                    % nám vráti hodnotu parametra c, ak zvolí niečo iné, tak
                    % preskočíme tento riadok
                    if isnan(DataParametersInputMatrix(iterator, 4)) || ~isreal(DataParametersInputMatrix(iterator, 4))
                        disp(['V súbore DataParametre.txt na riadku ', num2str(iterator), ' nie je správna hodnota parametra c.']);
                        disp('Chcete zadať hodnotu parametra c alebo pokračovať s ďalším riadkom?');
                        userChoice = input('( zadajte 1 - zadať parameter c, zadajte hocičo iné ak chcete pokračovať s ďalším riadkom ): ', 's');

                        if strcmpi(userChoice, '1')
                            parameterC = getParameterCForIntegral();
                        else
                            % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                            disp(['Preskočíme tento riadok.', newline]);
                            pause(1);
                            continue;
                        end
                    else 
                        parameterC = DataParametersInputMatrix(iterator, 4);
                    end
                    

                    % premenné parameterK, do ktorej uložíme hodnotu z
                    % DataParametersInputMatrix v stĺpci 5

                    % ak je hodnota NaN alebo nie je realne číslo, tak opýtame
                    % sa užívateľa, či chce zadať hodnotu parametra k, ak
                    % zvolí 1, tak zavoláme funkciu getParameterKForIntegral, ktorá
                    % nám vráti hodnotu parametra k, ak zvolí niečo iné, tak
                    % preskočíme tento riadok
                    if isnan(DataParametersInputMatrix(iterator, 6)) || ~isreal(DataParametersInputMatrix(iterator, 6))
                        disp(['V súbore DataParametre.txt na riadku ', num2str(iterator), ' nie je správna hodnota parametra k.']);
                        disp('Chcete zadať hodnotu parametra k alebo pokračovať s ďalším riadkom?');
                        userChoice = input('( zadajte 1 - zadať parameter k, zadajte hocičo iné ak chcete pokračovať s ďalším riadkom ): ', 's');

                        if strcmpi(userChoice, '1')
                            parameterK = getParameterKForIntegral();
                        else
                            % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                            disp(['Preskočíme tento riadok.', newline]);
                            pause(1);
                            continue;
                        end
                    else 
                        parameterK = DataParametersInputMatrix(iterator, 6);
                    end
                    
                    % premenné parameterQ, do ktorej uložíme hodnotu z
                    % DataParametersInputMatrix v stĺpci 5

                    % ak je hodnota NaN alebo nie je realne číslo, tak opýtame
                    % sa užívateľa, či chce zadať hodnotu parametra q, ak
                    % zvolí 1, tak zavoláme funkciu getParameterQForIntegral, ktorá
                    % nám vráti hodnotu parametra q, ak zvolí niečo iné, tak
                    % preskočíme tento riadok
                    if isnan(DataParametersInputMatrix(iterator, 8)) || ~isreal(DataParametersInputMatrix(iterator, 8))
                        disp(['V súbore DataParametre.txt na riadku ', num2str(iterator), ' nie je správna hodnota parametra q.']);
                        disp('Chcete zadať hodnotu parametra q alebo pokračovať s ďalším riadkom?');
                        userChoice = input('( zadajte 1 - zadať parameter q, zadajte hocičo iné ak chcete pokračovať s ďalším riadkom ): ', 's');

                        if strcmpi(userChoice, '1')
                            parameterQ = getParameterQForIntegral();
                        else
                            % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                            disp(['Preskočíme tento riadok.', newline]);
                            pause(1);
                            continue;
                        end
                    else 
                        parameterQ = DataParametersInputMatrix(iterator, 8);
                    end

                    % premenné parameterR, do ktorej uložíme hodnotu z
                    % DataParametersInputMatrix v stĺpci 5

                    % ak je hodnota NaN alebo nie je realne číslo, tak opýtame
                    % sa užívateľa, či chce zadať hodnotu parametra r, ak
                    % zvolí 1, tak zavoláme funkciu getParameterRForIntegral, ktorá
                    % nám vráti hodnotu parametra r, ak zvolí niečo iné, tak
                    % preskočíme tento riadok
                    if isnan(DataParametersInputMatrix(iterator, 9)) || ~isreal(DataParametersInputMatrix(iterator, 9))
                        disp(['V súbore DataParametre.txt na riadku ', num2str(iterator), ' nie je správna hodnota parametra r.']);
                        disp('Chcete zadať hodnotu parametra r alebo pokračovať s ďalším riadkom?');
                        userChoice = input('( zadajte 1 - zadať parameter r, zadajte hocičo iné ak chcete pokračovať s ďalším riadkom ): ', 's');

                        if strcmpi(userChoice, '1')
                            parameterR = getParameterRForIntegral();
                        else
                            % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                            disp(['Preskočíme tento riadok.', newline]);
                            pause(1);
                            continue;
                        end
                    else 
                        parameterR = DataParametersInputMatrix(iterator, 9);
                    end

                    % premenné parameterS, do ktorej uložíme hodnotu z
                    % DataParametersInputMatrix v stĺpci 5

                    % ak je hodnota NaN alebo nie je realne číslo, tak opýtame
                    % sa užívateľa, či chce zadať hodnotu parametra s, ak
                    % zvolí 1, tak zavoláme funkciu getParameterSForIntegral, ktorá
                    % nám vráti hodnotu parametra s, ak zvolí niečo iné, tak
                    % preskočíme tento riadok
                    if isnan(DataParametersInputMatrix(iterator, 10)) || ~isreal(DataParametersInputMatrix(iterator, 10))
                        disp(['V súbore DataParametre.txt na riadku ', num2str(iterator), ' nie je správna hodnota parametra s.']);
                        disp('Chcete zadať hodnotu parametra s alebo pokračovať s ďalším riadkom?');
                        userChoice = input('( zadajte 1 - zadať parameter s, zadajte hocičo iné ak chcete pokračovať s ďalším riadkom ): ', 's');

                        if strcmpi(userChoice, '1')
                            parameterS = getParameterSForIntegral();
                        else
                            % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                            disp(['Preskočíme tento riadok.', newline]);
                            pause(1);
                            continue;
                        end
                    else 
                        parameterS = DataParametersInputMatrix(iterator, 10);
                    end

                    % ked k, q alebo  r, s su nulove, tak menovatel je nulovy, takze
                    % opytame sa uzivatela, ci zadat tie hodnoty znova
                    % alebo pokracovat s dalsim riadkom

                    % ak je k, q alebo r, s nulove, tak opytame sa uzivatela, ci
                    % chce znova zadat hodnoty pre k, q, r, s, ak zvolí 1, tak
                    % zavoláme funkciu getParametersKQRSTForIntegralInCaseOfZeroDenominator, ktorá
                    % nám vráti hodnoty pre k, q, r, s, ak zvolí niečo iné, tak
                    % preskočíme tento riadok
                    if (parameterK == 0 && parameterQ == 0) || (parameterR == 0 && parameterS == 0)
                        % opytame sa uzivatela, ci chce znova zadat hodnoty
                        % pre k, q, r, s
                        disp(['V súbore DataParametre.txt na riadku ', num2str(iterator), ' je nulový menovateľ.']);
                        disp('Chcete zadať hodnoty pre k, q, r, s alebo pokračovať s ďalším riadkom?');
                        userChoice = input('( zadajte 1 - zadať hodnoty pre k, q, r, s, zadajte hocičo iné ak chcete pokračovať s ďalším riadkom ): ', 's');

                        if strcmpi(userChoice, '1')
                            [parameterK, parameterQ, parameterR, parameterS] = getParametersKQRSTForIntegralInCaseOfZeroDenominator();
                        else
                            % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                            disp(['Preskočíme tento riadok.', newline]);
                            pause(1);
                            continue;
                        end
                    end

                    % dolná a horná hranica integrácie

                    % premenné lowerBound, do ktorej uložíme hodnotu z
                    % DataParametersInputMatrix v stĺpci 5

                    % ak je hodnota NaN alebo nie je realne číslo, tak opýtame
                    % sa užívateľa, či chce zadať dolnú hranicu integrácie, ak
                    % zvolí 1, tak zavoláme funkciu getLowerBoundForIntegral, ktorá
                    % nám vráti hodnotu dolnej hranice integrácie, ak zvolí niečo iné, tak
                    % preskočíme tento riadok
                    if isnan(DataParametersInputMatrix(iterator, 11)) || ~isreal(DataParametersInputMatrix(iterator, 11))
                        disp(['V súbore DataParametre.txt na riadku ', num2str(iterator), ' nie je správna hodnota dolnej hranice integrácie.']);
                        disp('Chcete zadať dolnú hranicu integrácie alebo pokračovať s ďalším riadkom?');
                        userChoice = input('( zadajte 1 - zadať dolnú hranicu integrácie, zadajte hocičo iné ak chcete pokračovať s ďalším riadkom ): ', 's');

                        if strcmpi(userChoice, '1')
                            lowerBound = getLowerBoundForIntegral();
                        else
                            % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                            disp(['Preskočíme tento riadok.', newline]);
                            pause(1);
                            continue;
                        end
                    else 
                        lowerBound = DataParametersInputMatrix(iterator, 11);
                    end

                    % premenné upperBound, do ktorej uložíme hodnotu z
                    % DataParametersInputMatrix v stĺpci 5

                    % ak je hodnota NaN alebo nie je realne číslo, tak opýtame
                    % sa užívateľa, či chce zadať hornú hranicu integrácie, ak
                    % zvolí 1, tak zavoláme funkciu getUpperBoundForIntegral, ktorá
                    % nám vráti hodnotu hornej hranice integrácie, ak zvolí niečo iné, tak
                    % preskočíme tento riadok
                    if isnan(DataParametersInputMatrix(iterator, 12)) || ~isreal(DataParametersInputMatrix(iterator, 12))
                        disp(['V súbore DataParametre.txt na riadku ', num2str(iterator), ' nie je správna hodnota horná hranica integrácie.']);
                        disp('Chcete zadať hodnotu hornej hranici integrácie alebo pokračovať s ďalším riadkom?');
                        userChoice = input('( zadajte 1 - zadať hornú hranicu integrácie, zadajte hocičo iné ak chcete pokračovať s ďalším riadkom ): ', 's');

                        if strcmpi(userChoice, '1')
                            upperBound = getUpperBoundForIntegral();
                        else
                            % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                            disp(['Preskočíme tento riadok.', newline]);
                            pause(1);
                            continue;
                        end
                    else 
                        upperBound = DataParametersInputMatrix(iterator, 12);
                    end

                    % v prípade ak je horná hranica integrácie menšia ako dolná, tak vymeníme ich hodnoty
                    if lowerBound > upperBound
                        % temp je pomocná premenná, do ktorej uložíme hodnotu
                        temp = lowerBound;
                        % do lowerBound uložíme hodnotu z upperBound
                        lowerBound = upperBound;
                        % do upperBound uložíme hodnotu z temp
                        upperBound = temp;

                        disp(['V súbore DataParametre.txt na riadku ', num2str(iterator), ' je horná hranica integrácie menšia ako dolná. Preto ich vymeníme.']);
                    end

                    % v prípade ak je horná hranica integrácie rovná dolnej, tak
                    % vypíšeme chybové hlásenie a preskočíme tento riadok
                    if lowerBound == upperBound
                        disp(['V súbore DataParametre.txt na riadku ', num2str(iterator), ' je horná hranica integrácie rovná dolnej. Preto sa integrácia nevykoná, pokračujeme s ďalším riadkom, ak existuje.']);
                        continue;
                    end

                    % presnosť integrácie pre simpsonovu metódu

                    % premenné epsilon, do ktorej uložíme hodnotu z
                    % DataParametersInputMatrix v stĺpci 5

                    % ak je hodnota NaN alebo nie je realne číslo, alebo je
                    % záporná, tak opýtame sa užívateľa, či chce zadať presnosť
                    % integrácie, ak zvolí 1, tak zavoláme funkciu
                    % getEpsilonForIntegral, ktorá nám vráti hodnotu presnosti
                    % integrácie, ak zvolí niečo iné, tak preskočíme tento riadok
                    if isnan(DataParametersInputMatrix(iterator, 13)) || ~isreal(DataParametersInputMatrix(iterator, 13)) || DataParametersInputMatrix(iterator, 13) <= 0
                        disp(['V súbore DataParametre.txt na riadku ', num2str(iterator), ' nie je správna hodnota presnosti integrácie.']);
                        disp('Chcete zadať hodnotu presnosti integrácie alebo pokračovať s ďalším riadkom? ');
                        userChoice = input('(zadajte 1 - zadať presnosť integrácie, zadajte hocičo iné ak chcete pokračovať s ďalším riadkom ): ', 's');

                        if strcmpi(userChoice, '1')
                            epsilon = getEpsilonForIntegral();
                        else
                            % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                            disp(['Preskočíme tento riadok.', newline]);
                            pause(1);
                            continue;
                        end
                    else 
                        epsilon = DataParametersInputMatrix(iterator, 13);
                    end
                    
                    % anonymná funkcia, ktorá reprezentuje funkciu, ktorú chceme
                    % integrovať
                    f = @(x) (parameterA * x.^2 + parameterB * x + parameterC) ./ ((parameterK * x + parameterQ) .* (parameterR * x + parameterS));

                    % Vypíšeme informácie o integráli používateľovi
                    displayIntegral(parameterA, parameterB, parameterC, parameterK, parameterQ, parameterR, parameterS, lowerBound, upperBound, epsilon);
                    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
                    pause(1);
                    % vypočítame hodnotu určitého integrálu pomocou simpsonovej metódy
                    % a uložíme ju do premennej integralValue, takisto uložíme
                    % všetky kroky a výsledky do súboru
                    integralValue = performSimpsonMethodAndSaveEveryStepAndResultIntoFile(f, lowerBound, upperBound, epsilon, iterator, parameterA, parameterB, parameterC, parameterK, parameterQ, parameterR, parameterS);
                end
        end
    else
        disp('Súbor DataParametre.txt nie je platný, neobsahuje 13 stlpcov alebo nebol nájdený. Skontrolujte, či je súbor v adresári InputFiles a že či obsahuje práve 13 stlpcov.');
    end
end

% funkcia userChoiceOnEquationOrIntegral, ktorá sa zavolá, ak sa v stĺpci info vyskytne nesprávny údaj
% a užívateľ bude mať možnosť medzi vybrať medzi rovnicou a určitým integrálom
function EquationOrIntegral = userChoiceOnEquationOrIntegral()
    % vytvoríme si premennú, ktorá bude určovať, či užívateľ chce vybrať medzi rovnicou a určitým integrálom
    userChoice = input(['Vyberte si medzi rovnicou a určitým integrálom. ', newline, 'Rovnica = 1, Určitý integrál = 2: '], 's');

    % inicializujeme premennú EquationOrIntegral, ktorá bude určovať, či užívateľ chce vybrať medzi rovnicou a určitým integrálom
    EquationOrIntegral = false;

    % ak užívateľ zadal 1, tak nastavíme premennú EquationOrIntegral na true a vrátime ju
    if strcmpi(userChoice, '1')
        % nastavíme premennú EquationOrIntegral na true
        EquationOrIntegral = true;
        return;
    % ak užívateľ zadal 2, tak nastavíme premennú EquationOrIntegral na false a vrátime ju
    elseif strcmpi(userChoice, '2')
        % nastavíme premennú EquationOrIntegral na false
        EquationOrIntegral = false;
        return;
    end

    % zavoláme si funkciu, ktorá bude kontrolovať, či užívateľ zadal správne údaje
    while ~strcmpi(userChoice, '1') && ~strcmpi(userChoice, '2')

        % vypíšeme do konzoly, že užívateľ zadal nesprávne údaje a bude mať možnosť znova zadať údaje
        disp('Nesprávne údaje, skúste znova.');
        userChoice = input(['Vyberte si medzi rovnicou a určitým integrálom. ', newline, 'Rovnica = 1, Určitý integrál = 2: '], 's');

        % ak užívateľ zadal 1, tak nastavíme premennú EquationOrIntegral na true a vrátime ju
        if strcmpi(userChoice, '1')
            EquationOrIntegral = true;
            return;
        % ak užívateľ zadal 2, tak nastavíme premennú EquationOrIntegral na false a vrátime ju
        elseif strcmpi(userChoice, '2')
            EquationOrIntegral = false;
            return;
        end
    end
end

% funkcia userChoiceOnInvalidInfo, ktorá sa zavolá, ak sa v stĺpci info vyskytne nesprávny údaj
% a užívateľ bude mať možnosť medzi vybrať medzi rovnicou a určitým integrálom alebo preskočiť na ďalší riadok, ak existuje
function userChoiceOutput = userChoiceOnInvalidInfo(iterator)
    % vytvoríme si premennú, ktorá bude určovať, či užívateľ chce vybrať medzi rovnicou a určitým integrálom alebo preskočiť na ďalší riadok, ak existuje
    userChoice = input(['Nesprávne údaje v riadku ', num2str(iterator), ' v stĺpci info. ', newline, 'Chcete vybrať medzi rovnicou a určitým integrálom? (y/n), (ak nechcete, tak preskočíme na ďalší riadok, ak existuje): '], 's');
    % inicializujeme premennú userChoiceOutput, ktorá bude určovať, či užívateľ chce vybrať medzi rovnicou a určitým integrálom alebo preskočiť na ďalší riadok, ak existuje
    userChoiceOutput = false;

    % ak užívateľ zadal y, tak nastavíme premennú userChoiceOutput na true a vrátime ju
    if strcmpi(userChoice, 'y')
        userChoiceOutput = true;
        return;
    % ak užívateľ zadal n, tak nastavíme premennú userChoiceOutput na false a vrátime ju
    elseif strcmpi(userChoice, 'n')
        return;
        userChoiceOutput = false;
    end

    % zavoláme si funkciu, ktorá bude kontrolovať, či užívateľ zadal správne údaje
    while ~strcmpi(userChoice, 'y') && ~strcmpi(userChoice, 'n')

        % vypíšeme do konzoly, že užívateľ zadal nesprávne údaje a bude mať možnosť znova zadať údaje
        disp('Nesprávne údaje, skúste znova.');
        userChoice = input(['Nesprávne údaje v riadku ', num2str(iterator), ' v stĺpci info. ', newline, 'Chcete vybrať medzi rovnicou a určitým integrálom? (y/n), (ak nechcete, tak preskočíme na ďalší riadok, ak existuje): '], 's');

        % ak užívateľ zadal y, tak nastavíme premennú userChoiceOutput na true a vrátime ju
        if strcmpi(userChoice, 'y')
            userChoiceOutput = true;
            return;
        % ak užívateľ zadal n, tak nastavíme premennú userChoiceOutput na false a vrátime ju
        elseif strcmpi(userChoice, 'n')
            userChoiceOutput = false;
            return;
        end
    end
end

% Funkcia displayIntegral, ktorá vypíše do konzoly, že aké parametre dostal náš integrál a vo forme I = LB-UB∫ (ax^2 + bx + c) / (kx + q)*(rx + s) dx
% 
% parametre: parameterA, parameterB, parameterC, parameterK, parameterQ, parameterR, parameterS, lowerBound, upperBound, epsilon
%
% vystup: void (žiadny)
function displayIntegral(parameterA, parameterB, parameterC, parameterK, parameterQ, parameterR, parameterS, lowerBound, upperBound, epsilon)
    disp(['Parameter a v integráli je: ', num2str(parameterA)]);
    disp(['Parameter b v integráli je: ', num2str(parameterB)]);
    disp(['Parameter c v integráli je: ', num2str(parameterC)]);
    disp(['Parameter k v integráli je: ', num2str(parameterK)]);
    disp(['Parameter q v integráli je: ', num2str(parameterQ)]);
    disp(['Parameter r v integráli je: ', num2str(parameterR)]);
    disp(['Parameter s v integráli je: ', num2str(parameterS)]);
    disp(['Parameter LB (doľná hranica) v integráli je: ', num2str(lowerBound)]);
    disp(['Parameter UB (horná hranica) v integráli je: ', num2str(upperBound)]);
    disp(['Parameter epsilon v integráli je: ', num2str(epsilon), newline]);

    disp(['Integrál, ktorý budeme počítať je I = ', num2str(lowerBound), '-', num2str(upperBound), '∫ (', num2str(parameterA), 'x^2 + ', num2str(parameterB), 'x + ', num2str(parameterC), ') / (', num2str(parameterK), 'x + ', num2str(parameterQ), ')*(', num2str(parameterR), 'x + ', num2str(parameterS), ') dx', newline]);
    disp(['Budeme to počítať pomocou Simpsonovej metódy.',newline]);
end

function epsilon = getEpsilonFromUser()
    % pomocná premenná pre epsilon ako retazec, vstup od pouzivatela
    epsilonHelp = '';
    % premenná pre epsilon, ktorú budeme vrátiť
    epsilon = -1;

    % pokial epsilon je zaporny alebo epsilonHelp nie je realne cislo
    while (~checkRealNumber(epsilonHelp) || epsilon <= 0)
        % Opytame sa na epsilon od používateľa
        epsilonHelp = input('Zadajte epsilon (presnosť, kladné nenulové číslo): ', 's');
        
        % Ak pomocná premenná je reálne číslo
        if (checkRealNumber(epsilonHelp))
            % prekonvertujeme pomocnú premennú na double a uložíme ho
            % do premennej epsilon
            epsilon = str2double(epsilonHelp);
            % Ak epsilon je záporný, informujeme používateľa o tom, že
            % zadal neplatný vstup
            if (epsilon <= 0)
                disp('Zadali ste neplatné epsilon! Skúste znova!');
            end
        else
            % ak pomocná premenná nie je reálne číslo, informujeme o
            % tom používateľa
            disp('Zadali ste neplatné epsilon! Skúste znova!');
        end
    end

    % Vypíšeme epsilon aby používateľ bol istý že boli uložené
    % správne
    disp(['Váš zvolený epsilon je: ', num2str(epsilon)]);
end

% Funkcia getEpsilon, ktorá sa opýta používateľa, či chce zadať epsilon on,
% alebo to chce načítať zo súboru
%
% vstup: iterator - integer - riadok v matici
% vstup: DataParameterMatrix
%
function epsilon = getEpsilon(iterator, DataParametersInputMatrix)
    % Pýtame sa od používateľa, aby zadal že či chce zadať epsilon on,
    % alebo to chce načítať zo súboru
    disp('Chcete zadať vstup pre epsilon vy alebo načítať zo súboru?');
    userChoice = input('(Zadajte z možností a, y, ano, yes ak ano - hocičo iné ak ho chcete načítať zo súboru):', 's');
    disp(newline);

    % V prípade, keď používateľ chce zadat epsilon
    if (strcmpi(userChoice, 'y') || strcmpi(userChoice, 'yes') || strcmpi(userChoice, 'ano') || strcmpi(userChoice, 'a'))

        % pomocná premenná pre epsilon ako retazec, vstup od pouzivatela
        epsilonHelp = '';
        % premenná pre epsilon, ktorú budeme vrátiť
        epsilon = -1;

        % pokial epsilon je zaporny alebo epsilonHelp nie je realne cislo
        while (~checkRealNumber(epsilonHelp) || epsilon <= 0)
            % Opytame sa na epsilon od používateľa
            epsilonHelp = input('Zadajte epsilon (presnosť, kladné číslo): ', 's');
            
            % Ak pomocná premenná je reálne číslo
            if (checkRealNumber(epsilonHelp))
                % prekonvertujeme pomocnú premennú na double a uložíme ho
                % do premennej epsilon
                epsilon = str2double(epsilonHelp);
                % Ak epsilon je záporný, informujeme používateľa o tom, že
                % zadal neplatný vstup
                if (epsilon <= 0)
                    disp('Zadali ste neplatné epsilon! Skúste znova!');
                end
            else
                % ak pomocná premenná nie je reálne číslo, informujeme o
                % tom používateľa
                disp('Zadali ste neplatné epsilon! Skúste znova!');
            end
        end
        
        % Vypíšeme epsilon aby používateľ bol istý že boli uložené
        % správne
        disp(['Epsilon pre ', num2str(iterator), '. riadok je: ', num2str(epsilon)]);
    else
        % uložíme i-ty riadok 12. stlpec (kde má byť hodnota epsilonu) zo
        % vstupného súboru
        epsilon = DataParametersInputMatrix(iterator, 13);
        % Vypíšeme epsilon aby používateľ bol istý že boli uložené
        % správne
        disp(['Epsilon pre ', num2str(iterator), '. riadok je: ', num2str(epsilon)]);
    end
end

% funkcia compareRootCounts, ktorá porovná počet koreňov od používateľa
% a počet a skutočný počet koreňov a podľa toho informuje používateľa či
% zadal správne alebo nie
%
% parametre rootsCountFromUser, rootsCount - integer
%
% výstup: void - funkcia nevracia žiadnú hodnotu, len informuje používateľa
% o počtu koreňov
function compareRootCounts(rootsCountFromUser, rootsCount)
    % porovnáme hodnotu ktorú zadal používateľ so skutočným počtom koreňov
    if rootsCountFromUser == rootsCount
        % ak ich presne zadal, informujeme o tom používateľa
        disp(['Váš odhad počtu koreňov je správny, teda ', num2str(rootsCount), '.']);
    else
        % ak ich nezadal presne, informujeme ho o tom, že nezadal počet
        % správne
        disp(['Váš odhad počtu koreňov je nesprávny. Skutočný počet reálnych koreňov je ', num2str(rootsCount), '.']);
    end
end

% Funkcia getRootsCount, ktorá
% určí počet reálnych koreňov polynómu
%
% parametre a, b, c, d, prvky polynómu
%
% výstup: rootsCount : integer - počet reálnych koreňov
function rootsCount = getRootsCount(a, b, c, d)
    % koeficienty polynómu odovzdáme pre funkciu roots() vo forme polynómu
    % a to nám zistí reálne koreňe a uložíme to do premennej rootsVector
    rootsVector = roots([a, b, c, d]);
    % odstránime duplikáty z vektoru koreňov
    rootsVector = unique(rootsVector);
    % spočítame počet reálnych koreňov, len tých, ktorí nie sú imaginárne
    % čísla pomocou funkcie imag(), čo nám vráti 0 (nulu) v prípade keď to
    % nie je imaginárne (komplexné) číslo 
    rootsCount = sum(imag(rootsVector) == 0);
end

% funkcia rootsCount na získanie počtu koreňov od používateľa
%
% výstup: rootsCount - integer - počet reálnych koreňov od používateľa
function rootsCount = getRootsCountFromUser()
    % Pomocná premenná na počet koreňov
    rootsCountHelp = '';

    % Pokiaľ pomocná premenná, teda náš vstup nie je reálne číslo 
    while (~checkNonNegativeInteger(rootsCountHelp))
        % Pýtame sa na vstup od používateľa
        rootsCountHelp = input("Zadajte počet reálnych koreňov: (kladné celé číslo) (Kde pretína červená a modrá funkcia, tam vidíme reálne korene funkcie.) ", "s");
        % Ak náš vstup je kladné celé číslo
        if (checkNonNegativeInteger(rootsCountHelp))
            % prekonvertujeme náš vstup na celé číslo a uložíme ho do
            % premennej rootsCount
            rootsCount = str2num(rootsCountHelp);
        else
            % Ak náš vstup nie je kladné celé číslo, informujeme o tom
            % používateľa
            disp("Zadali ste neplatný vstup! Skúste znova!");
        end
    end
end

% pomocná funkcia checkNonNegativeInteger na kontrolu vstupu že či je nezáporné číslo
function isValid = checkNonNegativeInteger(numberString)
    % inicializujeme našu premennú ktorú budeme vrátiť
    isValid = false;
    % prekonvertujeme vstup na číslo
    number = str2double(numberString);

    % ak to neni NaN, a je to celé číslo, teda floor vráti to isté číslo a
    % je vačšie alebo rovná sa 0
    if (~isnan(number) && (floor(number) == number) && (number >= 0))
        % nastavíme našu premennú na true
        isValid = true;
    end
end

% Funkcia askForSeparation sa opýta od používateľa že či chce separovať
% funkciu f
%
% parametre a, b, c, d, dolne ohranicenie, horne ohranicenie, anonymna
% funkcia f
% 
% výstup: void (funkcia nevracia nič)
function askForSeparation(parameterA, parameterB, parameterC, parameterD, f)
    % Ak používateľ chce, separujeme našu rovnicu na g(x) a h(x), kde h(x) bude záporná

    % Pomocná premenná na validný vstup
    validInput = false;

    % Pokiaľ náš vstup nie je platný
    while (~validInput)
        % Pýtame sa na vstup od používateľa s inštrukciami
        disp('Chcete rozdeliť funkciu f(x) na g(x) a h(x)?');
        disp('Rozdelenie vám uľahčí vidieť reálne koreňe funkcie f');
        disp('Ak áno, zadajte a, ano, ANO, y alebo Y');
        separateInput = input("ak nechcete, zadajte n, N, no, NO, nie, NIE: ", 's');

        % V prípade keď používateľ chce separovať
        if (strcmpi(separateInput, 'y') || strcmpi(separateInput, 'yes') || strcmpi(separateInput, 'ano') || strcmpi(separateInput, 'a'))
            % opýtame sa používateľa na dolné a horné ohraničenie
            [infOfSeparation, supOfSeparation] = getBounds();
            % zobrazíme dané funkcie
            plotSeparatedFunctions(parameterA, parameterB, parameterC, parameterD, infOfSeparation, supOfSeparation, f);
            % nastavíme našu pomocnú premennú pre validný vstup na true
            validInput = true;
        elseif (strcmpi(separateInput, 'n') || strcmpi(separateInput, 'no') || strcmpi(separateInput, 'nie'))
            % informujeme o tom používateľa, že rovnica nebola separovaná
            disp('Rovnica nebola separovaná.');
            % nastavíme našu pomocnú premennú pre validný vstup na true
            validInput = true;
        % Keď používateľ nezadal platný vstup, informujeme ho o tom
        else
            % Informujemeo o tom používateľa že zadal neplatný vstup
            disp('Zadali ste neplatný vstup! Skúste znova!');
        end
    end

    % informujeme o tom používateľa že má určit počet koreňov a potom
    % intervaly v ktorých sa nachádzajú
    disp(newline);
    disp("Podľa grafického výstupu funkcie určte počet koreňov a intervaly v ktorých sa nachadzajú! (Kde pretína červená a modrá funkcia, tam vidíme korene funkcie.)");
end

% Funkcia plotSeparatedFunctions nám rozdelí funkcie na g(x) a h(x) funkcie a zobrazuje ich používateľovi aj
% v textovej a aj v grafickej podobe
%
% parametre a, b, c, d, dolne ohranicenie, horne ohranicenie, anonymna
% funkcia f
% 
% výstup: void (funkcia nevracia nič)
function plotSeparatedFunctions(parameterA, parameterB, parameterC, parameterD, infOfSeparation, supOfSeparation, f)
    
    % rozdelenie na g a h, h je zaporna
    g = @(x) (parameterA * x.^3 + parameterB * x.^2);
    h = @(x) (-parameterC * x - parameterD);

    % výpisy, aby používateľ videl separované funkcie
    disp(['Rovnica bola separovaná na g(x) a h(x), teda na dve funkcie.', newline]);
    disp(['Funkcia g(x) má tvar: g(x) = ' num2str(parameterA) 'x^3 + ' num2str(parameterB) 'x^2']);
    disp(['Funkcia h(x) má tvar: h(x) = -' num2str(parameterC) 'x - ' num2str(parameterD), newline]);

    % grafické zobrazovanie použitím fplot funkcie

    % funkcia f v žltej farbe
    fplot(f, [infOfSeparation supOfSeparation], 'y')
    hold on 

    % funkcia g v červenej farbe
    fplot(g, [infOfSeparation supOfSeparation], 'r')
    hold on

    % funkcia h v modrej farbe
    fplot(h, [infOfSeparation supOfSeparation], 'b')
    hold on

    % y = 0 v zelenej farbe
    fplot(0, [infOfSeparation supOfSeparation], 'g')
    hold off

    % zapneme mriežky v okienku
    grid on

    % hlavna titulka 
    title('Grafická reprezentácia funkcií f(x), g(x), h(x) a y = 0')

    % x-ova os
    xlabel('x-os')

    % y-ova os
    ylabel('y-os')

    % pridanie legendy, aby sme bolo lahše spoznávateľné že ktorá farba
    % reprezentuje ktorú fuknciu
    legend('f(x)', 'g(x)', 'h(x)', 'y = 0')

    % informujeme používateľa o tom, že kde sú koreňe funkcie
    disp(['V osobitnom okienku môžete vidieť funkcie f, g a h, kde pretína červená a modrá funkcia, tam vidíme koreňe funkcie.', newline]);
end

% Funkcia getBounds na ziskanie dolnej a hornej hranice priblíženia
% 
% parametre infOfSeparation, supOfSeparation - double
% 
% výstup: infOfSeparation, supOfSeparation - double
function [infOfSeparation, supOfSeparation] = getBounds()
    % Pomocné premenné na dolné a horné ohraničenia priblíženia
    infOfSeparationHelp = '';
    supOfSeparationHelp = '';

    % Pýtame sa dolnú hranicu priblíženia, pokiaľ to nie je číslo
    % opýtame sa na to znova
    while (~checkRealNumber(infOfSeparationHelp))
        % Získame vstup od používateľa pre dolnú hranicu priblíženia
        infOfSeparationHelp = input("Zadajte dolnú hranicu priblíženia na zobrazenie grafov v osobitnom okienku : ", "s");
        if (checkRealNumber(infOfSeparationHelp))
            % Konverzia vstupu na číslo
            infOfSeparation = str2double(infOfSeparationHelp);
        else
            % Vypíšeme hlásenie, že dolná hranica nie je platná
            disp("Zadali ste neplatnú dolnú hranicu! Skúste znova!");
        end
    end

    % Pýtame sa hornú hranicu priblíženia, pokiaľ to nie je číslo
    % opýtame sa na to znova
    while (~checkRealNumber(supOfSeparationHelp))
        % Získame vstup od používateľa pre hornú hranicu priblíženia
        supOfSeparationHelp = input("Zadajte hornú hranicu priblíženia na zobrazenie grafov v osobitnom okienku : ", "s");
        if (checkRealNumber(supOfSeparationHelp))
            % Konverzia vstupu na číslo
            supOfSeparation = str2double(supOfSeparationHelp);
        else
            % Vypíšeme hlásenie, že horná hranica nie je platná
            disp("Zadali ste neplatnú hornú hranicu! Skúste znova!");
        end
    end

    % Ak je dolná hranica väčšia ako horná hranica, vymeníme ich hodnoty
    if (infOfSeparation > supOfSeparation)
        % do pomocnej premennej temp uložíme hornú hranicu
        temp = supOfSeparation;
        % hornú hranicu nastavíme na dolnú
        supOfSeparation = infOfSeparation;
        % dolnú hranicu nastavíme na hodnotu pomocnej premennej ktorá
        % obsahouje predošlú hodnotu hornej hranice
        infOfSeparation = temp;
        % Vypíšeme hlásenie, že sme vymenili hranice
        disp(['Keďže ste zadali väčšiu doľnú hranicu priblíženia ako hornú hranicu, tak som ich vymenil']);
    else
        return;
    end
end


% funkcia displayEquation, kde výpisom aj s grafickou reprezentáciou zobrazíme zápis rovnice používateľovi s hláškou
% že funkcia bola zadefinovaná ako anonynmná funkcia v
% matlabe
%
% parametre a, b, c, d - double - reálne čísla reprezentujúce parametrov
% rovnice
%
% výstup: void (nevracia to žiadný výstup)
function displayEquation(parameterA, parameterB, parameterC, parameterD, f)
    disp(['Vaša rovnica v Matlabe bola zadefinovaná ako anonymná funkcia f s Vašimi zvolenými parametrami!', newline]);
    disp(['Vyzerá to nasledovne: ', num2str(parameterA), ' * x^3 + ', num2str(parameterB), ' * x^2 + ', num2str(parameterC), ' * x + ', num2str(parameterD), ' = 0', newline]);

    % Vykreslíme f(x) v červenej farbe
    fplot(f, [-100 100], 'r')
    hold on

    % Vykreslíme y = 0 (rovnica x-ovej osi) v zelenej farbe
    fplot(0, [-100 100], 'g')

    hold off
    grid on

    % Pridanie názvu grafu
    title('Grafická reprezentácia funkcie f(x)')
    
    % Pridanie popiskov osí
    xlabel('x-os')
    ylabel('y-os')
    
    % Pridanie legendy
    legend('f(x)', 'y = 0')
    
    % Výpis informácie o pretínacích bodoch
    disp('V osobitnom okienku môžete vidieť vašu funkciu f(x).');
end

function [parameterB, parameterC, parameterD] = getParametersBCDFromUser()
    parameterB = 0;
    parameterC = 0;
    parameterD = 0;

    % Pomocné premenné 'helpParameterB', 'helpParameterC', 'helpParameterD' vo forme reťazca čo nám umožnuje načítavaný
    % vstup kontrolovať či je to reálne číslo a či to neni neplatný vstup (napríklad písmeno, špeciálny karakter, prázdny reťazec)
    helpParameterB = '';
    helpParameterC = '';
    helpParameterD = '';

    % Pokiaľ dve parametre sú nulové alebo niektorí z parametrov nie sú reálne
    % čísla
    while (parameterB == 0 && parameterC == 0) || (parameterB == 0 && parameterD == 0) || (parameterC == 0 && parameterD == 0 || ~checkRealNumber(helpParameterB) || ~checkRealNumber(helpParameterC) || ~checkRealNumber(helpParameterD))
        % Pýtame sa vstupy od používateľa na všetky tri(3) parametre zaradom
        helpParameterB = input('Zadajte hodnotu parametra b (reálne číslo): ', 's');
        helpParameterC = input('Zadajte hodnotu parametra c (reálne číslo): ', 's');
        helpParameterD = input('Zadajte hodnotu parametra d (reálne číslo): ', 's');
    
        % Ak všetké vstupy sú reálne čísla, prekonvertujeme ich na double (desatinné číslo)
        if (checkRealNumber(helpParameterB) && checkRealNumber(helpParameterC) && checkRealNumber(helpParameterD))
            parameterB = str2double(helpParameterB);
            parameterC = str2double(helpParameterC);
            parameterD = str2double(helpParameterD);
            
            % V prípade, ak aspoň dve čísla z troch sú nulové, informujeme o
            % tom používateľa
            if (parameterB == 0 && parameterC == 0) || (parameterB == 0 && parameterD == 0) || (parameterC == 0 && parameterD == 0)
                disp('Aspoň dva z parametrov b, c, d musia byť nenulové! Skúste znovu!');
            end
        else
            % Ak tie vstupy nie sú reálne čísla, poprosíme používateľa aby
            % zadal reálne čísla
            disp('Prosím, zadajte reálne čísla!');
        end
    end

    % Vypíšeme parametre 'b', 'c', 'd' aby používateľ bol istý že boli uložené
    % správne
    disp(['Váš zvolený parameter b je: ', num2str(parameterB)]);
    disp(['Váš zvolený parameter c je: ', num2str(parameterC)]);
    disp(['Váš zvolený parameter d je: ', num2str(parameterD), newline]);
end

% funkcia getParameterBCD, kde používateľ sa môže rozhodnúť, či chce zadať
% parametre b, c, d ako vstup alebo chce to načítať z konkrétneho riadku
%
% parameter iterator: integer - aktuálny riadok v matici
% parameter DataParametersInputMatrix - daná matica z ktorej načítavame
%
% výstup: [parameterB, parameterC, parameterD] : [double, double, double] -
% tri reálne čísla z ktorých maximálne 1 môže byť nulové
function [parameterB, parameterC, parameterD] = getParametersBCD(iterator, DataParametersInputMatrix)
    % opýtame sa používateľa, že či chce zadať parametre b, c, d on alebo načítať
    % to zo súboru
    disp('Chcete zadať parametre b, c, d alebo ich načítať zo súboru?');
    userChoice = input('(Zadajte z možností a, y, ano, yes ak ano - hocičo iné ak ich chete načítať zo súboru):', 's');
    disp(newline);

    % V prípade, keď používateľ chce zadat parametre ako vstup
    if (strcmpi(userChoice, 'y') || strcmpi(userChoice, 'yes') || strcmpi(userChoice, 'ano') || strcmpi(userChoice, 'a'))
        % Získanie parametrov 'b', 'c', 'd' od používateľa a ich kontrola
        
        % Premenné 'parameterB', 'parameterC', 'parameterD' ktoré budú
        % reprezentovať parametre 'b', 'c' a 'd'
        parameterB = 0;
        parameterC = 0;
        parameterD = 0;
        
        % Pomocné premenné 'helpParameterB', 'helpParameterC', 'helpParameterD' vo forme reťazca čo nám umožnuje načítavaný
        % vstup kontrolovať či je to reálne číslo a či to neni neplatný vstup (napríklad písmeno, špeciálny karakter, prázdny reťazec)
        helpParameterB = '';
        helpParameterC = '';
        helpParameterD = '';
        
        % Pokiaľ dve parametre sú nulové alebo niektorí z parametrov nie sú reálne
        % čísla
        while (parameterB == 0 && parameterC == 0) || (parameterB == 0 && parameterD == 0) || (parameterC == 0 && parameterD == 0 || ~checkRealNumber(helpParameterB) || ~checkRealNumber(helpParameterC) || ~checkRealNumber(helpParameterD))
            % Pýtame sa vstupy od používateľa na všetky tri(3) parametre zaradom
            helpParameterB = input('Zadajte hodnotu parametra b (reálne číslo): ', 's');
            helpParameterC = input('Zadajte hodnotu parametra c (reálne číslo): ', 's');
            helpParameterD = input('Zadajte hodnotu parametra d (reálne číslo): ', 's');
        
            % Ak všetké vstupy sú reálne čísla, prekonvertujeme ich na double (desatinné číslo)
            if (checkRealNumber(helpParameterB) && checkRealNumber(helpParameterC) && checkRealNumber(helpParameterD))
                parameterB = str2double(helpParameterB);
                parameterC = str2double(helpParameterC);
                parameterD = str2double(helpParameterD);
                
                % V prípade, ak aspoň dve čísla z troch sú nulové, informujeme o
                % tom používateľa
                if (parameterB == 0 && parameterC == 0) || (parameterB == 0 && parameterD == 0) || (parameterC == 0 && parameterD == 0)
                    disp('Aspoň dva z parametrov b, c, d musia byť nenulové! Skúste znovu!');
                end
            else
                % Ak tie vstupy nie sú reálne čísla, poprosíme používateľa aby
                % zadal reálne čísla
                disp('Prosím, zadajte reálne čísla!');
            end
        end
        
        % Vypíšeme parametre 'b', 'c', 'd' aby používateľ bol istý že boli uložené
        % správne
        disp(['Váš zvolený parameter b je: ', num2str(parameterB)]);
        disp(['Váš zvolený parameter c je: ', num2str(parameterC)]);
        disp(['Váš zvolený parameter d je: ', num2str(parameterD), newline]);
    else
        % Načítanie parametrov b, c, d z matice a ich uloženie do
        % parametrov ktoré budú vrátené od funkcie
        parameterB = DataParametersInputMatrix(iterator, 3);
        parameterC = DataParametersInputMatrix(iterator, 4);
        parameterD = DataParametersInputMatrix(iterator, 5);

        % Vypíšeme parametre 'b', 'c', 'd' aby používateľ bol istý že boli uložené
        % správne
        disp(['Parameter b pre ', num2str(iterator), '. riadok je: ', num2str(parameterB)]);
        disp(['Parameter c pre ', num2str(iterator), '. riadok je: ', num2str(parameterC)]);
        disp(['Parameter d pre ', num2str(iterator), '. riadok je: ', num2str(parameterD), newline]);
    end
end

function epsilon = getEpsilonForIntegral()

    % pomocná premenná
    helpEpsilon = '';

    % premennej epsilon priradíme neplatnú hodnotu
    epsilon = -1;

    % vstup kontrolovať či je to reálne číslo a či to neni neplatný vstup (napríklad písmeno, špeciálny karakter, prázdny reťazec)
    while (~checkRealNumber(helpEpsilon) || epsilon <= 0)
        % Opýtame sa na vstup od používateľa
        helpEpsilon = input('Zadajte epsilon (reálne, kladné, nenulové číslo): ', 's');
        % V prípade, keď to je reálne číslo
        if (checkRealNumber(helpEpsilon))
            % Prekonvertujeme to číslo na double (desatinné číslo)
            epsilon = str2double(helpEpsilon);
        else
            % V inom prípade informujeme používateľa o tom, že zadal neplatný
            % vstup
            disp('Zadali ste neplatný vstup!');
        end
    end

    % Vypíšeme epsilon aby používateľ bol istý že to bolo uložené správne
    disp(['Váš zvolený epsilon je: ', num2str(epsilon)]);
end

function parameterA = getParameterAForIntegral()

    % Pomocná premenná 'helpParameterA' vo forme reťazca čo nám umožnuje načítavaný
    helpParameterA = '';

    % vstup kontrolovať či je to reálne číslo a či to neni neplatný vstup (napríklad písmeno, špeciálny karakter, prázdny reťazec)
    while (~checkRealNumber(helpParameterA))
        % Opýtame sa na vstup od používateľa
        helpParameterA = input('Zadajte hodnotu parametra a (reálne číslo): ', 's');
        % V prípade, keď to je reálne číslo
        if (checkRealNumber(helpParameterA))
            % Prekonvertujeme to číslo na double (desatinné číslo)
            parameterA = str2double(helpParameterA);
        else
            % V inom prípade informujeme používateľa o tom, že zadal neplatný
            % vstup
            disp('Zadali ste neplatný vstup!');
        end
    end

    % Vypíšeme parameter 'a' aby používateľ bol istý že to bolo uložené správne
    disp(['Váš zvolený parameter a je: ', num2str(parameterA)]);
end

function parameterB = getParameterBForIntegral()

    % Pomocná premenná 'helpParameterB' vo forme reťazca čo nám umožnuje načítavaný
    helpParameterB = '';

    % vstup kontrolovať či je to reálne číslo a či to neni neplatný vstup (napríklad písmeno, špeciálny karakter, prázdny reťazec)
    while (~checkRealNumber(helpParameterB))
        % Opýtame sa na vstup od používateľa
        helpParameterB = input('Zadajte hodnotu parametra b (reálne číslo): ', 's');
        % V prípade, keď to je reálne číslo
        if (checkRealNumber(helpParameterB))
            % Prekonvertujeme to číslo na double (desatinné číslo)
            parameterB = str2double(helpParameterB);
        else
            % V inom prípade informujeme používateľa o tom, že zadal neplatný
            % vstup
            disp('Zadali ste neplatný vstup!');
        end
    end

    % Vypíšeme parameter 'b' aby používateľ bol istý že to bolo uložené správne
    disp(['Váš zvolený parameter b je: ', num2str(parameterB)]);
end

function parameterC = getParameterCForIntegral()

    % Pomocná premenná 'helpParameterC' vo forme reťazca čo nám umožnuje načítavaný
    helpParameterC = '';

    % vstup kontrolovať či je to reálne číslo a či to neni neplatný vstup (napríklad písmeno, špeciálny karakter, prázdny reťazec)
    while (~checkRealNumber(helpParameterC))
        % Opýtame sa na vstup od používateľa
        helpParameterC = input('Zadajte hodnotu parametra c (reálne číslo): ', 's');
        % V prípade, keď to je reálne číslo
        if (checkRealNumber(helpParameterC))
            % Prekonvertujeme to číslo na double (desatinné číslo)
            parameterC = str2double(helpParameterC);
        else
            % V inom prípade informujeme používateľa o tom, že zadal neplatný
            % vstup
            disp('Zadali ste neplatný vstup!');
        end
    end

    % Vypíšeme parameter 'c' aby používateľ bol istý že to bolo uložené správne
    disp(['Váš zvolený parameter c je: ', num2str(parameterC)]);
end

function parameterK = getParameterKForIntegral()
    
    % Pomočná premenná 'helpParameterK' vo forme reťazca čo nám umožnuje načítavaný
    helpParameterK = '';

    % vstup kontrolovať či je to reálne číslo a či to neni neplatný vstup (napríklad písmeno, špeciálny karakter, prázdny reťazec)
    while (~checkRealNumber(helpParameterK))
        % Opýtame sa na vstup od používateľa
        helpParameterK = input('Zadajte hodnotu parametra k (reálne číslo): ', 's');
        % V prípade, keď to je reálne číslo
        if (checkRealNumber(helpParameterK))
            % Prekonvertujeme to číslo na double (desatinné číslo)
            parameterK = str2double(helpParameterK);
        else
            % V inom prípade informujeme používateľa o tom, že zadal neplatný
            % vstup
            disp('Zadali ste neplatný vstup!');
        end
    end

    % Vypíšeme parameter 'k' aby používateľ bol istý že to bolo uložené správne
    disp(['Váš zvolený parameter k je: ', num2str(parameterK)]);
end

function parameterQ = getParameterQForIntegral()

    % Pomocná premenná 'helpParameterQ' vo forme reťazca čo nám umožnuje načítavaný
    helpParameterQ = '';

    % vstup kontrolovať či je to reálne číslo a či to neni neplatný vstup (napríklad písmeno, špeciálny karakter, prázdny reťazec)
    while (~checkRealNumber(helpParameterQ))
        % Opýtame sa na vstup od používateľa
        helpParameterQ = input('Zadajte hodnotu parametra q (reálne číslo): ', 's');
        % V prípade, keď to je reálne číslo
        if (checkRealNumber(helpParameterQ))
            % Prekonvertujeme to číslo na double (desatinné číslo)
            parameterQ = str2double(helpParameterQ);
        else
            % V inom prípade informujeme používateľa o tom, že zadal neplatný
            % vstup
            disp('Zadali ste neplatný vstup!');
        end
    end

    % Vypíšeme parameter 'q' aby používateľ bol istý že to bolo uložené správne
    disp(['Váš zvolený parameter q je: ', num2str(parameterQ)]);
end

function parameterR = getParameterRForIntegral()

    % Pomocná premenná 'helpParameterR' vo forme reťazca čo nám umožnuje načítavaný
    helpParameterR = '';

    % vstup kontrolovať či je to reálne číslo a či to neni neplatný vstup (napríklad písmeno, špeciálny karakter, prázdny reťazec)
    while (~checkRealNumber(helpParameterR))
        % Opýtame sa na vstup od používateľa
        helpParameterR = input('Zadajte hodnotu parametra r (reálne číslo): ', 's');
        % V prípade, keď to je reálne číslo
        if (checkRealNumber(helpParameterR))
            % Prekonvertujeme to číslo na double (desatinné číslo)
            parameterR = str2double(helpParameterR);
        else
            % V inom prípade informujeme používateľa o tom, že zadal neplatný
            % vstup
            disp('Zadali ste neplatný vstup!');
        end
    end

    % Vypíšeme parameter 'r' aby používateľ bol istý že to bolo uložené správne
    disp(['Váš zvolený parameter r je: ', num2str(parameterR)]);
end

function parameterS = getParameterSForIntegral()

    % Pomocná premenná 'helpParameterS' vo forme reťazca čo nám umožnuje načítavaný
    helpParameterS = '';

    % vstup kontrolovať či je to reálne číslo a či to neni neplatný vstup (napríklad písmeno, špeciálny karakter, prázdny reťazec)
    while (~checkRealNumber(helpParameterS))
        % Opýtame sa na vstup od používateľa
        helpParameterS = input('Zadajte hodnotu parametra s (reálne číslo): ', 's');
        % V prípade, keď to je reálne číslo
        if (checkRealNumber(helpParameterS))
            % Prekonvertujeme to číslo na double (desatinné číslo)
            parameterS = str2double(helpParameterS);
        else
            % V inom prípade informujeme používateľa o tom, že zadal neplatný
            % vstup
            disp('Zadali ste neplatný vstup!');
        end
    end

    % Vypíšeme parameter 's' aby používateľ bol istý že to bolo uložené správne
    disp(['Váš zvolený parameter s je: ', num2str(parameterS)]);
end

% Funkcia getParametersKQRSTForIntegralInCaseOfZeroDenominator slúži na získanie parametrov k, q, r, s v prípade, keď je menovateľ rovný nule
% Vstup: žiadny
% Výstup: parameter k, parameter q, parameter r, parameter s
function [parameterK, parameterQ, parameterR, parameterS] = getParametersKQRSTForIntegralInCaseOfZeroDenominator()
    % Pomocné premenné
    helpParameterK = '';
    helpParameterQ = '';
    helpParameterR = '';
    helpParameterS = '';

    % premenne pre výstup
    parameterK = 0;
    parameterQ = 0;
    parameterR = 0;
    parameterS = 0;

    % všetky parametre musia byť reálne čísla a      k q, alebo r s nesmú byť nulové

    while (parameterK == 0 && parameterQ == 0) || (parameterR == 0 && parameterS == 0) || (~checkRealNumber(helpParameterK)) || (~checkRealNumber(helpParameterQ)) || (~checkRealNumber(helpParameterR)) || (~checkRealNumber(helpParameterS))
        % Opýtame sa na vstup od používateľa
        helpParameterK = input('Zadajte hodnotu parametra k (reálne číslo): ', 's');
        helpParameterQ = input('Zadajte hodnotu parametra q (reálne číslo): ', 's');
        helpParameterR = input('Zadajte hodnotu parametra r (reálne číslo): ', 's');
        helpParameterS = input('Zadajte hodnotu parametra s (reálne číslo): ', 's');

        % V prípade, keď sú všetky hodnoty reálne čísla
        if (checkRealNumber(helpParameterK) && checkRealNumber(helpParameterQ) && checkRealNumber(helpParameterR) && checkRealNumber(helpParameterS))
            % Prekonvertujeme to číslo na double (desatinné číslo)
            parameterK = str2double(helpParameterK);
            parameterQ = str2double(helpParameterQ);
            parameterR = str2double(helpParameterR);
            parameterS = str2double(helpParameterS);
        else
            % V inom prípade informujeme používateľa o tom, že zadal neplatný
            % vstup
            disp('Zadali ste neplatné hodnoty, skúste znova!');
        end

        % V prípade, že je menovateľ rovný nule, tak k = 0 a q = 0
        % alebo r = 0 a s = 0
        if (parameterK == 0 && parameterQ == 0)
            disp('Zadali ste neplatný vstup! parametre k a q nesmú byť nulové!');
        end

        if (parameterR == 0 && parameterS == 0)
            disp('Zadali ste neplatný vstup! parametre r a s nesmú byť nulové!');
        end
    end 

    % Vypíšeme parametre aby používateľ bol istý že to bolo uložené správne
    disp(['Váš zvolený parameter k je: ', num2str(parameterK)]);
    disp(['Váš zvolený parameter q je: ', num2str(parameterQ)]);
    disp(['Váš zvolený parameter r je: ', num2str(parameterR)]);
    disp(['Váš zvolený parameter s je: ', num2str(parameterS)]);
end

function lowerBound = getLowerBoundForIntegral()

    % pomocná premenná
    helpLowerBound = '';

    % vstup kontrolovať či je to reálne číslo a či to neni neplatný vstup (napríklad písmeno, špeciálny karakter, prázdny reťazec)
    while (~checkRealNumber(helpLowerBound))
        % Opýtame sa na vstup od používateľa
        helpLowerBound = input('Zadajte dolnú hranicu integrácie (reálne číslo): ', 's');
        % V prípade, keď to je reálne číslo
        if (checkRealNumber(helpLowerBound))
            % Prekonvertujeme to číslo na double (desatinné číslo)
            lowerBound = str2double(helpLowerBound);
        else
            % V inom prípade informujeme používateľa o tom, že zadal neplatný
            % vstup
            disp('Zadali ste neplatný vstup!');
        end
    end

    % Vypíšeme dolnú hranicu aby používateľ bol istý že to bolo uložené správne
    disp(['Váš zvolený dolný limit integrácie je: ', num2str(lowerBound)]);
end

function upperBound = getUpperBoundForIntegral()

    % pomocná premenná
    helpUpperBound = '';

    % vstup kontrolovať či je to reálne číslo a či to neni neplatný vstup (napríklad písmeno, špeciálny karakter, prázdny reťazec)
    while (~checkRealNumber(helpUpperBound))
        % Opýtame sa na vstup od používateľa
        helpUpperBound = input('Zadajte hornú hranicu integrácie (reálne číslo): ', 's');
        % V prípade, keď to je reálne číslo
        if (checkRealNumber(helpUpperBound))
            % Prekonvertujeme to číslo na double (desatinné číslo)
            upperBound = str2double(helpUpperBound);
        else
            % V inom prípade informujeme používateľa o tom, že zadal neplatný
            % vstup
            disp('Zadali ste neplatný vstup!');
        end
    end

    % Vypíšeme hornú hranicu aby používateľ bol istý že to bolo uložené správne
    disp(['Váš zvolený horný limit integrácie je: ', num2str(upperBound)]);
end

% funkcia getParameterA, kde používateľ sa môže rozhodnúť, či chce zadať
% parameter a ako vstup alebo chce to načítať z konkrétneho riadku
%
% parameter iterator: integer - aktuálny riadok v matici
% parameter DataParametersInputMatrix: matica - daná matica z ktorej načítavame
%
% výstup: parameterA : double
function parameterA = getParameterA(iterator, DataParametersInputMatrix)
    % Premenná 'parameterA' ktorá bude reprezentovať parameter a v rovnici
    parameterA = 0;

    % opýtame sa používateľa, že či chce zadať parameter a on alebo načítať
    % to zo súboru
    disp('Chcete zadať parameter a alebo ho načítať zo súboru?');
    userChoice = input('(Zadajte z možností a, y, ano, yes ak ano - hocičo iné ak ho chcete načítať zo súboru):', 's');
    disp(newline);

    % V prípade, keď používateľ chce zadat parameter ako vstup
    if (strcmpi(userChoice, 'y') || strcmpi(userChoice, 'yes') || strcmpi(userChoice, 'ano') || strcmpi(userChoice, 'a'))
        % Získanie parametra 'a' od používateľa a kontrolovanie parametra 'a'

        % Pomocná premenná 'helpParameterA' vo forme reťazca čo nám umožnuje načítavaný
        % vstup kontrolovať či je to reálne číslo a či to neni neplatný vstup (napríklad písmeno, špeciálny karakter, prázdny reťazec)
        helpParameterA = '';
        
        % Pokiaľ náš parameter 'a' je nulový, alebo náš pomocný reťazec nie je
        % reálne číslo 
        while (parameterA == 0 || ~checkRealNumber(helpParameterA))
            % Opýtame sa na vstup od používateľa
            helpParameterA = input('Zadajte hodnotu parametra a (nenulové reálne číslo): ', 's');
            % V prípade, keď to je reálne číslo
            if (checkRealNumber(helpParameterA))
                % Prekonvertujeme to číslo na double (desatinné číslo)
                parameterA = str2double(helpParameterA);
            else
                % V inom prípade informujeme používateľa o tom, že zadal neplatný
                % vstup
                disp('Zadali ste neplatný vstup!');
            end
        end
        
        % Vypíšeme parameter 'a' aby používateľ bol istý že to bolo uložené správne
        disp(['Váš zvolený parameter a je: ', num2str(parameterA)]);
    else
        % Načítanie parametra a zo vstupnej matice a uloženie do premennej
        % ktorá bude vrátená
        parameterA = DataParametersInputMatrix(iterator, 2);
        % Vypíšeme parameter a
        disp(['Parameter a pre ', num2str(iterator), '. riadok je: ', num2str(parameterA)]);
    end
end

% funkcia getParameterAFromUser, kde používateľ má zadať parameter a ako vstup
%
% výstup: parameterA : double
function parameterA = getParameterAFromUser()
    % Premenná 'parameterA' ktorá bude reprezentovať parameter a v rovnici
    parameterA = 0;

    % Pomocná premenná 'helpParameterA' vo forme reťazca čo nám umožnuje načítavaný
    helpParameterA = '';

    % vstup kontrolovať či je to reálne číslo a či to neni neplatný vstup (napríklad písmeno, špeciálny karakter, prázdny reťazec)

    while (parameterA == 0 || ~checkRealNumber(helpParameterA))
        % Opýtame sa na vstup od používateľa
        helpParameterA = input('Zadajte hodnotu parametra a (nenulové reálne číslo): ', 's');
        % V prípade, keď to je reálne číslo
        if (checkRealNumber(helpParameterA))
            % Prekonvertujeme to číslo na double (desatinné číslo)
            parameterA = str2double(helpParameterA);
        else
            % V inom prípade informujeme používateľa o tom, že zadal neplatný
            % vstup
            disp('Zadali ste neplatný vstup!');
        end
    end

    % Vypíšeme parameter 'a' aby používateľ bol istý že to bolo uložené správne
    disp(['Váš zvolený parameter a je: ', num2str(parameterA)]);
end

% funkcia checkValidityOfInputMatrix na rozhodnutie či naša vstupná matica
% je validná
%
% parameter DataParametersInputMatrix : matica - vstupná matica
%
% výstup: boolean (true alebo false)
function isInputMatrixValid = checkValidityOfInputMatrix(DataParametersInputMatrix)
    % Prednastavenie hodnoty isInputMatrixValid na true
    isInputMatrixValid = true;
    
    % Kontrolujeme, či vstupný súbor nie je prázdny alebo či neobsahuje 13
    % stlpcov
    if size(DataParametersInputMatrix, 2) ~= 13 || isempty(DataParametersInputMatrix)
        % V prípade, keď jeden z tých platí, informujeme používateľa o tom a
        % pokračujeme s programom ďalej
        disp('Vstupný súbor neobsahuje správny počet stĺpcov (13) alebo je prázdny.');
        disp('Pokračujem s ďalšou úlohou...');
        isInputMatrixValid = false;
    end
end