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

    % Opýtame sa užívateľa že či chce zadať intervaly pre korene alebo ich automaticky
    % vygenerovať
    disp("Chcete zadať intervaly pre korene alebo ich automaticky vygenerovať? (Zadajte 1 pre zadať intervaly, 2 pre automaticky vygenerovať)");
    % premenná pre výber používateľa
    choice = 0;
    % pokiaľ používateľ nezadal 1 alebo 2, tak sa ho budeme pýtať znova
    choiceHelp = input("(Zadajte 1 pre zadať intervaly, 2 pre automaticky vygenerovať):", "s");
    while ~strcmpi(choiceHelp, "1") && ~strcmpi(choiceHelp, "2")
        % informujeme používateľa o tom, že zadal neplatný vstup
        disp("Zadali ste neplatný vstup! Skúste znova!");
        % pýtať sa ho znova
        choiceHelp = input("(Zadajte 1 pre zadať intervaly, 2 pre automaticky vygenerovať):", "s");
    end

    if strcmpi(choiceHelp, "1")

        % budeme počítať koľkokrát zadal používateľ neplatný vstup
        badIntervalsCount = 0;

        % hláška pre používateľa o tom, že ak zadá 3krát zadá neplatný interval, tak sa automaticky vygenerujú intervaly pre korene
        disp('Ak zadáte 3krát neplatný interval, tak sa automaticky vygenerujú intervaly pre korene!');

        % prechádzame cez počtu koreňov
        for i = 1 : rootsCount
            valid_interval = false; % inicializujeme premennú pre validitu intervalu
    
            while ~valid_interval
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
                        badIntervalsCount = badIntervalsCount + 1;

                        if badIntervalsCount >= 3
                            disp('Zadali ste aspoň 3krát neplatný interval, tak sa automaticky vygenerujú intervaly pre korene!');
                            break;
                        end
                    end
                end

                valid_interval = true; % nastavíme validitu intervalu na true
                % skontrolujeme, či nový interval sa neprekrýva s už existujúcimi intervalmi

                for j = 1:(i - 1)
                    if (intervals(j,2) <= sup && intervals(j,3) >= sup) || (intervals(j,2) <= inf && intervals(j,3) >= inf)
                        valid_interval = false;
                        disp("Zadaný interval sa prekrýva s už existujúcim intervalom.");
                        badIntervalsCount = badIntervalsCount + 1;
                        if badIntervalsCount >= 3
                            disp('Zadali ste aspoň 3krát neplatný interval, tak sa automaticky vygenerujú intervaly pre korene!');
                        end
                        break;
                    end
                end

                if badIntervalsCount >= 3
                    break;
                end
            end

            if badIntervalsCount >= 3
                break;
            end

            % Ak naše intervaly sú validné, obsahujú práve jeden koreň, uložíme
            % ich do nového riadku matici intervals vo forme: koreň, dolná
            % hranica, horná hranica
            intervals(i,:) =  [i, inf, sup];

            % Informujeme používateľa o tom, že sme uložili hranice do matici
            disp(['Správne hranice, uložili sme ich do matice s menom "intervals"', newline]);
        end  

        if badIntervalsCount >= 3
            intervals = generateIntervals(rootsCount, a, b, c, d, f);
        end
    elseif strcmpi(choiceHelp, "2")
        intervals = generateIntervals(rootsCount, a, b, c, d, f);
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

% Funkcia generateIntervals, ktorá vygeneruje intervaly pre korene
function intervals = generateIntervals(rootsCount, a, b, c, d, f)
    % Vytvoríme vektor, ktorý bude obsahovať korene
    rootsVector = roots([a, b, c, d]);
    
    % Vytvoríme vektor, ktorý bude obsahovať korene bez komplexných čísel
    rootsVectorWithoutImaginary = rootsVector(imag(rootsVector) == 0);
    
    % Vytvoríme vektor, ktorý bude obsahovať korene bez komplexných čísel a
    % duplicitných koreňov
    rootsVectorWithoutImaginaryNoDuplicates = unique(rootsVectorWithoutImaginary);
    
    % Inicializujeme maticu pre intervaly
    intervals = zeros(rootsCount, 3);
    
    % Prejdeme cez všetky korene
    for i = 1:numel(rootsVectorWithoutImaginaryNoDuplicates)
        % Nájdeme interval, ktorý obsahuje len jeden koreň
        inf = rootsVectorWithoutImaginaryNoDuplicates(i);
        sup = inf;
        
        % Rozšírime interval, kým nespĺňa podmienku Bolzanovej vety
        while f(inf) * f(sup) >= 0
            inf = inf - 0.05;
            sup = sup + 0.05;
        end
        
        % Skontrolujeme, či sa nový interval neprekrýva s predchádzajúcimi
        for j = 1:i-1
            % Ak sa prekrýva, posunieme hornú hranicu nového intervalu
            while intervals(j, 2) <= sup && intervals(j, 3) >= inf
                % Posunieme hornú hranicu nového intervalu
                sup = sup + 0.05;
                % Ak je potrebné, posunieme aj dolnú hranicu nového intervalu
                if f(inf) * f(sup) >= 0
                    inf = inf - 0.05;
                end
            end
        end
        
        % Uložíme nájdený interval do matice 'intervals'
        intervals(i, :) = [i, inf, sup];
    end
end