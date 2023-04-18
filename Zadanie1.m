% Príkaz "clc" (skratka pre "clear screen") vymaže konzolu Matlabu a presunie kurzor na začiatok stránky. 
% Je to užitočné, ak chcete mať čistý výstup v konzole.
clc;

% Príkaz "clear" vymaže premenné a funkcie uložené v pamäti Matlabu. 
% Tento príkaz sa používa na uvoľnenie pamäte a odstránenie starých údajov 
clear;

% Príkaz "format long" nastaví výstup do konzoly na viac desatinné čísla
format long;

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
% Načítavanie DataAproximacie.txt do matice 
DataAproximationsInputFile = 'InputFiles/DataAproximacie.txt';
if isfile(DataAproximationsInputFile)
    % Použitím funkcie readmatrix()
    DataAproximationsInputMatrix = readmatrix(DataAproximationsInputFile);

    % Výpis o vstupu
    disp('Váš vstupný súbor so vstupnými parametrami pre metódu najmenších štvorcov polynómom prvého a druhého stupňa funkcie');
    disp(', aj pre aproximáciu s Langrangeovým interpolačným polynómom.');
    disp(DataAproximationsInputMatrix);

    disp('Kde štruktúra jeho riadkov je: hodnoty funkcií sú zadané vždy vo dvoch stĺpcoch (argument xi a funkčná hodnota f(xi)).')
    disp('Tzn. ak napr. súbor obsahuje 6 stĺpcov, tak reprezentuje 3 rôzne funkcie. Každá dvojica stĺpcov reprezentujúca jednu funkciu musí mať rovnaký rozmer');
    disp('Pre úlohy s rovnicou a s aproximáciami budú používané riadky, prektoré je hodnota info rovná 1,' );
    disp(['pre úlohu na výpočet určitého integrálu budú používané, pre ktoré je hodnota info rovná 2', newline]);
else
    disp('Váš vstupný súbor so vstupnými parametrami pre metódu najmenších štvorcov');
    disp('a pre aproximáciu s Langrangeovým interpolačným polynómom neexistuje.');
    disp('Vytvorte si súbor DataAproximacie.txt v priečinku InputFiles a spustite program znovu.');
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
                continue;
            end
        end

        % switch aby na rozhodnutie či máme info 1 alebo 2 v danom riadku
        switch info
            % V prípade ak info je 1, praćujeme s našou rovnicou
            case 1
                disp(['Keďže hodnota info je rovná 1, tak budeme pracovať s rovnicou.', newline]);

                % ----------------------------------------------------------------------------------------------------------------------------
                % úloha (a):
                % Je daná rovnica v tvare a · x^3 + b · x^2 + c · x + d = 0, kde x je neznáma premenná a a, b, c, d sú reálne
                % parametre, kde aspoň dva z parametrov b, c, d sú nenulové a parameter a je vždy nenulový.
                % Na tú úlohu budeme používať DataParametre.txt ako vstupný súbor, ale dáme
                % možnosť aj používateľovi zadať vstupy na jednotlivé parametre
                disp(['úloha (a):', newline]);

                % Získame parametre a, b, c, d s našimi pomocnými funkciami
                disp(['Vstupná matica - ', num2str(iterator), '. riadok: ']);
                
                if ~isnan(DataParametersInputMatrix(iterator, 2)) && (DataParametersInputMatrix(iterator, 2)) ~= 0 && isreal((DataParametersInputMatrix(iterator, 2)))
                    parameterA = getParameterA(iterator, DataParametersInputMatrix);
                else
                    disp(['V stlpci ', num2str(iterator), ' sa nachádza neplatný vstup pre parameter a, pretože je nulový alebo neplatný.']);
                    userChoice = input('Chcete pokračovať s ďalším riadkom? alebo chcete zadať vstup pre parameter a? (y/n), v prípade, že chcete zadať vstup pre parameter a, zadajte y, ak nie, zadajte n: ', 's');

                    if strcmpi(userChoice, 'y')
                        parameterA = getParameterAFromUser();
                    else
                        disp(['Pokračujem s ďalším riadkom.', newline]);
                        continue;
                    end
                end

                % V prípade, že parametre b, c, d nie sú platné
                if (((DataParametersInputMatrix(iterator, 3)) ~= 0 && (DataParametersInputMatrix(iterator, 4)) ~= 0) || ((DataParametersInputMatrix(iterator, 3)) ~= 0 && (DataParametersInputMatrix(iterator, 5)) ~= 0) || ((DataParametersInputMatrix(iterator, 4)) ~= 0 && (DataParametersInputMatrix(iterator, 5)) ~= 0)) && ~isnan(DataParametersInputMatrix(iterator, 3)) && ~isnan(DataParametersInputMatrix(iterator, 4))  && ~isnan(DataParametersInputMatrix(iterator, 5)) && isreal((DataParametersInputMatrix(iterator, 3))) && isreal((DataParametersInputMatrix(iterator, 4))) && isreal((DataParametersInputMatrix(iterator, 5)))
                    [parameterB, parameterC, parameterD] = getParametersBCD(iterator, DataParametersInputMatrix);
                else
                    disp(['V stĺpcoch ', num2str(iterator), ' sa nachádzajú neplatné vstupy pre parametre b, c, d, pretože aspoň dva z nich sú nulové alebo neplatné.']);
                    userChoice = input('Chcete pokračovať s ďalším riadkom? alebo chcete zadať vstupy pre parametre b, c, d? (y/n), v prípade, že chcete zadať vstupy pre parametre b, c, d, zadajte y, ak nie, zadajte n: ', 's');

                    if strcmpi(userChoice, 'y')
                        [parameterB, parameterC, parameterD] = getParametersBCDFromUser();
                    else
                        disp(['Pokračujem s ďalším riadkom.', newline]);
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

                % Opýtame sa od používateľa, či on chce zadat epsilon,
                % alebo či to chce načítať zo súboru, a uložíme epsilon do
                % premennej s menom epsilon

                disp(['Metóda bisekcie:', newline]);

                % V prípade ak epsilon je neplatná hodnota v súbore DataParametre.txt
                % tak sa používateľovi zobrazí hláška, že epsilon je neplatná hodnota
                % a opýtame sa ho, či chce epsilon zadať vy alebo či chce pokračovať ďalej
                epsilon = -1;
                if ~isnan(DataParametersInputMatrix(iterator, 13)) && isreal(DataParametersInputMatrix(iterator, 13)) && DataParametersInputMatrix(iterator, 13) >= 0
                    epsilon = getEpsilon(iterator, DataParametersInputMatrix);
                else
                    disp(['V stlpci Epsilon v súbore Dataparametre.txt na riadku ', num2str(iterator), ' nie je zadaná hodnota epsilon alebo je zadaná zlá hodnota epsilon.']);

                    userChoice = input('Chcete epsilon zadať vy alebo chcete pokračovať s ďalším riadkom? (y/n), ak zadáte y, tak máte možnosť epsilon zadať, ak zadáte n, tak pokračujete ďalej: ', 's');
                    if strcmpi(userChoice, 'y')
                        epsilon = getEpsilonFromUser();
                    else
                        disp(['Pokračujem s ďalším riadkom.', newline]);
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
                disp(['Keďže info je 2, pracujeme s našim integrálom.', newline]);

                % V prípade, že jeden z parametrov a, b, c, k, p, q, r, s, LB, UB, epsilon je NaN (Not a Number), alebo dolná hranica je vacsia ako horná, alebo menovatel je 0, alebo epsilon je záporné tak vypíšeme chybovú hlášku a preskočíme tento riadok
                if isnan(DataParametersInputMatrix(iterator, 2)) || isnan(DataParametersInputMatrix(iterator, 3)) || isnan(DataParametersInputMatrix(iterator, 4)) || isnan(DataParametersInputMatrix(iterator, 6)) || isnan(DataParametersInputMatrix(iterator, 8)) || isnan(DataParametersInputMatrix(iterator, 9)) || isnan(DataParametersInputMatrix(iterator, 10)) || isnan(DataParametersInputMatrix(iterator, 11)) || isnan(DataParametersInputMatrix(iterator, 12)) || isnan(DataParametersInputMatrix(iterator, 13)) || DataParametersInputMatrix(iterator, 13) < 0 || (DataParametersInputMatrix(iterator, 11) > DataParametersInputMatrix(iterator, 12)) || (DataParametersInputMatrix(iterator, 6) == 0 && DataParametersInputMatrix(iterator, 9) == 0)
                    disp(['V súbore DataParametre.txt na riadku ', num2str(iterator), ' nie je zadaná hodnota niektorého z parametrov a, b, c, k, q, r, s, LB, UB, epsilon alebo je zadaná zlá hodnota niektorého z parametrov.']);
                    continue;
                end

                % úloha (f):
                % Vypočítajte určitý integrál
                % I = LB-UB∫ (ax^2 + bx + c) / (kx + q)*(rx + s) dx

                disp(['úloha (f):', newline]);

                % Parametre integrálu

                % premenné parameterA, do ktorej uložíme hodnotu z
                % DataParametersInputMatrix v stĺpci 2
                parameterA = DataParametersInputMatrix(iterator, 2);

                % premenné parameterB, do ktorej uložíme hodnotu z
                % DataParametersInputMatrix v stĺpci 3
                parameterB = DataParametersInputMatrix(iterator, 3);

                % premenné parameterC, do ktorej uložíme hodnotu z
                % DataParametersInputMatrix v stĺpci 4
                parameterC = DataParametersInputMatrix(iterator, 4);
                
                % premenné parameterK, do ktorej uložíme hodnotu z
                % DataParametersInputMatrix v stĺpci 5
                parameterK = DataParametersInputMatrix(iterator, 6);
                
                % premenné parameterQ, do ktorej uložíme hodnotu z
                % DataParametersInputMatrix v stĺpci 5
                parameterQ = DataParametersInputMatrix(iterator, 8);

                % premenné parameterR, do ktorej uložíme hodnotu z
                % DataParametersInputMatrix v stĺpci 5
                parameterR = DataParametersInputMatrix(iterator, 9);

                % premenné parameterS, do ktorej uložíme hodnotu z
                % DataParametersInputMatrix v stĺpci 5
                parameterS = DataParametersInputMatrix(iterator, 10);

                % dolná a horná hranica integrácie

                % premenné lowerBound, do ktorej uložíme hodnotu z
                % DataParametersInputMatrix v stĺpci 5
                lowerBound = DataParametersInputMatrix(iterator, 11);

                % premenné upperBound, do ktorej uložíme hodnotu z
                % DataParametersInputMatrix v stĺpci 5
                upperBound = DataParametersInputMatrix(iterator, 12);

                % presnosť integrácie pre simpsonovu metódu

                % premenné epsilon, do ktorej uložíme hodnotu z
                % DataParametersInputMatrix v stĺpci 5
                epsilon = DataParametersInputMatrix(iterator, 13);
                
                f = @(x) (parameterA * x.^2 + parameterB * x + parameterC) ./ ((parameterK * x + parameterQ) .* (parameterR * x + parameterS));

                % Vypíšeme informácie o integráli používateľovi
                displayIntegral(parameterA, parameterB, parameterC, parameterK, parameterQ, parameterR, parameterS, lowerBound, upperBound, epsilon);

                % vypočítame hodnotu určitého integrálu pomocou simpsonovej metódy
                % a uložíme ju do premennej integralValue, takisto uložíme
                % všetky kroky a výsledky do súboru
                integralValue = performSimpsonMethodAndSaveEveryStepAndResultIntoFile(f, lowerBound, upperBound, epsilon, iterator, parameterA, parameterB, parameterC, parameterK, parameterQ, parameterR, parameterS);
        end
    end
