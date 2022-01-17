function [numero] = obtenerNumero(imagen,nums)
    
    load templates;
   
    max = -inf;
    v = 1;

    for i = 1:nums
        sem = corr2(templates{1,i},imagen);
        if(sem > max)
            max = sem;
            v = i;
        end
    end

    
    switch(v)
        case 1
            numero = "0";
        case 2
            numero = "1";
        case 3
            numero = "2";
        case 4
            numero = "3";
        case 5
            numero = "4";
        case 6
            numero = "5";
        case 7
            numero = "6";
        case 8
            numero = "7";
        case 9
            numero = "8";
        case 10
            numero = "9";
        otherwise
            numero = 'nulo';
    end
end