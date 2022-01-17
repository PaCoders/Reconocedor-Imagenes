function [solucion] = calcularSerie(vector)
    
    index = find(vector ~= 0);
    solucion = vector;

    if(vector(1) ~= 1 && vector(2) ~= 1) % En el caso contrario sera hacer Fibonacci

       if(vector(1) < vector(2))
            razon = vector(2) - vector(1);
            index = find(vector(2:end)- razon == vector(1:end-1));
           if(length(razon) < 1)
             razon = [];
             for i = 1:index(end)
                 razon = [razon vector(i + 1) - vector(i)];
             end
           end

           for i = index(end)+1:length(vector)
                solucion(i) = solucion(i-1) + razon;
           end

       else
           razon = vector(1) - vector(2);
           for i = index(end)+1:length(vector)
                solucion(i) = solucion(i-1) - razon;
           end
       end
    else
        for i = index(end) + 1:length(vector)
            solucion(i) = solucion(i-1) + solucion(i - 2);
        end
    end
end