else
    disp('Súbor DataParametre.txt nie je platný, neobsahuje 13 stlpcov alebo nebol nájdený. Skontrolujte, či je súbor v adresári InputFiles a že či obsahuje práve 13 stlpcov.');
end



% Pomocná funkcia na kontrolu, či je zadaný vstup reálne číslo
%
% parameter input_str : string (reťazec) - daný string o čom sa rozhodne
% funkcia či to je reálne číslo alebo nie
%
% výstup: isRealNumber : boolean (true alebo false)
function isRealNumber = checkRealNumber(input_str)
    isRealNumber = ~isempty(str2double(input_str)) && isreal(str2double(input_str)) && ~isnan(str2double(input_str));
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

% Pomocná funkcia na kontrolu, či DataAproximacie.txt je platný
%
% parameter DataAproximationsInputMatrix : matica - vstupná matica
%
% výstup: boolean (true alebo false)
function isDataAproximationsInputMatrixValid = checkValidityOfDataAproximationsInputMatrix(DataAproximationsInputMatrix)
    % Overíme, či má vstupná matica párny počet stĺpcov
    numberOfColumns = size(DataAproximationsInputMatrix, 2);

    % Ak má vstupná matica nepárny počet stĺpcov, vypíšeme chybovú hlášku a
    if mod(numberOfColumns, 2) ~= 0
        % nastavíme premennú isDataAproximationsInputMatrixValid na false
        isDataAproximationsInputMatrixValid = false;
        % a vypíšeme chybovú hlášku
        disp('Chyba: Vstupná matica DataAproximationsInputMatrix musí mať párny počet stĺpcov.');
        % a vrátime sa z funkcie
        return;
    end

    % Ak má vstupná matica párny počet stĺpcov, tak nastavíme premennú na true
    isDataAproximationsInputMatrixValid = true;
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
    userChoice = input('Chcete zadať vstup pre parameter a vy alebo načítať to zo vstupného súboru? (Zadajte z možností a, y, ano, yes ak ano - hocičo iné ak nechcete):', 's');
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
    userChoice = input('Chcete zadať vstup pre parametre b, c, d vy? (Zadajte z možností a, y, ano, yes ak ano - hocičo iné ak nechcete):', 's');
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
        infOfSeparationHelp = input("Zadajte dolnú hranicu priblíženia: ", "s");
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
        supOfSeparationHelp = input("Zadajte hornú hranicu priblíženia: ", "s");
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
        separateInput = input("Chcete separovať rovnicu na g(x) a h(x), kde h(x) bude záporná? Zadajte 'y' alebo 'Y' alebo 'yes' alebo 'YES' alebo 'ano' alebo 'ANO' keď ano a 'n' alebo 'N' alebo 'no' alebo 'NO' alebo 'nie' alebo 'NIE' keď nechcete: ", 's');

        % V prípade keď používateľ chce separovať
        if (strcmpi(separateInput, 'y') || strcmpi(separateInput, 'yes') || strcmpi(separateInput, 'ano'))
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
    % spočítame počet reálnych koreňov, len tých, ktorí nie sú imaginárne
    % čísla pomocou funkcie imag(), čo nám vráti 0 (nulu) v prípade keď to
    % nie je imaginárne (komplexné) číslo 
    rootsCount = sum(imag(rootsVector) == 0);
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

