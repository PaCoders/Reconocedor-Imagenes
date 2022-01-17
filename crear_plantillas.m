%% Vamos a cargar la imagen
close all;
clear all;

data = imread("plantilla.png");

numCuadrados = 10;

encontrado = false;

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

    objetos = zeros(numCuadrados,6);
    obj = 1;
    for i = 1:length(s)
        bb = s(i).BoundingBox; % Cuadrado del objeto
        bc = s(i).Centroid;
        
        if(s(i).Area < 4000)
            objeto = [bc bb];
                
            rectangle('Position',bb,'EdgeColor','g','LineWidth',2);
        
            plot(bc(1),bc(2),'y+');
            objetos(obj,:) = objeto;
            obj = obj + 1;

        end
        if(obj == numCuadrados)
            encontrado = true;
            imagen = data;
        end

    end

    hold off;



%% Guardar imagen como base de datos
numeros = zeros(1,numCuadrados);
tamObjetos = size(objetos,2);
templates = [];

for i = 1:size(objetos,1)
    imagen_recortada = imcrop(imagen,objetos(i,3:tamObjetos));
    umbral = graythresh(imagen_recortada);
    diff_im = rgb2gray(imagen_recortada);
    diff_im = imbinarize(diff_im,umbral);
    bw = diff_im(5:end-5,5:end-5);

    if(size(bw,2) > 54)
        bw = bw(:,1:end-1);
    end

    templates = [templates bw];
    figure,imshow(bw)
end

templates = mat2cell(templates,53,[54 54 54 54 54 54 54 54 54 54]);

save('templates','templates');