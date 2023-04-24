% Pomocná funkcia na kontrolu, či je zadaný vstup reálne číslo
%
% parameter input_str : string (reťazec) - daný string o čom sa rozhodne
% funkcia či to je reálne číslo alebo nie
%
% výstup: isRealNumber : boolean (true alebo false)
function isRealNumber = checkRealNumber(input_str)
    isRealNumber = ~isempty(str2double(input_str)) && isreal(str2double(input_str)) && ~isnan(str2double(input_str));
end