% Funkcia getIntervalsAndSaveThemIntoFile vráti intervaly jednotlivých koreňov
% vo forme matice, kde prvý stlpec bude číslo koreňa,
% druhý stlpec bude reprezentovať dolnú hranicu
% a tretí stlpec bude reprezentovať hornú hranicu
%
% Funkcia po vykonaní zápisu do matíc a jeho zobrazení aj uloží príslušné
% informácie o separácii do súboru Rovnica.txt v adresári OutputFiles,
% ak to neexistuje, tak ho vytvorí
%
% vstup: anonymná funkcia f, počet reálnych koreňov
%
% výstup: intervals - matica kde sa nachádza že kolkáty koreň, jeho dolný a
% horný interval (v jednom riadku)
function intervals = getIntervalsAndSaveThemIntoFile(f, rootsCount, a, b, c, d)
    % vytvoríme prázdnu maticu s počtom riadkov počet reálnych koreňov a s
    % 3 stlpcami pre koreň, dolná hranica, horná hranica
    intervals = zeros(rootsCount, 3);

    % pomocná premenná pre dolné ohraničenie vo forme string, aby nám to
    % pomohlo ušetriť neplatný vstup
    infHelp = '';
    % pomocná premenná pre horné ohraničenie vo forme string, aby nám to
    % pomohlo ušetriť neplatný vstup
    supHelp = '';

    % prechádzame cez počtu koreňov
    for i = 1 : rootsCount
        % informujeme používateľa o tom, že pre ktorú koreň má zadať
        % interval
        fprintf("Zadajte interval pre %d. koreň: \n", i);

        % premenné pre dolné ohraničenie vo forme čísla, do ktorých budeme
        % uložiť ich v prekonvertovanej forme zo vstupného reťazca od
        % používateľa
        inf = 0;
        sup = 0;

        % pokiaľ doľné ohraničenie alebo horné ohraničenie sú nulové, alebo
        % pomocné premenné pre dolné a horné ohraničenie nie sú reálne
        % čísla alebo súčin f(inf) * f(sup) je vačšia alebo rovná sa nule
        while (~checkRealNumber(infHelp) || ~checkRealNumber(supHelp) || f(inf) * f(sup) >= 0)
            % pýtame sa na dolnú hranicu od používateľa a uložíme to do
            % premennej infHelp
            infHelp = input("Zadajte dolnú hranicu intervalu: ", "s");
            % pýtame sa na hornú hranicu od používateľa a uložíme to do
            % premennej supHelp
            supHelp = input("Zadajte hornú hranicu intervalu: ", "s");
            
            if (~checkRealNumber(infHelp) || ~checkRealNumber(supHelp))
                disp("Zadali ste neplatný vstup! Skúste znova!");
            end

            % Prekonvertujeme infHelp z reťazca na double a uložíme ho do
            % premennej inf
            inf = str2double(infHelp);
            % Prekonvertujeme supHelp z reťazca na double a uložíme ho do
            % premennej sup
            sup = str2double(supHelp);

            % Ak je dolná hranica väčšia ako horná hranica, vymeníme ich hodnoty
            if (inf > sup)
                % pomocné premenné temp do ktorej uložíme hodnotu horného
                % ohraničenia
                temp = sup;
                % do premennej horného ohraničenia uložíme doľné
                % ohraničenie
                sup = inf;
                % do premennej doľného ohraničenia uložíme hodnotu pomocnej
                % premennej temp ktorá obsahuje predošlú hodnotu hornej
                % hranici
                inf = temp;
                % Vypíšeme hlásenie, že sme vymenili hranice
                disp('Keďže ste zadali väčšiu doľnú hranicu ako hornú, vymenili sme ich!');
            end

            % ak súčin funkčnej hodnoty dolnej hranici a hornej hranicy je
            % kladné číslo, to znamená že v intervale nie je práve jeden
            % koreň, informujeme o tom používateľa
            if f(inf) * f(sup) >= 0
                disp("Interval neobsahuje práve jeden koreň. Skúste znova.");
                disp(['f(inf) * f(sup) < 0 neplatí, vyšlo to na ', num2str(f(inf) * f(sup))]);
                disp('Musíte interval zadať tak, aby po vynásobení ich funkčných hodnôt vrátilo záporné číslo!');
            end
        end

        % Ak naše intervaly sú validné, obsahujú práve jeden koreň, uložíme
        % ich do nového riadku matici intervals vo forme: koreň, dolná
        % hranica, horná hranica
        intervals(i,:) =  [i, inf, sup];

        % Informujeme používateľa o tom, že sme uložili hranice do matici
        disp(['Správne hranice, uložili sme ich do matice s menom "intervals"', newline]);
    end

    % výpis intervalov používateľovi
    disp(['Intervaly s koreňmi:', newline]);
    % vypis vo forme Interval 1. reálneho koreňu: [dolna hranica, horna hranica]'
    % prechadzame cez pocet korenov a vypiseme prislusne intervaly
    for i = 1 : rootsCount
        disp(['Interval ', num2str(intervals(i, 1)), '. koreňu: ', '[', num2str(intervals(i, 2)), ', ', num2str(intervals(i, 3)), ']']);
    end

    % Otvoríme, prípadne vytvoríme súbor Rovnica.txt v adresári OutputFiles
    % (v režimu append, zaručuje aby sa to vytvorilo v prípade ak to neexistuje)
    EquationTxt = fopen('OutputFiles/Rovnica.txt', 'a');

    % Zapíšeme relevantné informácie do súboru Rovnica.txt
    fprintf(EquationTxt, "<------------------------------------------>\n\n");
    fprintf(EquationTxt, "\nRovnica: %g * x^3 + %g * x^2 + %g * x + %g = 0\n", a, b, c, d);
    

    fprintf(EquationTxt, "\n\n");
    fprintf(EquationTxt, "----------------------------------------------------\n");
    fprintf(EquationTxt, "             Separácia reálnych koreňov             \n");
    fprintf(EquationTxt, "----------------------------------------------------\n");
    fprintf(EquationTxt, "\n");

    fprintf(EquationTxt, "Počet reálnych koreňov: %d\n", rootsCount);
    fprintf(EquationTxt, "Intervaly (ľavá hodnota reprezentuje doľnú hranicu intervalu, pravá hodnota reprezetnuje hornú hranicu intervalu):\n");
    
    % Zapíšeme každý koreň a jeho intervaly do súboru Rovnica.txt
    for i = 1:size(intervals, 1)
        fprintf(EquationTxt, "%d. koreň: [%f, %f]\n", intervals(i,1), intervals(i,2), intervals(i,3));
    end

    disp(['Informácie o separácii koreňov boli úspešne zapísané do súboru Rovnica.txt (OutputFiles/Rovnica.txt)', newline]);
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
    userChoice = input('Chcete zadať vstup pre epsilon vy? (Zadajte z možností a, y, ano, yes ak ano - hocičo iné ak nechcete):', 's');
    disp(newline);

    % V prípade, keď používateľ chce zadat epsilon
    if (strcmpi(userChoice, 'y') || strcmpi(userChoice, 'yes') || strcmpi(userChoice, 'ano') || strcmpi(userChoice, 'a'))

        % pomocná premenná pre epsilon ako retazec, vstup od pouzivatela
        epsilonHelp = '';
        % premenná pre epsilon, ktorú budeme vrátiť
        epsilon = -1;

        % pokial epsilon je zaporny alebo epsilonHelp nie je realne cislo
        while (~checkRealNumber(epsilonHelp) || epsilon < 0)
            % Opytame sa na epsilon od používateľa
            epsilonHelp = input('Zadajte epsilon (presnosť, kladné číslo): ', 's');
            
            % Ak pomocná premenná je reálne číslo
            if (checkRealNumber(epsilonHelp))
                % prekonvertujeme pomocnú premennú na double a uložíme ho
                % do premennej epsilon
                epsilon = str2double(epsilonHelp);
                % Ak epsilon je záporný, informujeme používateľa o tom, že
                % zadal neplatný vstup
                if (epsilon < 0)
                    disp('Zadali ste záporne epsilon! Skúste znova!');
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

