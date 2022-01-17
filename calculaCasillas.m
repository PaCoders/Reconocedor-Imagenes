close all;
clear all;

%% Vamos a inicar la webcam para poder detectar el rectangulo con las celdas
vid = videoinput('winvideo');
set(vid, 'FramesPerTrigger',Inf);
set(vid, 'ReturnedColorSpace', 'rgb');
vid.frameGrabInterval = 5;

start(vid);

numCuadrados = 10;
obj = 1;

encontrado = false;

while(vid.FramesAcquired <= 200 && ~encontrado)
    data = getsnapshot(vid);
     
    % Ahora deberiamos detectar que los cuadros esten en el centro de la
    % imagen
    umbral = graythresh(data);
    diff_im = rgb2gray(data);

    diff_im = medfilt2(diff_im,[3 3]);
    diff_im = im2bw(diff_im,umbral);
    diff_im = bwareaopen(diff_im, 300);

    bw = bwlabel(diff_im,8);
    
    s = regionprops(bw, 'BoundingBox','Centroid','Area');
    imshow(data);
    hold on;

    objetos = zeros(numCuadrados,7);
    obj = 1;
    for i = 1:length(s)
        bb = s(i).BoundingBox; % Cuadrado del objeto
        bc = s(i).Centroid;
        
        % Esto lo hacemos para poder detectar los cuadrados que nos interesan
        if(s(i).Area > 5300 && s(i).Area < 9500)
            
            if(bc(2) >= 385 && bc(2) < 420)
                objeto = [bc bb s(i).Area];
                
                rectangle('Position',bb,'EdgeColor','g','LineWidth',2);
        
                plot(bc(1),bc(2),'y+');
                objetos(obj,:) = objeto;
                obj = obj + 1;
            end
        end

        if(obj == numCuadrados)
            encontrado = true;
            imagen = data;
        end

    end

    hold off;
end

stop(vid);
flushdata(vid);

%% Vamos a obtener los numeros con la imagen

    numeros = zeros(1,numCuadrados);
    tamObjetos = size(objetos,2);
    contN = 1;
    i = 1;
    blanco = false;
    
    while(i <= size(objetos,1) && ~blanco)
        imagen_recortada = imcrop(imagen,objetos(i,3:tamObjetos-1)); %Con esta imagen lo que haremos sera seleccionar el primer bit negro
        imagen_recortada = imagen_recortada - 50;
        umbral = graythresh(imagen_recortada);
        diff_im = rgb2gray(imagen_recortada);
        
        diff_im = imbinarize(diff_im,umbral);
        
        bw = bwlabel(diff_im,8);
        bw = bw(5:end-5,5:end-5);

        if(isempty(find(~bw,1)))
            blanco = true;
            cuadro_blanco = i;
        else
            
            if(isempty(find(~bw(:,round(size(bw,2)/2)),1))) % Indica que hay dos cifras
                bw1 = bw(:,1:round(size(bw,2)/2));
                bw2 = bw(:,round(size(bw,2)/2):end);
                bw1 = imresize(bw1, [53 54],'Antialiasing',true);
                bw2 = imresize(bw2, [53 54],'Antialiasing',true);
                num1 = obtenerNumero(bw1,10);
                num2 = obtenerNumero(bw2,10);
                numero = num1 + num2;
            else
                bw = imresize(bw, [53 54],'Antialiasing',true);
                numero = obtenerNumero(bw,10);
            end

            numeros(i) = double(numero);
        end

        i = i + 1;
    end

    %% Aqui calculamos la serie
    % Nos va a ser de ayuda la variable cuadro blanco para escribir en la
    % imagen
    
    [vSol] = calcularSerie(numeros);

    % Los nuevos valores lo vamos a escribir en la imagen
    
    figure, imshow(imagen);
    title("Resultado final");
    hold on;
    for i = cuadro_blanco:length(objetos)
        a = text(objetos(i,1)- 20,objetos(i,2),string(vSol(i)));
        set(a,'FontName','Arial','FontWeight','bold','FontSize',34,'Color','black');
    end

    hold off;

