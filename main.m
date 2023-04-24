% Hlavna funkcia programu s nazvom main
% Funkcia main slúži na výber úloh, ktoré chceme spustiť, sa spustí automaticky po spustení programu

% spustí to 2 hlavné funkcie, ktoré sú v tomto súbore
% a výsledky ich výpočtov budú uložené do súborov v priečinku OutputFiles
% tie 2 hlavné funkcie sú equationSeparationWithAproximationsAndSimpsonMethod a lagrangeInterpolationAndLeastSquaresMethod
function main()

    % Iniciálne premazanie súborov v priečinku OutputFiles
    % Ak by sa v nich nachádzali nejaké dáta pred spustením programu, tak sa vymažú
    % (v mode 'w' sa otvorí/vytvori súbor na zápis, pomocou fclose obsah súboru sa premaže (kvôli mode w) a súbor sa zavrie)
    fid = fopen('OutputFiles/Rovnica.txt', 'w');        fclose(fid);
    fid = fopen('OutputFiles/Porovnania.txt', 'w');     fclose(fid);
    fid = fopen('OutputFiles/Integral.txt', 'w');       fclose(fid);
    fid = fopen('OutputFiles/Aproximacia.txt', 'w');    fclose(fid);

    % while cyklus 
    % cyklus sa opakuje, kým používateľ nezadá na konci úlohy že už nechce znova spustiť "program" (hlavnú funkciu)
    while true
        % Vítame používateľa
        disp('Vitajte v programe Zadanie1 (Zadanie-06) - Kde môžete vypočítať separácie koreňov rovnice, aproximovať ich reálne koreňe s bisekciou a s newtonovou metódou, a vypočítať určitý integrál.');
        disp('Alebo môžete aproximovať funkcie pomocou Lagrangeovej interpolácie a s metódou najmenších štvorcov.');
        disp(newline);
    
        % Výber úlohy
        disp('ak chcete vypočítať separácie koreňov rovnice, aproximovať ich reálne koreňe s bisekciou a s newtonovou metódou, a vypočítať určitý integrál, zadajte 1');
        disp('ak chcete aproximovať funkcie pomocou Lagrangeovej interpolácie a s metódou najmenších štvorcov, zadajte 2');
        disp(newline);
    
        % Získanie vstupu od používateľa
        mainUserChoice = input('Zadajte svoju voľbu: ( 1 alebo 2 ) ', 's');
        % Premenná mainUserChoiceNumber slúži na kontrolu vstupu od používateľa
        mainUserChoiceNumber = 0;
    
        % Kontrola vstupu od používateľa
        if (strcmpi(mainUserChoice, '1'))
            disp('Zvolili ste výpočet separácií koreňov rovnice, aproximáciu reálnych koreňov s bisekciou a s newtonovou metódou, a výpočet určitého integrálu.');
            disp('Po výpočte všetkých úloh, výsledky budú uložené do súborov v priečinku OutputFiles a budete pokračovať s úlohou 2.');
            mainUserChoiceNumber = 1;
        elseif (strcmpi(mainUserChoice, '2'))
            disp('Zvolili ste aproximáciu funkcie pomocou Lagrangeovej interpolácie a s metódou najmenších štvorcov.');
            disp('Po výpočte všetkých úloh, výsledky budú uložené do súborov v priečinku OutputFiles a budete pokračovať s úlohou 1.');
            mainUserChoiceNumber = 2;
        end
    
        % Kontrola vstupu od používateľa
        while mainUserChoiceNumber == 0
            disp('Zvolili ste nesprávnu voľbu, skúste to znovu.');
            mainUserChoice = input('Zadajte svoju voľbu: ( 1 alebo 2 ) ', 's');
    
            if (strcmpi(mainUserChoice, '1'))
                disp('Zvolili ste výpočet separácií koreňov rovnice, aproximáciu reálnych koreňov s bisekciou a s newtonovou metódou, a výpočet určitého integrálu.');
                mainUserChoiceNumber = 1;
                break;
            elseif (strcmpi(mainUserChoice, '2'))
                disp('Zvolili ste aproximáciu funkcie pomocou Lagrangeovej interpolácie a s metódou najmenších štvorcov.');
                mainUserChoiceNumber = 2;
                break;
            end
        end
    
        % Spustenie úloh podľa výberu používateľa
        switch mainUserChoiceNumber
            case 1
                % Spustenie úlohy 1
                equationSeparationWithAproximationsAndSimpsonMethod();
                % Výpis, že úloha bola úspešne dokončená
                disp('Úloha 1 bola úspešne dokončená.');
                % Výpis, že sa pokračuje s úlohou 2
                inputForSecondTask = input('Zadajte hocičo alebo stlačte enter pre pokračovanie s úlohou 2: ', 's');
                disp('Teraz budete pokračovať s úlohou 2.');
                pause(2);
                % Spustenie úlohy 2
                lagrangeInterpolationAndLeastSquaresMethod();
                disp('Úloha 2 bola úspešne dokončená.');
            case 2 
                % Spustenie úlohy 2     
                lagrangeInterpolationAndLeastSquaresMethod();
                % Výpis, že úloha bola úspešne dokončená
                disp('Úloha 2 bola úspešne dokončená.');
                % Výpis, že sa pokračuje s úlohou 1
                inputForFirstTask = input('Zadajte hocičo alebo stlačte enter pre pokračovanie s úlohou 1: ', 's');
                disp('Teraz budete pokračovať s úlohou 1.');
                pause(2);
                % Spustenie úlohy 1
                equationSeparationWithAproximationsAndSimpsonMethod();
                disp('Úloha 1 bola úspešne dokončená.');
        end
        % Výpis, že všetky úlohy boli úspešne dokončené
        disp('Výpočty skončili.');
        disp('Všetky výsledky sú uložené v priečinku OutputFiles.');
        disp('V súboru Rovnica.txt sú uložené separácie koreňov rovníc, výsledky aproximácie reálnych koreňov s bisekciou a s newtonovou metódou');
        disp('V súboru Porovnania.txt sú uložené porovnania aproximácie reálnych koreňov s bisekciou a s newtonovou metódou');
        disp('V súboru Integral.txt sú uložené výsledky výpočtu určitého integrálu pomocou Simpsonovej metódy');
        disp('V súboru Aproximacia.txt sú uložené výsledky aproximácie funkcie pomocou Lagrangeovej interpolácie');
        pause(1);
    
        % Výber, či sa má program spustiť znova alebo ukončiť
        disp('Chcete program spustiť znova alebo ukončiť?');
        disp('Ak chcete program spustiť znova, zadajte 1');
        disp('Ak chcete program ukončiť, zadajte 2');
        restartChoice = input('Zadajte svoju voľbu: (1 alebo 2) ', 's');
    
        % Kontrola vstupu od používateľa
        while ~strcmpi(restartChoice, '1') && ~strcmpi(restartChoice, '2')
            disp('Zvolili ste nesprávnu voľbu, skúste to znovu.');
            restartChoice = input('Zadajte svoju voľbu: (1 alebo 2) ', 's');
        end
    
        % Kontrola vstupu od používateľa
        if (strcmpi(restartChoice, '1'))
            disp('Zvolili ste spustenie programu znova.');

            disp('Chcete premazať obsahy súborov v priečinku OutputFiles?');
            disp('Ak chcete premazať obsahy súborov, zadajte 1');
            disp('Ak chcete zachovať obsahy súborov, zadajte 2');

            % Výber, či sa majú súbory v priečinku OutputFiles premazať alebo nie
            deleteFilesChoice = input('Zadajte svoju voľbu: (1 alebo 2) ', 's');

            % Kontrola vstupu od používateľa
            while ~strcmpi(deleteFilesChoice, '1') && ~strcmpi(deleteFilesChoice, '2')
                disp('Zvolili ste nesprávnu voľbu, skúste to znovu.');
                deleteFilesChoice = input('Zadajte svoju voľbu: (1 alebo 2) ', 's');
            end

            % Kontrola vstupu od používateľa
            if (strcmpi(deleteFilesChoice, '1'))
                disp('Zvolili ste premazanie obsahu súborov v priečinku OutputFiles.');
                disp('Obsah súborov v priečinku OutputFiles bude premazaný.');
                pause(1);
                fid = fopen('OutputFiles/Rovnica.txt', 'w');        fclose(fid);
                fid = fopen('OutputFiles/Porovnania.txt', 'w');     fclose(fid);
                fid = fopen('OutputFiles/Integral.txt', 'w');       fclose(fid);
                fid = fopen('OutputFiles/Aproximacia.txt', 'w');    fclose(fid);
                disp('Obsah súborov v priečinku OutputFiles bol úspešne premazaný.');
            elseif (strcmpi(deleteFilesChoice, '2'))
                disp('Zvolili ste zachovanie obsahu súborov v priečinku OutputFiles.');
                disp('Obsah súborov v priečinku OutputFiles nebude premazaný.');
                pause(1);
            end

            disp('Program sa spustí znova.');
            % Spustenie programu znova
            pause(1);
            % Vymazanie konzoly
            clc;
            % Vymazanie workspace
            clear;
            % Spustenie programu znova
            continue;
        elseif (strcmpi(restartChoice, '2'))
            disp('Zvolili ste ukončenie programu.');
            disp('Program sa ukončí.');
            disp('Ďakujem za použitie programu! :)');
            % Ukončenie programu
            pause(1);
            break;
        end
    end
end