function epsilon = getEpsilonFromUser()
    % pomocná premenná pre epsilon ako retazec, vstup od pouzivatela
    epsilonHelp = '';
    % premenná pre epsilon, ktorú budeme vrátiť
    epsilon = -1;

    % pokial epsilon je zaporny alebo epsilonHelp nie je realne cislo
    while (~checkRealNumber(epsilonHelp) || epsilon < 0)
        % Opytame sa na epsilon od používateľa
        epsilonHelp = input('Zadajte epsilon (presnosť, kladné číslo): ', 's');
        
        % Ak pomocná premenná je reálne číslo
        if (checkRealNumber(epsilonHelp))
            % prekonvertujeme pomocnú premennú na double a uložíme ho
            % do premennej epsilon
            epsilon = str2double(epsilonHelp);
            % Ak epsilon je záporný, informujeme používateľa o tom, že
            % zadal neplatný vstup
            if (epsilon < 0)
                disp('Zadali ste záporne epsilon! Skúste znova!');
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

    % zaznamenáme čas pred výpočtom bisekcie pre všetké koreňe
    tic;

    % pre kazdy interval v matici intervals robime bisekciu
    for root = 1 : size(intervals, 1)
        % premenná iterator, slúži to ako krok, po vykonaní počet krokov
        iterator = 1;

        % premenná middle, kďe budeme ukladať stred a po vykonaní bisekcie to
        % bude náš nájdený koreň funkcie pomocou bisekcie
        middle = 0;

        % dolná hranica bude z daného riadku kde sa nachádzame druhý stlpec
        lowerBisectionBound = intervals(root, 2);
        % horná hranica bude z daného riadku kde sa nachádzame tretí stlpec
        upperBisectionBound = intervals(root, 3);

        % Zapíšeme interval, ktorý bol použitý v bisekcii
        fprintf(EquationTxt, "\n%d. Interval: [%g, %g]\n", root, lowerBisectionBound, upperBisectionBound);

        % Vykonáme bisekciu, kým sa nedosiahne naša presnosť, teda epsilon,
        % zistíme to tak že z horného ohraničenia odčítame doľné ohraničenie a
        % musí to byť menšie ako epsilon
        while (abs(upperBisectionBound - lowerBisectionBound) >= (2 * epsilon))
            % vypočítame stred so spočítaním doľnej a hornej hranici a videlíme
            % to s 2 a uložíme to do premennej middle
            middle = (lowerBisectionBound + upperBisectionBound) / 2;
    
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
    
            % zvýšime počet krokov o 1 (jeden)
            iterator = iterator + 1;
        end
    
        % Informujeme používateľa o tom, že sme našli koreň
        disp([newline, 'Našiel som koreň, f(stred) * f(doľná hranica) = 0, ', 'na ', num2str(iterator - 1), '. iteráciu']);
        % Vypíšeme koreň používateľovi
        disp(['Nájdený koreň je: ', num2str(middle), newline]);

        % Pridáme koreň do vektoru koreňov
        bisectionRootsVector = [bisectionRootsVector, middle];
    
        % Vypíšeme výsledok bisekcie používateľovi
        % vo forme riadkov počet krokov, doľná hranica, horná hranica, koreň,
        % veľkosť intervalu
        disp(['Výsledok bisekcie:', newline]);
        disp(['Koreň: ', num2str(middle)]);
        disp(['Funkčná hodnota pre koreň: ', num2str(f(middle))]);
        disp(['Počet krokov: ', num2str(iterator - 1)]);
        disp(['Doľná hranica: ', num2str(lowerBisectionBound)]);
        disp(['Horná hranica: ', num2str(upperBisectionBound)]);
        disp(['Veľkosť intervalu: ', num2str(abs(upperBisectionBound - lowerBisectionBound)), newline]);

        % odhad chyby (|b - a| / 2^(k + 1))
        % intervals(root, 3) je horné ohraničenie v matici intervals daného
        % intervalu, intervals(root, 2) je dolné ohraničenie v matici intervals daného
        % intervalu
        errorEstimate = abs(intervals(root, 3) - intervals(root, 2)) / (2.^(iterator));

        errorEstimateMatrix = [errorEstimateMatrix, errorEstimate];

        % reťazec na reprezetnáciu odhadnutej chyby s nastavením
        % desatinných miest
        errorEstimateStr = sprintf('%.9f', errorEstimate);
        
        % vypíšeme odhadnutú chybu
        disp(['Odhadnutá chyba použitím vzor+ca: |b - a| / 2^(k + 1) = ', errorEstimateStr, newline]);

        % Zapíšeme príslušné informácie o vykonanej bisekcií pre konkrétny
        % koreň

        % konkrétny koreň ktorú sme našli
        fprintf(EquationTxt, "\nKoreň: %g\n", middle);
        % funkčná hodnota pre koreň
        fprintf(EquationTxt, "Funkčná hodnota pre koreň: %g\n", f(middle));
        % presnosť
        fprintf(EquationTxt, "Epsilon (presnosť): %g\n", epsilon);
        % počet krokov bisekcii
        fprintf(EquationTxt, "Počet krokov: %d\n", iterator - 1);
        % Interval, v ktorom bol nájdený koreň
        fprintf(EquationTxt, "Interval, v ktorom bol najdený koreň: [%g, %g]\n", lowerBisectionBound, upperBisectionBound);
        % Velkosť intervalu
        fprintf(EquationTxt, "Velkosť intervalu: %g\n", abs(upperBisectionBound - lowerBisectionBound));
        % Odhad chyby
        fprintf(EquationTxt, "Odhadnutá chyba použitím vzorca: |b - a| / 2^(k + 1) = %.9f\n", errorEstimate);
    end

    % zaznamenáme čas po výpočte bisekcie, uložíme ho to premennej
    % timeOfBisection
    timeOfBisection = toc;

    % Vypíšeme čas bisekcie používateľovi a zapíšeme to aj do súboru
    disp([newline, 'Čas bisekcie: ', num2str(timeOfBisection), 'sekúnd.', newline]);
    fprintf(EquationTxt, '\nČas bisekcie: %f sekúnd\n\n', timeOfBisection);

    % Zatvoríme súbor Rovnica.txt
    fclose(EquationTxt);

    % zobrazíme aj výstupnu maticu používateľovi, aby bol istý, že sme to
    % uložili správne
    disp(['Uložená matica bisectionOutputMatrix vyzerá nasledovne: ', newline]);
    disp(bisectionOutputMatrix);

    % zobrazíme aj ostatné výstupné matice používateľovi, aby bol istý, že sme to
    % uložili správne
    disp(['Uložená matica errorEstimateMatrix vyzerá nasledovne: ', newline]);
    disp(errorEstimateMatrix);
