function results = performLagrangeInterpolationAndSaveResultsIntoFile(xValues, yValues, iterator)
    % Vytvoríme/Otvoríme súbor Aproximacia.txt, do ktorého budeme ukladať výsledky aproximácií.
    AproximationTxt = fopen('OutputFiles/Aproximacia.txt', 'a');

    % Výpis do konzoly
    disp([newline,'-------------------------------------------']);
    disp(['Vstupný súbor DataAproximacie.txt ', num2str(iterator), '. funkcia']);
    disp(['-------------------------------------------', newline]);

    disp(['Keďže počet bodov je menší ako 6, použijeme Lagrangeovu interpoláciu.', newline]);	

    disp(['--------------------------------']);
    disp(['Lagrangeov interpolačný polynóm: ']);
    disp(['--------------------------------', newline]);

    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
    pause(1);

    % Výpis do súboru Aproximacia.txt
    fprintf(AproximationTxt, '\n#############################################\n');
    fprintf(AproximationTxt, 'Vstupný súbor DataAproximacie.txt %d. funkcia: \n', iterator);
    fprintf(AproximationTxt, '#############################################\n\n');

    fprintf(AproximationTxt, '--------------------------------\n');
    fprintf(AproximationTxt, 'Lagrangeov interpolačný polynóm: \n');
    fprintf(AproximationTxt, '--------------------------------\n\n');

    % premenná numPoints obsahuje počet bodov, ktoré budú použité pri aproximácii, resp. počet bodov v dátach.
    numPoints = length(xValues);

    % Výpis do konzoly a do súboru Aproximacia.txt
    disp(['Počet bodov pre aproximáciu: ', num2str(numPoints), newline]);
    fprintf(AproximationTxt, 'Počet bodov pre aproximáciu: %d\n\n', numPoints);

    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
    pause(1);

    % Inicializácia výsledného interpolačného polynómu na nulový vektor.
    LagrangePolynomial = zeros(1, numPoints);

    % Hlavný cyklus pre výpočet Lagrangeovho interpolačného polynómu.
    % prechádzame jednotlivými bodmi a vypočítavame koeficienty Lagrangeovho interpolačného polynómu
    for i = 1 : numPoints
        % Inicializácia čitateľa a menovateľa pre aktuálny člen polynómu.

        % premenná numerator bude obsahovať citateľ Lagrangeovho polynómu
        numerator = 1;
        % premenná denominator bude obsahovať menovateľ Lagrangeovho polynómu
        denominator = 1;

        % Cyklus pre výpočet čitateľa a menovateľa aktuálneho členu polynómu.
        % prechádzame jednotlivými bodmi a vypočítavame citateľ a menovateľ Lagrangeovho polynómu
        for j = 1 : numPoints
            % premenná term bude obsahovať jednotlivé členy citateľa Lagrangeovho polynómu
            % Výraz (x - x_j) pre aktuálny člen.
            term = [1, -xValues(j)];
            % ak i a j nie sú rovnaké, tak sa pridá do citateľa Lagrangeovho polynómu člen, 
            % resp. ak i nie je rovné j, aktualizujeme čitateľ a menovateľ.
            if i ~= j
                % premenná numerator bude obsahovať citateľ Lagrangeovho polynómu
                % funkcia conv() slúži na konvolúciu dvoch polynomov
                % konvolúcia je sčítanie výsledkov násobenia jednotlivých členov polynomov
                numerator = conv(numerator, term);
                % premenná denominator bude obsahovať menovateľ Lagrangeovho polynómu
                % nemusíme použiť funkciu conv(), pretože je to číslo
                denominator = denominator * (xValues(i) - xValues(j));
            end
        end
        % premenná LagrangePolynomial bude obsahovať koeficienty Lagrangeovho interpolačného polynómu
        LagrangePolynomial = LagrangePolynomial + (yValues(i) / denominator) * numerator;
    end
    
    % Nastavenie formátu výpisu koeficientov Lagrangeovho polynómu na
    % zobrazenie výsledkov v racionalnom formáte
    format rat

    % Výpis do konzoly
    disp('Koeficienty Lagrangeovho interpolačného polynómu L_n: ');
    % Vypis koeficientov Lagrangeovho polynómu
    % strtrim odstráni medzery na začiatku a na konci reťazca
    % rats zobrazí čísla v racionalnom formáte
    disp(strtrim(rats(LagrangePolynomial)));

    % Vypis bodov, ktore boli aproximovane
    disp('Aproximované body:');
    for i = 1:numPoints
        disp(['x(', num2str(i), ') = ', num2str(xValues(i)), ', f(', num2str(i), ') = ', num2str(yValues(i))]);
    end

    % Vypis bodov, ktore boli aproximovane do súboru Aproximacia.txt
    fprintf(AproximationTxt, 'Aproximované body:\n');
    for i = 1:numPoints
        fprintf(AproximationTxt, 'x(%d) = %s, f(%d) = %s\n', i, num2str(xValues(i)), i, num2str(yValues(i)));
    end

    % Výpis do súboru Aproximacia.txt
    fprintf(AproximationTxt, '\nKoeficienty Lagrangeovho interpolačného polynómu L_n: \n');

    % zapis koeficientov Lagrangeovho polynómu
    for i = 1:length(LagrangePolynomial)
        % zaokrúhlime koeficient na maximálne 4 desatinné miesta
        % pretože funkcia rats() nevie zobrazovať čísla s veľkým počtom desatinných miest
        % uložíme zaokrúhlený koeficient do premennej truncatedCoef
        truncatedCoef = round(LagrangePolynomial(i) * 1e4) / 1e4;
        
        % pomocou funkcie rats() zobrazíme čísla v racionalnom formáte
        % uložíme koeficient do premennej coefStr
        coefStr = rats(truncatedCoef);
        
        % vypíšeme koeficient do súboru Aproximacia.txt
        fprintf(AproximationTxt, '%s ', coefStr);
    end
    fprintf(AproximationTxt, '\n');

    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
    pause(1);

    % nastavíme results na výsledný Lagrangeov polynóm
    results = LagrangePolynomial;

    % zatvoríme súbor Aproximacia.txt
    fclose(AproximationTxt);
end