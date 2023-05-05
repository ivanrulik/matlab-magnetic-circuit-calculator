%% Calculador de densidad de campo magnetico & corriente
% Para los calculos se parte del analisis de los circuitos magneticos los 
% cuales siguen normas similares a la leyes de Kirchoff para voltajes y
% corrientes.
% Ivan Rulik - Uniandes
% 20/03/19
clc;
clear;
close all;
%% Guia visual
figure(1)
rectangle('Position',[1e-3 0 8e-3 1e-3],'Linewidth',1,'EdgeColor','r','Facecolor','r'); %longitud nucleo
rectangle('Position',[1e-3 5e-3 8e-3 1e-3],'Linewidth',1,'EdgeColor','r','Facecolor','r'); %longitud nucleo
rectangle('Position',[0 0 1e-3 6e-3],'Linewidth',1,'EdgeColor','b','Facecolor','b'); %nucleo
rectangle('Position',[9e-3 0 1e-3 2.5e-3],'Linewidth',1,'EdgeColor','y','Facecolor','y'); %longitud gap
rectangle('Position',[9e-3 3.5e-3 1e-3 2.5e-3],'Linewidth',1,'EdgeColor','y','Facecolor','y'); %longitud gap
title('Electroiman nucleo tipo C');
xlabel('medidas de ejemplo [m]');
ylabel('medidas de ejemplo [m]');
%% UI
order = input('Ingreso manual de datos [Y/N]: ','s');
plotGen = input('Generar graficos con valores minimos y maximos de largo del gap? [Y/N]: ','s');
%% Proceso
if(order == 'Y')
    desc = input('Despejar Corriente o Densidad de flujo de campo [i/B]: ','s');
    
    mu_0 = 1.25e-6; %permeabilidad en el vacio en Henrys/metro
    mu_r_nucleo = input('\n\nPermeabilidad relativa del nucleo?  \n > ');
    w= input('\n\nEspesor del nucleo? [m] \n > ');
    da= input('\n\nLargo seccion del nucleo? [m] \n > ');
    wc= input('\n\nAncho seccion del nucleo? [m] \n > ');
    g= input('\n\nLargo seccion del gap? [m] \n > ');
    wg= input('\n\nAncho seccion del gap? [m] \n > ');
    n= input('\n\nNumero de vueltas en bobina?  \n > ');
    if(desc == 'i')
        B= input('\n\nDensidad de campo magnetico deseada en el gap? [T] \n > ');
    elseif(desc == 'B')
        iF= input('\n\nCorriente con la que se alimentara la bobina? [A] \n > ');
    end
    %Calculos
    Ac = w*wc; 
    Ag = w*wg; 
    Rc = da/(mu_0*mu_r_nucleo*Ac); 
    Rg = g/(mu_0*Ag);
    if(desc == 'i')
        %Arnold & Garraud
        ia = B*((da/mu_r_nucleo)+g)/(n*mu_0); 
        %Furlani
        iF = B*((Ag/Ac)*(mu_0/mu_r_nucleo)*da+g)/(mu_0*n);
    elseif(desc == 'B')
        B = (iF*mu_0*n)/((Ag/Ac)*(mu_0/mu_r_nucleo)*da+g); 
    end
    sprintf('\nLa corriente necesaria es de %3.5g A\n',iF)
    sprintf('\nPara generar un campo de %3.5g T\n',B)
        if (plotGen == 'Y')
            gapVect = (g:g/2:g*10);
            iVect = (0:iF/9:iF);
            iLegend = zeros(length(iVect),1);
            BVect = zeros(length(iVect),length(gapVect));
            aa = [' [A]';' [A]';' [A]';' [A]';' [A]';' [A]';' [A]';' [A]';' [A]';' [A]'];
            for j = 1:length(iVect)
                for i = 1:length(gapVect)
                    BVect(i,j) = (iVect(j)*mu_0*n)/((Ag/Ac)*(mu_0/mu_r_nucleo)*da+gapVect(i));
                end
            end
            plot(gapVect*1000,BVect*1000),title('Relation of B-Field, Air Gap Length & Source Current'),legend([num2str(iVect'),aa]) , xlabel('Air Gap Length [mm]'), ylabel('Magnetic Flux Density B [mT]'), grid on
        end
elseif(order == 'N')      
    %Dimensiones [m]Revisar dimensiones.jpg:
    l = 61e-3;
    la = 29e-3;
    lb = la;
    lc = 33.5e-3;
    d = 60e-3;
    da = 32e-3;
    g = 2e-3;
    w = 10e-3;%espesor del nucleo
    wc = 31.5e-3;
    wg = 2e-3;
    %Constantes:
    mu_0 = 1.25e-6; %permeabilidad en el vacio en Henrys/metro
    mu_r_nucleo = 200000; %permeabilidad relativa del hierro
    n = 1000; %numero de vueltas bobina
    i = 0; % corriente que se desea despejar
    B = 200e-3; %campo magnetico a generar en Teslas
    %Calculos
    Ac = w*wc; %area transversal en metros cuadrados
    Ag = w*wg; %area transversal en metros cuadrados
    Rc = da/(mu_0*mu_r_nucleo*Ac); %reluctancia del nucleo
    Rg = g/(mu_0*Ag); %reluctancia del gap
    %Arnold & Garraud
    ia = B*((da/mu_r_nucleo)+g)/(n*mu_0); %corriente [A] requerida para generar el campo en las dimensiones dadas
    %Furlani
    iF = B*((Ag/Ac)*(mu_0/mu_r_nucleo)*da+g)/(mu_0*n);%corriente [A] requerida para generar el campo en las dimensiones dadas 
    %B = (iF*mu_0*n)/((Ag/Ac)*(mu_0/mu_r_nucleo)*da+g);
    sprintf('\nLa corriente necesaria es de %3.5g A\n',iF)
    sprintf('\nPara generar un campo de %3.5g T\n',B)
    if (plotGen == 'Y')
        gapVect = (g:g/2:g*10);
        iVect = (0:iF/9:iF);
        iLegend = zeros(length(iVect),1);
        BVect = zeros(length(iVect),length(gapVect));
        aa = [' [A]';' [A]';' [A]';' [A]';' [A]';' [A]';' [A]';' [A]';' [A]';' [A]'];
        for j = 1:length(iVect)
            iLegend(j)= int2str(iVect(j));
            for i = 1:length(gapVect)
                BVect(i,j) = (iVect(j)*mu_0*n)/((Ag/Ac)*(mu_0/mu_r_nucleo)*da+gapVect(i));
            end
        end
        plot(gapVect*1000,BVect*1000),title('Relation of B-Field, Air Gap Length & Source Current'),legend([num2str(iVect'),aa]) , xlabel('Air Gap Length [mm]'), ylabel('Magnetic Flux Density B [mT]'), grid on
    end
end