end

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
    tic;

    % Prechádzame všetkými intervalmi
    for i = 1 : size(intervals, 1)
        % doľné ohraničenie z našej matici intervals v danom riadku
        a_interval = intervals(i, 2);
        % horné ohraničenie z našej matici intervals v danom riadku
        b_interval = intervals(i, 3);

        % Fourierove podmienky

        % Prvá Furierova podmienka
        test1 = f(a_interval) * f(b_interval);

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

        % Tretia podmienka pre a_interval
        test2 = f(a_interval) * u1;
        % Tretia podmienka pre b_interval
        test3 = f(b_interval) * v1;

        fprintf(EquationTxt, "\n%d. Interval: [%g, %g]\n", i, a_interval, b_interval);

        % Kontrola Fourierových podmienok (Ak sú splnené Furierove podmienky, vyberieme vhodné x0 na základe týchto podmienok)

        % V prípade ak prvá podmienka vráti záporné číslo, druhá podmienka
        % vráti väčšie číslo ako nula, a znamienko sa nezmenilo na
        % intervalu s druhou deriváciou (druhé derivácie s max a min majú rovnaké znamienko)
        if test1 < 0 && test2 > 0 && sign(f2(min_val)) == sign(f2(max_val))
            % tak naša x0 bude doľné ohraničenie
            x0 = a_interval;
        elseif test1 < 0 && test3 > 0 && sign(f2(min_val)) == sign(f2(max_val))
            % v prípade ak prvá podmienka vráti záporné číslo a tretia
            % kladné číslo, a takisto sa nezmenilo znamienko na intervale s
            % druhou deriváciou tak naša x0 buďe horné ohraničenie
            x0 = b_interval;
        else
            % v prípade, ak neplatí Furierova podmienka tak informujeme
            % používateľa o tom
            fprintf(EquationTxt, "\nInterval nesplňal Furierove podmienky, pokračoval som s ďalším koreňom, ak existovala \n");
            disp(['Interval <%g, %g> nespĺňa Fourierove podmienky, pokračujem s ďaľším koreňom', a_interval, b_interval, newline]);
            errorEstimateMatrix = [errorEstimateMatrix, NaN];
            newtonRootsVector = [newtonRootsVector, NaN];
            % a pokračujeme s ďaľšími intervalmi
            continue;
        end

        % Newtonova metóda

        % Inicializácia počítadla iterácií
        k = 0;
        % Inicializácia podmienky zastavenia
        Stop = f(x0-epsilon)*f(x0+epsilon);
        % Spustenie Newtonovej metódy (beží to pokiaľ podmienka vráti väčšie číslo ako 0)
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
        end

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

        % Dff1m je druhá derivácia opačnej funkcie
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

        % reťazec na reprezetnáciu odhadnutej chyby s nastavením
        % desatinných miest
        errorEstimateStr = sprintf('%.9f', errorEstimate);

        % reťazec na reprezetnáciu odhadnutej chyby s nastavením
        % desatinných miest
        stopStr = sprintf('%.9f', Stop);

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

        % konkrétny koreň ktorý sme našli
        fprintf(EquationTxt, "\nKoreň: %g\n", x0);
        % funkčná hodnota pre koreň
        fprintf(EquationTxt, "Funkčná hodnota pre koreň: %g\n", f(x0));
        % epsilon
        fprintf(EquationTxt, "epsilon: %g\n", epsilon);
        % počet krokov
        fprintf(EquationTxt, 'Počet krokov: %d\n', k);
        % interval
        fprintf(EquationTxt, 'Interval, v ktorom bol nájdený koreň: [%g, %g]\n', a_interval, b_interval);
        % veľkosť intervalu
        fprintf(EquationTxt, "Velkosť intervalu: %g\n", abs(b_interval - a_interval));
        % hodnota zastavenia
        fprintf(EquationTxt, 'Hodnota zastavenia: %s\n', stopStr);
        % Zapíšeme odhad chyby Newtonovej metódy do súboru
        fprintf(EquationTxt, 'Odhad absolútnej chyby pre Newtonovu metódu je ER = %s.\n', errorEstimateStr);
    end

    % zaznamenáme čas po newtonovej metóde a uložíme to do premennej timeOfNewtonMethod
    timeOfNewtonMethod = toc;

    % Vypíšeme čas newtonovej metódy používateľovi a zapíšeme to aj do súboru
    disp([newline, 'Čas newtonovej metódy: ', num2str(timeOfNewtonMethod), 'sekúnd.', newline]);
    fprintf(EquationTxt, '\nČas newtonovej metódy: %f sekúnd\n', timeOfNewtonMethod);

    fprintf(EquationTxt, "<------------------------------------------>\n\n");
    
    % Zavrieme súbor Rovnica.txt
    fclose(EquationTxt);

    % zobrazíme aj výstupnu maticu používateľovi, aby bol istý, že sme to
    % uložili správne
    disp(['Uložená matica newtonOutputMatrix vyzerá nasledovne: ', newline]);
    disp(newtonOutputMatrix);

    % zobrazíme aj výstupnu maticu errorEstimateNewtonMethodMatrix používateľovi, aby bol istý, že sme to
    % uložili správne
    disp(['Uložená matica errorEstimateMatrix vyzerá nasledovne: ', newline]);
    disp(errorEstimateMatrix);
end

