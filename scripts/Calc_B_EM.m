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
rectangle('Position',[0 0 90 10],'Linewidth',1,'EdgeColor','r','Facecolor','r'); %longitud nucleo
rectangle('Position',[0 50 90 10],'Linewidth',1,'EdgeColor','r','Facecolor','r'); %longitud nucleo
rectangle('Position',[0 10 10 40],'Linewidth',1,'EdgeColor','b','Facecolor','b'); %nucleo
rectangle('Position',[90 0 10 25],'Linewidth',1,'EdgeColor','y','Facecolor','y'); %longitud gap
rectangle('Position',[90 35 10 25],'Linewidth',1,'EdgeColor','y','Facecolor','y'); %longitud gap
title('Electromagnet C type core');
xlabel('Example length [mm]');
ylabel('Example width [mm]');
grid on
%% UI
order = input('Ingreso manual de datos [Y/N]: ','s');
plotGen = input('Generar graficos? [Y/N]: ','s');
%% Proceso
if(order == 'Y')    
    desc = input('Despejar Corriente o Densidad de flujo de campo [i/B]: ','s');
    if(desc == 'i')
        B= input('\n\nDensidad de campo magnetico deseada en el gap? [T] \n > ');
    elseif(desc == 'B')
        iF= input('\n\nCorriente con la que se alimentara la bobina? [A] \n > ');
    end
    coil_order = input('Despejar bobina [Y/N]: ','s');
    mu_0 = 1.257e-6; %permeabilidad en el vacio en Henrys/metro
    mu_r_nucleo = input('\n\nPermeabilidad relativa del nucleo?  \n > ');
    w= input('\n\nEspesor del nucleo? [mm] \n > ')/1000;
    da= input('\n\nLargo seccion del nucleo? [mm] \n > ')/1000;
    wc= input('\n\nAncho seccion del nucleo? [mm] \n > ')/1000;
    g= input('\n\nLargo seccion del gap? [mm] \n > ')/1000;
    wg= input('\n\nAncho seccion del gap? [mm] \n > ')/1000;
    n= input('\n\nNumero de vueltas en bobina?  \n > ');
    %Calculos
    Ac = w*wc; 
    Ag = w*wg; 
    Rc = da/(mu_0*mu_r_nucleo*Ac); 
    Rg = g/(mu_0*Ag);
    if(desc == 'i')
        %Arnold & Garraud
        ia = B*((da/mu_r_nucleo)+g)/(n*mu_0);
        %AWG decision
        if(coil_order == 'Y')
            load('AWG.mat');
            R1_b = input('\n\nRadio interno? [mm] \n > ');
            R2_b = input('\n\nRadio externo? [mm] \n > ');
            L_b = input('\n\nLongitud? [mm] \n > ');
            AWG{1,8} = 'Corriente consumida [A]';
            for v = 1:length(AWG)-1
                AWG{v+1,4} = round(L_b/AWG{v+1,2});
                AWG{v+1,5} = round((2*(R2_b-R1_b))/AWG{v+1,2});
                AWG{v+1,6} = round(AWG{v+1,4}*AWG{v+1,5});
                AWG{v+1,7} = AWG{v+1,6}*pi*R2_b/1000;
                %AWG{v+1,8} = B*((Ag/Ac)*(mu_0/mu_r_nucleo)*da+g)/(mu_0*AWG{v+1,6});
                AWG{v+1,8} = MagCirc_Furlani(0,B,mu_r_nucleo,AWG{v+1,6},Ag,Ac,g,da);
                AWG{v+1,9} = ThickCoil_Fiorillo(0,B/(mu_0*mu_r_nucleo),AWG{v+1,6},L_b/1000,R1_b/1000,R2_b/1000);
            end    
        end
        openvar('AWG')
        %Furlani
        %iF = B*((Ag/Ac)*(mu_0/mu_r_nucleo)*da+g)/(mu_0*n);
        iF = MagCirc_Furlani(0,B,mu_r_nucleo,n,Ag,Ac,g,da);
    elseif(desc == 'B')
        %AWG decision
        if(coil_order == 'Y')
            load('AWG.mat');
            R1_b = input('\n\nRadio interno? [mm] \n > ');
            R2_b = input('\n\nRadio externo? [mm] \n > ');
            L_b = input('\n\nLongitud? [mm] \n > ');
            AWG{1,8} = 'Generated Magnetic Flux Density [T]';
            for v = 1:length(AWG)-1
                AWG{v+1,4} = round(L_b/AWG{v+1,2});
                AWG{v+1,5} = round((2*(R2_b-R1_b))/AWG{v+1,2});
                AWG{v+1,6} = round(AWG{v+1,4}*AWG{v+1,5});
                AWG{v+1,7} = AWG{v+1,6}*pi*R2_b/1000;
                %AWG{v+1,8} = (iF*mu_0*AWG{v+1,6})/((Ag/Ac)*(mu_0/mu_r_nucleo)*da+g);
                AWG{v+1,8} = MagCirc_Furlani(1,iF,mu_r_nucleo,AWG{v+1,6},Ag,Ac,g,da);
                AWG{v+1,9} = ThickCoil_Fiorillo(1,iF,AWG{v+1,6},L_b/1000,R1_b/1000,R2_b/1000);
                
            end    
        end
        openvar('AWG')
        %Furlani
        %B = (iF*mu_0*n)/((Ag/Ac)*(mu_0/mu_r_nucleo)*da+g);
        B = MagCirc_Furlani(1,iF,mu_r_nucleo,n,Ag,Ac,g,da);
    end
    sprintf('\nLa corriente necesaria es de %3.5g A\n',iF)
    sprintf('\nPara generar un campo de %3.5g T\n',B)
