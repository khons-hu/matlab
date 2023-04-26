function result = performLeastSquaresMethodAndSaveResultsIntoFile(xValues, yValues, iterator)
    % Vytvoríme/Otvoríme súbor Aproximacia.txt, do ktorého budeme ukladať výsledky aproximácií.
    AproximationTxt = fopen('OutputFiles/Aproximacia.txt', 'a');

    % Výpis do konzoly
    disp([newline,'-------------------------------------------']);
    disp(['Vstupný súbor DataAproximacie.txt ', num2str(iterator), '. funkcia']);
    disp(['-------------------------------------------', newline]);

    disp(['--------------------------------']);
    disp(['Metóda najmenších štvorcov: ']);
    disp(['--------------------------------', newline]);


    % Výpis do súboru Aproximacia.txt
    fprintf(AproximationTxt, '\n#############################################\n');
    fprintf(AproximationTxt, 'Vstupný súbor DataAproximacie.txt %d. funkcia: \n', iterator);
    fprintf(AproximationTxt, '#############################################\n\n');

    fprintf(AproximationTxt, '---------------------------\n');
    fprintf(AproximationTxt, 'Metóda najmenších štvorcov: \n');
    fprintf(AproximationTxt, '---------------------------\n\n');

    % pomocou funkcie pause() zastavíme program na 1 sekundu, aby sme mohli pozrieť si výsledky v konzole.
    pause(1);

    % Počet bodov, ktoré budeme aproximovať
    numPoints = length(xValues);

    % Výpis do konzoly
    disp(['Počet bodov pre aproximáciu: ', num2str(numPoints)]);
    fprintf(AproximationTxt, 'Počet bodov pre aproximáciu: %d\n\n', numPoints);
    pause(1);

    % Výpis do konzoly
    disp('Aproximované body:')

    % Výpis do súboru Aproximacia.txt
    fprintf(AproximationTxt, 'Aproximované body a ich funkčné hodnoty: \n');

    % Vypis bodov ktoré budeme aproximovať
    for i = 1:numPoints
        disp(['x(', num2str(i), ') = ', num2str(xValues(i)), ', f(x(', num2str(i), ')) = ', num2str(yValues(i))]);
        fprintf(AproximationTxt, 'x(%d) = %s,   f(x(%d)) = %s\n', i, num2str(xValues(i)), i, num2str(yValues(i)));
    end

    pause(1);

    % phi0, anonimná funkcia polynomu 0. stupňa
    phi0 = @(x)(x.^0);
    % phi1, anonimná funkcia polynomu 1. stupňa
    phi1 = @(x)(x.^1);
    % phi2, anonimná funkcia polynomu 2. stupňa
    phi2 = @(x)(x.^2);

    % Zoznam phi funkcií pre 1. stupňa
    phiFirstDegree = {phi0, phi1};
    % Zoznam phi funkcií pre 2. stupňa
    phiSecondDegree = {phi0, phi1, phi2};
    
    % Počet phiFirstDegree
    k = length(phiFirstDegree);

    % matica A na výpočet koeficientov 
    A = zeros(k, k);
    % vektor b na výpočet koeficientov
    b = zeros(k, 1);

    % Výpočet koeficientov pomocou metódy najmenších štvorcov
    % prechádzame cez počet phi
    for i = 1:k
        % prechádzame cez počet phi
        for j = 1:k
            % výpočet hodnôt matice A
            A(i,j) = sum(phiFirstDegree{i}(xValues).*phiFirstDegree{j}(xValues));
        end
        % výpočet hodnôt vektora b
        b(i) = sum(phiFirstDegree{i}(xValues).*yValues);
    end

    % funkcia linsovolve() vypočíta koeficienty polynómu
    X = linsolve(A,b);

    % vektor P na uloženie koeficientov polynómu
    P = zeros(1,k);
    % prechádzame cez počet phi
    for i = 1:k
        % prehodíme poradie koeficientov polynómu
        P(k-i+1) = X(i);
    end

    % Uloženie výsledkov do súboru Aproximacia.txt
    fprintf(AproximationTxt, '\nKoeficienty polynómu stupňa 1. pomocou metódy najmenších štvorcov: \n');
    for i = 1:length(P)
        coefStr = rats(P(i));
        fprintf(AproximationTxt, '%s ', coefStr);
    end
    fprintf(AproximationTxt, '\n\n');

    % Výpis do konzoly
    disp(['Koeficienty polynómu stupňa ', num2str(1), ' pomocou metódy najmenších štvorcov:']);
    for i = 1:length(P)
        disp(['koeficient_', num2str(length(P) - i), ' = ', num2str(P(i))]);
    end
    disp(newline);

    pause(1);

    % Výsledok je výsledný polynóm
    result = P;

    % Počet phiSecondDegree
    k = length(phiSecondDegree);

    % matica A na výpočet koeficientov 
    A = zeros(k, k); 
    % vektor b na výpočet koeficientov
    b = zeros(k, 1);

    % Výpočet koeficientov pomocou metódy najmenších štvorcov
    % prechádzame cez počet phi
    for i = 1:k
        % prechádzame cez počet phi
        for j = 1:k
            % výpočet hodnôt matice A
            A(i,j) = sum(phiSecondDegree{i}(xValues).*phiSecondDegree{j}(xValues));
        end
        % výpočet hodnôt vektora b
        b(i) = sum(phiSecondDegree{i}(xValues).*yValues);
    end

    % funkcia linsolve() vypočíta koeficienty polynómu
    X = linsolve(A,b);

    % vektor P na uloženie koeficientov polynómu
    P = zeros(1,k);
    % prechádzame cez počet phi
    for i = 1:k
        % prehodíme poradie koeficientov polynómu
        P(k-i+1) = X(i);
    end

    % Uloženie výsledkov do súboru Aproximacia.txt
    fprintf(AproximationTxt, '\nKoeficienty polynómu stupňa 2. pomocou metódy najmenších štvorcov: \n');
    for i = 1:length(P)
        coefStr = rats(P(i));
        fprintf(AproximationTxt, '%s ', coefStr);
    end
    fprintf(AproximationTxt, '\n\n');

    % Výpis do konzoly
    disp(['Koeficienty polynómu stupňa ', num2str(2), ' pomocou metódy najmenších štvorcov:']);
    for i = 1:length(P)
        disp(['koeficient_', num2str(length(P) - i), ' = ', num2str(P(i))]);
    end
    disp(newline);

    pause(1);

    % Zatvorenie súboru Aproximacia.txt
    fclose(AproximationTxt);

    % Výsledok je výsledný polynóm
    result = P;
end