% Funkcia na porovnanie výsledkov bisekčnej a newtonovej metódy
% a uloženie ich do súboru
% Vstupné parametre: bisectionOutputMatrix, timeOfBisection, errorEstimateBisectionMatrix, bisectionRootsVector, newtonOutputMatrix, timeOfNewtonMethod, errorEstimateNewtonMethodMatrix, newtonRootsVector, iterator, a, b, c, d
% Výstup: void (žiadny)
function compareBisectionAndNewtonMethodsAndSaveResultsIntoFile(bisectionOutputMatrix, timeOfBisection, errorEstimateBisectionMatrix, bisectionRootsVector, newtonOutputMatrix, timeOfNewtonMethod, errorEstimateNewtonMethodMatrix, newtonRootsVector, iterator, a, b, c, d)
    % Otvoríme, prípadne vytvoríme súbor Porovnania.txt v adresári OutputFiles
    % (v režimu append, zaručuje aby sa to vytvorilo v prípade ak to neexistuje)
    ComparationTxt = fopen('OutputFiles/Porovnania.txt', 'a');

    % Zapíšeme relevantné informácie do súboru Rovnica.txt
    fprintf(ComparationTxt, "\n");
    fprintf(ComparationTxt, "########################################################\n");
    fprintf(ComparationTxt, "###    Vstupný súbor Dataparametre.txt %d. riadok    ###\n", iterator);
    fprintf(ComparationTxt, "########################################################\n");
    fprintf(ComparationTxt, "\n");
    % Zapíšeme našu rovnicu do súboru
    fprintf(ComparationTxt, "Rovnica: %g * x^3 + %g * x^2 + %g * x + %g\n\n", a, b, c, d);

    bisectionStepsCount = size(bisectionOutputMatrix, 1);
    newtonMethodStepsCount = size(newtonOutputMatrix, 1);
    
    % Zapíšeme relevantné informácie do súboru Porovnania.txt
    fprintf(ComparationTxt, "-------------------------------------------------\n");
    fprintf(ComparationTxt, "---  Porovnanie bisekcií a newtonovej metódy  ---\n");
    fprintf(ComparationTxt, "-------------------------------------------------\n\n\n");

    % Porovnanie krokov bisekcií a newtonovej metódy
    fprintf(ComparationTxt, "-------------------------------------------------\n");
    fprintf(ComparationTxt, " Porovnanie krokov bisekcií a newtonovej metódy\n");
    fprintf(ComparationTxt, "-------------------------------------------------\n");

    % Zapíšeme do súboru Porovnania.txt počet krokov bisekcií a newtonovej metódy
    fprintf(ComparationTxt, "Počet krokov bisekcií: %d\n", bisectionStepsCount);
    fprintf(ComparationTxt, "Počet krokov newtonovej metódy: %d\n", newtonMethodStepsCount);

    if bisectionStepsCount < newtonMethodStepsCount
        fprintf(ComparationTxt, "Bisekcia potrebovala menej krokov ako newtonova metóda o %d krokov.\n", newtonMethodStepsCount - bisectionStepsCount);
    elseif bisectionStepsCount > newtonMethodStepsCount
        if newtonMethodStepsCount == 0
            fprintf(ComparationTxt, "Newtonova metóda neiterovala, pretože sa nespĺňali Furierove podmienky, takže bisekcia vyhrala.\n");
        else
            fprintf(ComparationTxt, "Newtonova metóda potrebovala menej krokov ako bisekcia o %d krokov.\n", bisectionStepsCount - newtonMethodStepsCount);
        end
    else
        fprintf(ComparationTxt, "Bisekcie a newtonova metóda boli vykonané rovnako rýchlo.\n");
    end

    % Porovnanie času bisekcií a newtonovej metódy
    fprintf(ComparationTxt, "\n\n-------------------------------------------------\n");
    fprintf(ComparationTxt, " Porovnanie času bisekcií a newtonovej metódy\n");
    fprintf(ComparationTxt, "-------------------------------------------------\n");

    % Zapíšeme do súboru Porovnania.txt čas bisekcií a newtonovej metódy
    fprintf(ComparationTxt, "Čas bisekcií: %f sekúnd\n", timeOfBisection);

    if newtonMethodStepsCount == 0
        fprintf(ComparationTxt, "Newtonova metóda neiterovala, pretože sa nespĺňali Furierove podmienky.\n");
    else
        fprintf(ComparationTxt, "Čas newtonovej metódy: %f sekúnd\n", timeOfNewtonMethod);
    end

    % Porovnáme časy bisekcií a newtonovej metódy a vypíšeme do súboru Porovnania.txt
    if timeOfBisection < timeOfNewtonMethod
        fprintf(ComparationTxt, "Bisekcia potrebovala menej času ako newtonova metóda o %f sekúnd.\n", timeOfNewtonMethod - timeOfBisection);
    elseif timeOfBisection > timeOfNewtonMethod
        if newtonMethodStepsCount == 0
            fprintf(ComparationTxt, "Bisekcia vyhrala, pretože newtonova metóda neiterovala.\n");
        else
            fprintf(ComparationTxt, "Newtonova metóda potrebovala menej času ako bisekcia o %f sekúnd.\n", timeOfBisection - timeOfNewtonMethod);
        end
    else
        fprintf(ComparationTxt, "Bisekcie a newtonova metóda boli vykonané rovnako rýchlo.\n");
    end

    % Porovnanie chybových odhadov bisekcií a newtonovej metódy
    fprintf(ComparationTxt, "\n\n-----------------------------------------------------------\n");
    fprintf(ComparationTxt, " Porovnanie chybových odhadov bisekcií a newtonovej metódy\n");
    fprintf(ComparationTxt, "-----------------------------------------------------------\n");
    
    % Zapíšeme do súboru Porovnania.txt chybové odhady bisekcií a newtonovej metódy
    for i = 1 : size(errorEstimateBisectionMatrix, 2)
        fprintf(ComparationTxt, "Chybový odhad bisekcií pre %d. koreň: %f\n", i, errorEstimateBisectionMatrix(i));
    end

    if newtonMethodStepsCount == 0
        fprintf(ComparationTxt, "Newtonova metóda neiterovala, pretože sa nespĺňali Furierove podmienky pre žiadny z koreňov.\n");
    else
        for i = 1 : size(errorEstimateNewtonMethodMatrix, 2)
            if isnan(errorEstimateNewtonMethodMatrix(i))
                fprintf(ComparationTxt, "Newtonova metóda nespĺňala Furierove podmienky pre %d. koreň.\n", i);
            else
                fprintf(ComparationTxt, "Chybový odhad newtonovej metódy pre %d. koreň: %f\n", i, errorEstimateNewtonMethodMatrix(i));
            end
        end
    end

    fprintf(ComparationTxt, "\n\n");

    % Porovnáme chybové odhady bisekcií a newtonovej metódy a vypíšeme do súboru Porovnania.txt
    for i = 1 : size(errorEstimateBisectionMatrix, 2)
        % ak odhad pre newtonovu metódu je NaN tak ho nebudeme porovnávať
        if isnan(errorEstimateNewtonMethodMatrix(i))
            fprintf(ComparationTxt, "V prípade %d. koreňa newtonova metóda nespĺňala Furierove podmienky, takže jednoznačne Bisekcia vyhrala.\n\n", i);
            continue;
        end

        if errorEstimateBisectionMatrix(i) < errorEstimateNewtonMethodMatrix(i)
            fprintf(ComparationTxt, "Chybový odhad bisekcií pre %d. koreň je menší ako chybový odhad newtonovej metódy o %f.\n\n", i, errorEstimateNewtonMethodMatrix(i) - errorEstimateBisectionMatrix(i));
        elseif errorEstimateBisectionMatrix(i) > errorEstimateNewtonMethodMatrix(i)
            fprintf(ComparationTxt, "Chybový odhad newtonovej metódy pre %d. koreň je menší ako chybový odhad bisekcií o %f.\n\n", i, errorEstimateBisectionMatrix(i) - errorEstimateNewtonMethodMatrix(i));
        else
            fprintf(ComparationTxt, "Chybové odhady bisekcií a newtonovej metódy pre %d. koreň sú rovnaké.\n\n", i);
        end
    end

    % Porovnanie odhadnutých koreňov bisekcií a newtonovej metódy
    fprintf(ComparationTxt, "\n\n-----------------------------------------------------------\n");
    fprintf(ComparationTxt, " Porovnanie odhadnutých koreňov bisekcií a newtonovej metódy\n");
    fprintf(ComparationTxt, "-----------------------------------------------------------\n");

    % Zapíšeme do súboru Porovnania.txt odhadnuté korene bisekcií a newtonovej metódy
    for i = 1 : size(bisectionRootsVector, 2)
        fprintf(ComparationTxt, "Odhadnutý koreň bisekcií pre %d. koreň: %f\n", i, bisectionRootsVector(i));
    end

    for i = 1 : size(newtonRootsVector, 2)
        if isnan(newtonRootsVector(i))
            fprintf(ComparationTxt, "Newtonova metóda nespĺňala Furierove podmienky pre %d. koreň.\n", i);
        else
            fprintf(ComparationTxt, "Odhadnutý koreň newtonovej metódy pre %d. koreň: %f\n", i, newtonRootsVector(i));
        end
    end

    fprintf(ComparationTxt, "\n\n");

    
    % Porovnáme odhadnuté korene bisekcií a newtonovej metódy a vypíšeme do súboru Porovnania.txt
    for i = 1 : size(bisectionRootsVector, 2)
        if isnan(newtonRootsVector(i))
            fprintf(ComparationTxt, "V prípade %d. koreňa newtonova metóda nespĺňala Furierove podmienky, takže jednoznačne Bisekcia vyhrala.\n\n", i);
            continue;
        end

        if bisectionRootsVector(i) < newtonRootsVector(i)
            fprintf(ComparationTxt, "Odhadnutý koreň bisekcií pre %d. koreň je menší ako odhadnutý koreň newtonovej metódy o %f.\n\n", i, abs(newtonRootsVector(i) - bisectionRootsVector(i)));
        elseif bisectionRootsVector(i) > newtonRootsVector(i)
            fprintf(ComparationTxt, "Odhadnutý koreň newtonovej metódy pre %d. koreň je menší ako odhadnutý koreň bisekcií o %f.\n\n", i, abs(bisectionRootsVector(i) - newtonRootsVector(i)));
        else
            fprintf(ComparationTxt, "Odhadnuté korene bisekcií a newtonovej metódy pre %d. koreň sú rovnaké.\n\n", i);
        end
    end

    % zavrieme súbor Porovnania.txt
    fclose(ComparationTxt);

    % vypíšeme do konzoly, že súbor Porovnania.txt bol úspešne zapísaný
    disp(['Porovnania bisekcií a newtonovej metódy boli úspešne zapísané do súboru Porovnania.txt v adresári OutputFiles', newline]);
