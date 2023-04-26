% Hlavná funkcia programu
% ktorá spustí úlohu 2
% teda lagrangeovu interpoláciu a metódu najmenších štvorcov
function lagrangeInterpolationAndLeastSquaresMethod()
    % Aproximácia funkcie pomocou Lagrangeovej interpolácie a s metódou najmenších štvorcov
    % ----------------------------------------------------------------------------------------------------------------------------
    % Načítavanie DataAproximacie.txt do matice
    DataAproximationsInputFile = 'InputFiles/DataAproximacie.txt';
    if isfile(DataAproximationsInputFile)
        % Použitím funkcie readmatrix()
        DataAproximationsInputMatrix = readmatrix(DataAproximationsInputFile);

        % Výpis o vstupu
        disp('Váš vstupný súbor so vstupnými parametrami pre metódu najmenších štvorcov polynómom prvého a druhého stupňa funkcie');
        disp(', aj pre aproximáciu s Lagrangeovým interpolačným polynómom.');
        disp('V prípade malého matlab okienka je možné, že sa vám vstupný súbor vypíše s iným formátovaním.');
        disp(DataAproximationsInputMatrix);
        pause(1);

        disp('Kde štruktúra jeho riadkov je: hodnoty funkcií sú zadané vždy vo dvoch stĺpcoch (argument xi a funkčná hodnota f(xi)).')
        disp('Tzn. ak napr. súbor obsahuje 6 stĺpcov, tak reprezentuje 3 rôzne funkcie. Každá dvojica stĺpcov reprezentujúca jednu funkciu musí mať rovnaký rozmer');
        pause(1);
    else
        disp('Váš vstupný súbor so vstupnými parametrami pre metódu najmenších štvorcov');
        disp('a pre aproximáciu s Lagrangeovým interpolačným polynómom neexistuje.');
        disp('Vytvorte si súbor DataAproximacie.txt v priečinku InputFiles a spustite program znovu.');
        return;
    end
    % ----------------------------------------------------------------------------------------------------------------------------


    % ----------------------------------------------------------------------------------------------------------------------------

    if checkValidityOfDataAproximationsInputMatrix(DataAproximationsInputMatrix)
        % pocet funkcii, ktore su vstupnymi datami

        % Vypočítame počet funkcií v načítanom súbore DataAproximacie.txt. 
        % Počet stĺpcov delíme dvomi, pretože každá funkcia má dva stĺpce (x_i a f(x_i)).
        numberOfFunctions = size(DataAproximationsInputMatrix, 2) / 2;
        
        % Vytvoríme pole buniek pre jednotlivé funkcie. 
        % Každá bunka bude obsahovať dáta pre jednu funkciu.
        functions = cell(1, numberOfFunctions);

        % prechádzame stĺpcami vstupného súboru a rozdeľujeme dáta do buniek pre jednotlivé funkcie.
        for i = 1 : numberOfFunctions
            % funkcia je ulozena v dvoch stlpcoch
            functions{i} = DataAproximationsInputMatrix(:, 2 * i - 1 : 2 * i);
        end

        % Vytvoríme pole buniek pre uloženie aproximácií jednotlivých funkcií.
        approximations = cell(1, numberOfFunctions);

        % prechádza jednotlivými funkciami
        for i = 1 : numberOfFunctions
            % Premenná processedFunction obsahuje dáta pre aktuálnu funkciu. 
            processedFunction = functions{i};
            % odstranime riadky, ktore obsahuju NaN hodnoty
            processedFunction = processedFunction(~any(isnan(processedFunction), 2), :);

            % Pre každú funkciu sa rozhodne, či sa má použiť Lagrangeova interpolácia alebo metóda najmenších štvorcov. 

            % Ak je počet bodov funkcie menší ako 6, použije sa Lagrangeova interpolácia
            if size(processedFunction, 1) < 6
                % vypocitame aproximaciu pomocou metody najmensich stvorcov a ulozime vysledky do suboru Aproximacia.txt
                warning('off');
                approximations{i} = performLeastSquaresMethodAndSaveResultsIntoFile(processedFunction(:, 1), processedFunction(:, 2), i);
                % Skontrolujeme unikátnosť x-hodnôt, keďže Lagrangeova interpolácia vyžaduje unikátne x-hodnoty
                [uniqueX, uniqueIndex] = unique(processedFunction(:, 1), 'first');
                % Ak sa počet unikátnych x-hodnôt nerovná počtu riadkov v matici processedFunction,
                if numel(uniqueX) ~= numel(processedFunction(:, 1))
                    % Ak sú nejaké duplicity, vyhodíme tie, ktoré majú väčšiu y-hodnoty
                    % Vytvoríme novú maticu, ktorá obsahuje iba unikátne x-hodnoty a y-hodnoty, ktoré patria k týmto x-hodnotám
                    disp('Vstupný súbor obsahuje duplicitné x-hodnoty. Budú použité tie, ktoré majú väčšiu y-hodnotu.');
                    disp('teda odstránime duplicitné x-hodnoty, ktoré majú menšiu y-hodnotu.');
                    % Vytvoríme z processedFunction novú maticu, ktorá obsahuje iba unikátne x-hodnoty a y-hodnoty, ktoré patria k týmto x-hodnotám
                    processedFunction = processedFunction(uniqueIndex, :);
                end
                % vypocitame Lagrangeovu interpolaciu a ulozime vysledky do suboru Aproximacia.txt
                approximations{i} = performLagrangeInterpolationAndSaveResultsIntoFile(processedFunction(:, 1), processedFunction(:, 2), i);
            % V opačnom prípade sa použije metóda najmenších štvorcov 
            else 
                % vypocitame aproximaciu pomocou metody najmensich stvorcov a ulozime vysledky do suboru Aproximacia.txt
                approximations{i} = performLeastSquaresMethodAndSaveResultsIntoFile(processedFunction(:, 1), processedFunction(:, 2), i);
            end
        end
    else 
        disp('Súbor DataAproximacie.txt nie je platný, neobsahuje párny počet stlpcov alebo nebol nájdený. Skontrolujte, či je súbor v adresári InputFiles a že či obsahuje párny počet stlpcov.');
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