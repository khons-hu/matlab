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
            fprintf(ComparationTxt, "V prípade %d. koreňa newtonova metóda nespĺňala Furierove podmienky, takže jednoznačne Bisekcia vyhrala.\n", i);
            continue;
        end

        if errorEstimateBisectionMatrix(i) < errorEstimateNewtonMethodMatrix(i)
            fprintf(ComparationTxt, "Chybový odhad bisekcií pre %d. koreň je menší ako chybový odhad newtonovej metódy o %f.\n", i, errorEstimateNewtonMethodMatrix(i) - errorEstimateBisectionMatrix(i));
        elseif errorEstimateBisectionMatrix(i) > errorEstimateNewtonMethodMatrix(i)
            fprintf(ComparationTxt, "Chybový odhad newtonovej metódy pre %d. koreň je menší ako chybový odhad bisekcií o %f.\n", i, errorEstimateBisectionMatrix(i) - errorEstimateNewtonMethodMatrix(i));
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
            fprintf(ComparationTxt, "V prípade %d. koreňa newtonova metóda nespĺňala Furierove podmienky, takže jednoznačne Bisekcia vyhrala.\n", i);
            continue;
        end

        if bisectionRootsVector(i) < newtonRootsVector(i)
            fprintf(ComparationTxt, "Odhadnutý koreň bisekcií pre %d. koreň je menší ako odhadnutý koreň newtonovej metódy o %f.\n", i, abs(newtonRootsVector(i) - bisectionRootsVector(i)));
        elseif bisectionRootsVector(i) > newtonRootsVector(i)
            fprintf(ComparationTxt, "Odhadnutý koreň newtonovej metódy pre %d. koreň je menší ako odhadnutý koreň bisekcií o %f.\n", i, abs(bisectionRootsVector(i) - newtonRootsVector(i)));
        else
            fprintf(ComparationTxt, "Odhadnuté korene bisekcií a newtonovej metódy pre %d. koreň sú rovnaké.\n", i);
        end
    end

    % zavrieme súbor Porovnania.txt
    fclose(ComparationTxt);

    % vypíšeme do konzoly, že súbor Porovnania.txt bol úspešne zapísaný
    disp(['Porovnania bisekcií a newtonovej metódy boli úspešne zapísané do súboru Porovnania.txt v adresári OutputFiles', newline]);
end