end

% Funkcia displayIntegral, ktorá vypíše do konzoly, že aké parametre dostal náš integrál a vo forme I = LB-UB∫ (ax^2 + bx + c) / (kx + q)*(rx + s) dx
% 
% parametre: parameterA, parameterB, parameterC, parameterK, parameterQ, parameterR, parameterS, lowerBound, upperBound, epsilon
%
% vystup: void (žiadny)
function displayIntegral(parameterA, parameterB, parameterC, parameterK, parameterQ, parameterR, parameterS, lowerBound, upperBound, epsilon)
    disp(['Parameter a zo vstupného súboru je: ', num2str(parameterA)]);
    disp(['Parameter b zo vstupného súboru je: ', num2str(parameterB)]);
    disp(['Parameter c zo vstupného súboru je: ', num2str(parameterC)]);
    disp(['Parameter k zo vstupného súboru je: ', num2str(parameterK)]);
    disp(['Parameter q zo vstupného súboru je: ', num2str(parameterQ)]);
    disp(['Parameter r zo vstupného súboru je: ', num2str(parameterR)]);
    disp(['Parameter s zo vstupného súboru je: ', num2str(parameterS)]);
    disp(['Parameter LB (doľná hranica) zo vstupného súboru je: ', num2str(lowerBound)]);
    disp(['Parameter UB (horná hranica) zo vstupného súboru je: ', num2str(upperBound)]);
    disp(['Parameter epsilon zo vstupného súboru je: ', num2str(epsilon), newline]);

    disp(['Integrál, ktorý budeme počítať je I = ', num2str(lowerBound), '-', num2str(upperBound), '∫ (', num2str(parameterA), 'x^2 + ', num2str(parameterB), 'x + ', num2str(parameterC), ') / (', num2str(parameterK), 'x + ', num2str(parameterQ), ')*(', num2str(parameterR), 'x + ', num2str(parameterS), ') dx', newline]);
    disp(['Budeme to počítať pomocou Simpsonovej metódy.',newline]);
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

