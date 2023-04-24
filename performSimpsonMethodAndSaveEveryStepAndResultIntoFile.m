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
    syms ff(x)
    % symbolický výraz pre integral
    ff(x) = (parameterA.*x.^2 + parameterB.*x + parameterC) ./ (parameterK.*x + parameterQ).*(parameterR.*x + parameterS);
    % štvrtá derivácia našej symbolickej rovnice
    d4f(x) = diff(ff(x), 4);

    % zistíme najväčšiu hodnotu štvrtej derivácie na danom intervale
    maxFunctionValue = diff((-1) * ff(x), 4);

    % vytvoríme si premenné, ktoré budú obsahovať hodnoty parametrov
    expresion = subs(maxFunctionValue, {'parameterA', 'parameterB', 'parameterC', 'parameterK', 'parameterQ', 'parameterR', 'parameterS'}, {parameterA, parameterB, parameterC, parameterK, parameterQ, parameterR, parameterS});

    % vytvoríme si funkciu, ktorá bude obsahovať štvrtú deriváciu našej rovnice
    maxFunctionValueDescriptor = matlabFunction(expresion, 'Vars', x);

    % pomocou funkcie fminbnd() zistíme najväčšiu hodnotu štvrtej derivácie na danom intervale
    maximum = fminbnd(maxFunctionValueDescriptor, lowerBound, upperBound);

    % zapíšeme do súboru Integral.txt najväčšiu hodnotu štvrtej derivácie na danom intervale
    fprintf(integralTxt, "Najväčšia hodnota štvrtej derivácie na danom intervale je: %f\n", maximum);
    % vypíšeme do konzoly najväčšiu hodnotu štvrtej derivácie na danom intervale
    disp(['Najväčšia hodnota štvrtej derivácie na danom intervale je: ', num2str(maximum)]);
    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
    pause(1);

    % vypočítame n pre Simpsonovu metódu

    % fix je funkcia v matlabe ktorá zaokrúhľuje číslo na celé číslo
    % nthroot je funkcia v matlabe ktorá vypočíta n-tú odmocninu

    if (((upperBound - lowerBound).^5) .* maximum) ./ (epsilon * 180) < 0
        disp('Nastala chyba pri výpočte počtu subintervalov.');
        fprintf(integralTxt, "Nastala chyba pri výpočte počtu subintervalov, takže sa nedá vypočítať integral pomocou Simpsonovej metódy.\n");
        % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
        pause(1);
        return;
    end

    % vypočítame n pre Simpsonovu metódu
    % fix je funkcia v matlabe ktorá zaokrúhľuje číslo na celé číslo
    % ceil je funkcia v matlabe ktorá zaokrúhľuje číslo nahor
    % nthroot je funkcia v matlabe ktorá vypočíta n-tú odmocninu
    % n je počet subintervalov
    n = ceil(nthroot((((upperBound - lowerBound).^5) .* maximum) ./ (epsilon * 180), 4));

    if isnan(n) || n == Inf
        disp('Nastala chyba pri výpočte počtu subintervalov.');
        fprintf(integralTxt, "Nastala chyba pri výpočte počtu subintervalov, takže sa nedá vypočítať integral pomocou Simpsonovej metódy.\n");
        % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
        pause(1);
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
    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
    pause(1);

    % vypočítame h
    h = abs((upperBound - lowerBound)) / n;
    % zapíšeme do súboru Integral.txt vzdialenosť uzlových bodov
    fprintf(integralTxt, "Vzdialenosť uzlových bodov je: %f\n", h);
    % vypíšeme do konzoly vzdialenosť uzlových bodov
    disp(['Vzdialenosť uzlových bodov je: ', num2str(h)]);
    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
    pause(1);

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
        % Ak je číslo nepárne, tak ho pridáme do nepárnych čísel
        else
            odd = odd + f(intervals(i + 1));
        end
    end

    if isnan(odd) || isnan(even) || odd == Inf || even == Inf
        disp('Nastala chyba pri výpočte súčtov pre párne a nepárne čísla.');
        fprintf(integralTxt, "Nastala chyba pri výpočte súčtov pre párne a nepárne čísla, takže sa nedá vypočítať integral pomocou Simpsonovej metódy.\n");
        % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
        pause(1);
        return;
    end

    % Vypočítame počet desatinných miest pre epsilon a pridáme 10
    % abs je funkcia v matlabe ktorá vypočíta absolutnú hodnotu
    % log10 je funkcia v matlabe ktorá vypočíta desatinný logaritmus
    % ceil je funkcia v matlabe ktorá zaokrúhľuje číslo nahor
    % + 10 je preto, aby sme mali aspoň 10 desatinných miest
    decimalPlaces = ceil(abs(log10(epsilon))) + 10;

    % Použijeme dynamické formátovanie reťazca pre výpisy a zápisy do súboru
    formatString = sprintf('%%.%df', decimalPlaces);

    % Zapíšeme do súboru Integral.txt súčet párnych a nepárnych hodnôt
    fprintf(integralTxt, "\nSúčet párnych hodnôt: ");
    fprintf(integralTxt, formatString, odd);
    fprintf(integralTxt, "\n");
    fprintf(integralTxt, "Súčet nepárnych hodnôt: ");
    fprintf(integralTxt, formatString, even);
    fprintf(integralTxt, "\n");
    fprintf(integralTxt, "---------------------------------------------\n");

    % Vypočítame hodnotu určitého integrálu pomocou vzorca Simpsonovej metódy
    % (h / 3) * (f(lowerBound) + f(upperBound) + 4 * odd + 2 * even)
    integralValue = abs((h / 3) * (f(lowerBound) + f(upperBound) + 4 * odd + 2 * even));

    % Zapíšeme do súboru Integral.txt informácie o výpočte vzorca Simpsonovej metódy
    fprintf(integralTxt, "\nVýpočet vzorca Simpsonovej metódy:\n");
    fprintf(integralTxt, "-------------------------------------------------\n");
    fprintf(integralTxt, "f(a) = f(");
    fprintf(integralTxt, formatString, lowerBound);
    fprintf(integralTxt, ") = ");
    fprintf(integralTxt, formatString, f(lowerBound));
    fprintf(integralTxt, "\n");

    fprintf(integralTxt, "f(b) = f(");
    fprintf(integralTxt, formatString, upperBound);
    fprintf(integralTxt, ") = ");
    fprintf(integralTxt, formatString, f(upperBound));
    fprintf(integralTxt, "\n");

    fprintf(integralTxt, "4 * Súčet nepárnych hodnôt = 4 * ");
    fprintf(integralTxt, formatString, odd);
    fprintf(integralTxt, " = ");
    fprintf(integralTxt, formatString, 4 * odd);
    fprintf(integralTxt, "\n");

    fprintf(integralTxt, "2 * Súčet párnych hodnôt = 2 * ");
    fprintf(integralTxt, formatString, even);
    fprintf(integralTxt, " = ");
    fprintf(integralTxt, formatString, 2 * even);
    fprintf(integralTxt, "\n");

    fprintf(integralTxt, "-------------------------------------------------\n");

    % Zapíšeme do súboru Integral.txt výslednú hodnotu určitého integrálu vo forme vzorca
    fprintf(integralTxt, "Výsledná hodnota určitého integrálu je: (h/3) * [f(a) + f(b) + 4 * Súčet nepárnych hodnôt + 2 * Súčet párnych hodnôt] = \n(");
    fprintf(integralTxt, formatString, h);
    fprintf(integralTxt, "/3) * [");
    fprintf(integralTxt, formatString, f(lowerBound));
    fprintf(integralTxt, " + ");
    fprintf(integralTxt, formatString, f(upperBound));
    fprintf(integralTxt, " + 4 * ");
    fprintf(integralTxt, formatString, odd);
    fprintf(integralTxt, " + 2 * ");
    fprintf(integralTxt, formatString, even);
    fprintf(integralTxt, "] = ");
    fprintf(integralTxt, formatString, integralValue);
    fprintf(integralTxt, "\n");

    % Vypíšeme do konzoly informácie o výpočte vzorca Simpsonovej metódy
    disp(['f(a) = f(', num2str(lowerBound), ') = ', num2str(f(lowerBound))]);
    disp(['f(b) = f(', num2str(upperBound), ') = ', num2str(f(upperBound))]);
    disp(['4 * Súčet nepárnych hodnôt = 4 * ', num2str(odd), ' = ', num2str(4 * odd)]);
    disp(['2 * Súčet párnych hodnôt = 2 * ', num2str(even), ' = ', num2str(2 * even)]);
    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
    pause(1);

    % Vypíšeme do konzoly výslednú hodnotu určitého integrálu vo forme vzorca
    fprintf(integralTxt, "------------------------------------------------------------------------------------------------------------\n");
    disp(['Výsledná hodnota určitého integrálu je: (h/3) * [f(a) + f(b) + 4 * Súčet nepárnych hodnôt + 2 * Súčet párnych hodnôt] = (', num2str(h), '/3) * [', num2str(f(lowerBound)), ' + ', num2str(f(upperBound)), ' + 4 * ', num2str(odd), ' + 2 * ', num2str(even), '] = ', num2str(integralValue), newline]);
    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
    pause(1);

    % Odhad chyby určitého integrálu pomocou vzorca ((b - a) / 180) * h^4 * max(f^(4)(x))
    errorEstimateIntegral = abs(((upperBound - lowerBound) / 180) * h.^4 * maximum);
    errorEstimateIntegralString = sprintf('%.9f', errorEstimateIntegral);

    disp(['Odhad chyby určitého integrálu pomocou vzorca ((b - a) / 180) * h^4 * max(f^(4)(x)) = (', num2str(upperBound), ' - ', num2str(lowerBound), ') / 180) * ', num2str(h), '^4 * ', num2str(maximum), ' = ', errorEstimateIntegralString, newline]);
    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
    pause(1);

    % Zapíšeme do súboru Integral.txt odhad chyby určitého integrálu pomocou vzorca
    fprintf(integralTxt, "------------------------------------------------------------------------------------------------------------\n");
    fprintf(integralTxt, "Odhad chyby určitého integrálu pomocou vzorca ((b - a) / 180) * h^4 * max(f^(4)(x)) = \n((");
    fprintf(integralTxt, formatString, upperBound);
    fprintf(integralTxt, " - ");
    fprintf(integralTxt, formatString, lowerBound);
    fprintf(integralTxt, ") / 180) * ");
    fprintf(integralTxt, formatString, h);
    fprintf(integralTxt, "^4 * ");
    fprintf(integralTxt, formatString, maximum);
    fprintf(integralTxt, " = ");
    fprintf(integralTxt, formatString, errorEstimateIntegral);
    fprintf(integralTxt, "\n");
    fprintf(integralTxt, "------------------------------------------------------------------------------------------------------------\n");

    % zavrieme súbor Integral.txt
    fclose(integralTxt);
end