%%
elseif(order == 'N')      
    %Dimensiones [m]Revisar dimensiones.jpg:
    l = 61e-3;
    la = 29e-3;
    lb = la;
    lc = 33.5e-3;
    d = 60e-3;
    da = 32e-3;
    g = 2e-3; %2e-3
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
    %Test 
    %AWG
    load('AWG.mat');
    R1_b = 5; %inner radius in mm
    R2_b = 9; %outter radius in mm
    L_b = 18; %coil length in mm
    AWG{1,8} = 'Current [A]';
    for v = 1:length(AWG)-1
        AWG{v+1,4} = round(L_b/AWG{v+1,2});
        AWG{v+1,5} = round((2*(R2_b-R1_b))/AWG{v+1,2});
        AWG{v+1,6} = round(AWG{v+1,4}*AWG{v+1,5});
        AWG{v+1,7} = AWG{v+1,6}*pi*R2_b/1000;
        %AWG{v+1,8} = B*((Ag/Ac)*(mu_0/mu_r_nucleo)*da+g)/(mu_0*AWG{v+1,6});
        AWG{v+1,8} = MagCirc_Furlani(0,B,mu_r_nucleo,AWG{v+1,6},Ag,Ac,g,da);
        %AWG{v+1,9} = (B*2*((R2_b/1000)-(R1_b/1000)))/((mu_0*mu_r_nucleo)*log(((2*R2_b/1000)+sqrt((4*(R2_b/1000)^2)+(L_b/1000)^2))/(2*(R1_b/1000)+sqrt((4*(R1_b/1000)^2)+(L_b/1000)^2)))*AWG{v+1,6});
        AWG{v+1,9} = ThickCoil_Fiorillo(0,B/(mu_0*mu_r_nucleo),AWG{v+1,6},L_b/1000,R1_b/1000,R2_b/1000);
    end
    %
    %Furlani
    %iF = B*((Ag/Ac)*(mu_0/mu_r_nucleo)*da+g)/(mu_0*n);%corriente [A] requerida para generar el campo en las dimensiones dadas 
    iF = MagCirc_Furlani(0,B,mu_r_nucleo,n,Ag,Ac,g,da);
    %B = (iF*mu_0*n)/((Ag/Ac)*(mu_0/mu_r_nucleo)*da+g);
    openvar('AWG')
    sprintf('\nLa corriente necesaria es de %3.5g A\n',iF)
    sprintf('\nPara generar un campo de %3.5g T\n',B)
end

%% curve of B field vs airgap length vs current
if (plotGen == 'Y')
    gapVect = (g/2:g/2:2*g);
    iVect = (-iF:iF/9:iF);
    iLegend = zeros(length(iVect),1);
    BVect = zeros(length(iVect),length(gapVect));
    aa = [' [mm]';' [mm]';' [mm]';' [mm]'];
    for j = 1:length(gapVect)
        iLegend(j)= int2str(gapVect(j));
        for i = 1:length(iVect)
            BVect(i,j) = (iVect(i)*mu_0*n)/((Ag/Ac)*(mu_0/mu_r_nucleo)*da+gapVect(j));
        end
    end
    plot(iVect*1000,BVect*1000),title('B-Field, Air Gap Length & Source Current'),legend([num2str(gapVect'*1000),aa]) , xlabel('Source Current [mA]'), ylabel('Magnetic Flux Density B [mT]'), grid on
end

%%actualizar X y Y con corrinete y densidad de flujo de campo magnetic 