function integralValue = performSimpsonMethodAndSaveEveryStepAndResultIntoFile(f, lowerBound, upperBound, epsilon, iterator, parameterA, parameterB, parameterC, parameterK, parameterQ, parameterR, parameterS)
    % vytvoríme/otvoríme súbor Integral.txt, do ktorého budeme zapisovať výsledky
    integralTxt = fopen('OutputFiles/Integral.txt', 'a');

    % inicializujeme premennú integralValue, ktorá bude obsahovať výslednú hodnotu integrálu
    integralValue = 0;

    % Zapíšeme relevantné informácie do súboru Rovnica.txt
    fprintf(integralTxt, "\n");
    fprintf(integralTxt, "##########################################################\n");
    fprintf(integralTxt, "###     Vstupný súbor DataParametre.txt %d. riadok      ###\n", iterator);
    fprintf(integralTxt, "##########################################################\n");
    fprintf(integralTxt, "\n");

    fprintf(integralTxt, "------------------------------------------------------------\n");
    fprintf(integralTxt, "        Výpočet integrálu pomocou Simpsonovej metódy\n");
    fprintf(integralTxt, "------------------------------------------------------------\n");
    
    fprintf(integralTxt, "Integral vyzerá nasledovne: I = %d - %d ∫ (%d*x^2 + %d*x + %d) / (%d*x + %d)*(%d*x + %d) dx\n\n", lowerBound, upperBound, parameterA, parameterB, parameterC, parameterK, parameterQ, parameterR, parameterS);

    % Symbolické výrazy pre derivácie
    syms x
    % symbolický výraz pre integral
    ff(x) = f(x);
    % štvrtá derivácia našej symbolickej rovnice
    d4f(x) = diff(ff(x), 4);
    % výraz pre štvrtú derivácu
    expresion = formula(d4f);
    % funkcia pre štvrtú derivácu
    d4fn = matlabFunction(expresion);

    % zistíme najväčšiu hodnotu štvrtéj derivácie na danom intervale
    maxFunctionValue = d4fn(lowerBound);

    % prechádzame cez interval a zistujeme, či je hodnota štvrtej derivácie na danom intervale väčšia ako maxFunctionValue po krokoch epsilon
    for i = lowerBound : epsilon : upperBound
        % zistíme hodnotu štvrtej derivácie na danom intervale
        tempMaxFunctionValue = d4fn(i);

        % ak je hodnota štvrtej derivácie na danom intervale väčšia ako maxFunctionValue, tak nastavíme maxFunctionValue na hodnotu štvrtej derivácie na danom intervale
        if tempMaxFunctionValue > maxFunctionValue
            maxFunctionValue = tempMaxFunctionValue;
        end
    end

    if maxFunctionValue == NaN || maxFunctionValue == Inf
        disp('Nastala chyba pri výpočte štvrtej derivácie.');
        fprintf(integralTxt, "Nastala chyba pri výpočte štvrtej derivácie, takže sa nedá vypočítať integral pomocou Simpsonovej metódy.\n");
        return;
    end

    % zapíšeme do súboru Integral.txt najväčšiu hodnotu štvrtej derivácie na danom intervale
    fprintf(integralTxt, "Najväčšia hodnota štvrtej derivácie na danom intervale je: %f\n", maxFunctionValue);
    % vypíšeme do konzoly najväčšiu hodnotu štvrtej derivácie na danom intervale
    disp(['Najväčšia hodnota štvrtej derivácie na danom intervale je: ', num2str(maxFunctionValue)]);

    % vypočítame n pre Simpsonovu metódu

    % fix je funkcia v matlabe ktorá zaokrúhľuje číslo na celé číslo
    % nthroot je funkcia v matlabe ktorá vypočíta n-tú odmocninu

    if ((((upperBound - lowerBound)^5) / (180 * epsilon)) * maxFunctionValue) < 0
        disp('Nastala chyba pri výpočte počtu subintervalov.');
        fprintf(integralTxt, "Nastala chyba pri výpočte počtu subintervalov, takže sa nedá vypočítať integral pomocou Simpsonovej metódy.\n");
        return;
    end

    % vypočítame n pre Simpsonovu metódu
    % fix je funkcia v matlabe ktorá zaokrúhľuje číslo na celé číslo
    % ceil je funkcia v matlabe ktorá zaokrúhľuje číslo nahor
    % nthroot je funkcia v matlabe ktorá vypočíta n-tú odmocninu
    % n je počet subintervalov
    % nthroot((((upperBound - lowerBound)^5) / (180 * epsilon)) * maxFunctionValue, 4) je výraz pre výpočet n
    n = fix(ceil((nthroot((((upperBound - lowerBound)^5) / (180 * epsilon)) * maxFunctionValue, 4))));

    if n == NaN || n == Inf
        disp('Nastala chyba pri výpočte počtu subintervalov.');
        fprintf(integralTxt, "Nastala chyba pri výpočte počtu subintervalov, takže sa nedá vypočítať integral pomocou Simpsonovej metódy.\n");
        return;
    end

    % ak je n nepárne číslo, tak ho zvýšime o 1
    if (mod(n, 2) ~= 0)
        n = n + 1;
    end

    % zapíšeme do súboru Integral.txt počet subintervalov
    fprintf(integralTxt, "Počet subintervalov je: %d\n", n);
    % vypíšeme do konzoly počet subintervalov
    disp(['Počet subintervalov je: ', num2str(n)]);

    % vypočítame h
    h = abs((upperBound - lowerBound)) / n;
    % zapíšeme do súboru Integral.txt vzdialenosť uzlových bodov
    fprintf(integralTxt, "Vzdialenosť uzlových bodov je: %f\n", h);
    % vypíšeme do konzoly vzdialenosť uzlových bodov
    disp(['Vzdialenosť uzlových bodov je: ', num2str(h)]);

    % matica intervals bude obsahovať všetky hodnoty x, ktoré budeme používať
    intervals = zeros(1, n + 1);

    % prechádzame cez všetky hodnoty x a vypočítavame ich
    for i = 1 : n + 1
        % ak sme na konci, tak nastavíme poslednú hodnotu na hornú hranicu
        if i == n
            intervals(i) = upperBound;
            continue;
        end

        % vypočítame hodnotu x
        intervals(i) = lowerBound + h * (i - 1);
    end

    % Párne a nepárne čísla
    even = 0;
    odd = 0;

    % Zapíšeme do súboru Integral.txt informácie o priebehu výpočtu
    fprintf(integralTxt, "\nVýpočet súčtov pre párne a nepárne čísla:\n");
    fprintf(integralTxt, "---------------------------------------------\n");

    for i = 1 : n - 1
        % Ak je číslo párne, tak ho pridáme do párnych čísel
        if (mod(i, 2) == 0)
            even = even + f(intervals(i + 1));
            fprintf(integralTxt, "Párne číslo: f(x_%d) = f(%.5f) = %.5f\n", i, intervals(i + 1), f(intervals(i + 1)));
        % Ak je číslo nepárne, tak ho pridáme do nepárnych čísel
        else
            odd = odd + f(intervals(i + 1));
            fprintf(integralTxt, "Nepárne číslo: f(x_%d) = f(%.5f) = %.5f\n", i, intervals(i + 1), f(intervals(i + 1)));
        end
    end

    % Zapíšeme do súboru Integral.txt súčet párnych a nepárnych hodnôt
    fprintf(integralTxt, "\nSúčet párnych hodnôt: %.5f\n", odd);
    fprintf(integralTxt, "Súčet nepárnych hodnôt: %.5f\n", even);
    fprintf(integralTxt, "---------------------------------------------\n");

    % Vypočítame hodnotu určitého integrálu pomocou vzorca Simpsonovej metódy
    % (h / 3) * (f(lowerBound) + f(upperBound) + 4 * odd + 2 * even)
    integralValue = (h / 3) * (f(lowerBound) + f(upperBound) + 4 * odd + 2 * even);

    % Zapíšeme do súboru Integral.txt informácie o výpočte vzorca Simpsonovej metódy
    fprintf(integralTxt, "\nVýpočet vzorca Simpsonovej metódy:\n");
    fprintf(integralTxt, "-------------------------------------------------\n");
    fprintf(integralTxt, "f(a) = f(%.5f) = %.5f\n", lowerBound, f(lowerBound));
    fprintf(integralTxt, "f(b) = f(%.5f) = %.5f\n", upperBound, f(upperBound));
    fprintf(integralTxt, "4 * Súčet nepárnych hodnôt = 4 * %.5f = %.5f\n", odd, 4 * odd);
    fprintf(integralTxt, "2 * Súčet párnych hodnôt = 2 * %.5f = %.5f\n", even, 2 * even);
    fprintf(integralTxt, "-------------------------------------------------\n");

    % Zapíšeme do súboru Integral.txt výslednú hodnotu určitého integrálu vo forme vzorca
    fprintf(integralTxt, "Výsledná hodnota určitého integrálu je: (h/3) * [f(a) + f(b) + 4 * Súčet nepárnych hodnôt + 2 * Súčet párnych hodnôt] = \n(%.5f/3) * [%.5f + %.5f + 4 * %.5f + 2 * %.5f] = %f\n", h, f(lowerBound), f(upperBound), odd, even, integralValue);


    % Vypíšeme do konzoly informácie o výpočte vzorca Simpsonovej metódy
    disp(['f(a) = f(', num2str(lowerBound), ') = ', num2str(f(lowerBound))]);
    disp(['f(b) = f(', num2str(upperBound), ') = ', num2str(f(upperBound))]);
    disp(['4 * Súčet nepárnych hodnôt = 4 * ', num2str(odd), ' = ', num2str(4 * odd)]);
    disp(['2 * Súčet párnych hodnôt = 2 * ', num2str(even), ' = ', num2str(2 * even)]);

    % Vypíšeme do konzoly výslednú hodnotu určitého integrálu vo forme vzorca
    disp(['Výsledná hodnota určitého integrálu je: (h/3) * [f(a) + f(b) + 4 * Súčet nepárnych hodnôt + 2 * Súčet párnych hodnôt] = (', num2str(h), '/3) * [', num2str(f(lowerBound)), ' + ', num2str(f(upperBound)), ' + 4 * ', num2str(odd), ' + 2 * ', num2str(even), '] = ', num2str(integralValue), newline]);

    % zavrieme súbor Integral.txt
    fclose(integralTxt);
end


