            %Fiorillo Thick coil
            mode = 0;
            wire_diam = 0.5/1000;
            R2 = (17.8)/1000;
            R1 = (7.5)/1000;
            L = (26.3)/1000;
            nth = 1039;
            
            if(mode == 0)
                X = 570/1000;
                HD = ThickCoil_Fiorillo(mode,X,nth,L,R1,R2);
                
            elseif(mode == 1)
                X = 150;
                IDTh = ThickCoil_Fiorillo(mode,X,nth,L,R1,R2)/1000;
            end

            %Furlani MAg Circuit
            iF = 570/1000;
            lg = 2/1000;
            mu_r = 1000;
            n = 1039;
            lc = 357.3/1000;
            wc = 14.6/1000;
            wg = 2.1/1000;
            tc = 10.7/1000;
            tg = 10.7/1000;
            Ag = wg*tg;
            Ac = wc*tc;
            mu_0 = 1.25e-6;
            mode_d = 0;
            
            BD = 0;
            
            if(mode_d == 0)
                X = iF;
                HD = ThickCoil_Fiorillo(mode,X,nth,L,R1,R2);
                BD = MagCirc_Furlani(mode_d,HD*L,mu_r,n,Ag,Ac,lg,lc)*1000;    
            elseif(mode_d == 1)
                X = BD/1000;
                ID = MagCirc_Furlani(mode_d,X,mu_r,n,Ag,Ac,lg,lc)*1000;
            end
            
            gapVect = (lg/2:lg/2:2*lg);
            iVect = (-iF:iF/9:iF);
            gLegend = zeros(length(iVect),1);
            BVect = zeros(length(iVect),length(gapVect));
            aa = [' [mm]';' [mm]';' [mm]';' [mm]'];
            for j = 1:length(gapVect)
                gLegend(j)= int2str(gapVect(j));
                for i = 1:length(iVect)
                    HD = ThickCoil_Fiorillo(mode,iVect(i),nth,L,R1,R2);
                    if(HD >= 700 || HD <= -700)
                        BVect(i,j) = MagCirc_Furlani(0,700*sign(HD)*L,mu_r,1,Ag,Ac,gapVect(j),lc);
                    else
                        BVect(i,j) = MagCirc_Furlani(0,HD*L,mu_r,1,Ag,Ac,gapVect(j),lc);
                    end
                end
            end
            figure(1)
            subplot(1,2,1)
            plot(iVect*1000,BVect*1000);
            title('B-Field, Air Gap Length & Source Current');
            legend([num2str((gapVect*1000)'),aa]); 
            xlabel('Source Current [mA]');
            ylabel('Magnetic Flux Density B [mT]');
            grid on;
            
            gapVect2 = (lg/10:lg/10:lg*4);
            iVect2 = (iF/4:iF/4:iF);
            iLegend = zeros(length(iVect2),1);
            BVect2 = zeros(length(gapVect2),length(iVect2));
            aa2 = [' [mA]';' [mA]';' [mA]';' [mA]'];
            for j2 = 1:length(iVect2)
                iLegend(j2)= int2str(iVect2(j2));
                for i2 = 1:length(gapVect2)
                    HD = ThickCoil_Fiorillo(mode,iVect2(j2),nth,L,R1,R2);
                    if(HD >= 100 || HD <= -100)
                        BVect2(i2,j2) = MagCirc_Furlani(0,100*sign(HD)*L,mu_r,1,Ag,Ac,gapVect2(i2),lc);
                    else 
                        BVect2(i2,j2) = MagCirc_Furlani(0,HD*L,mu_r,1,Ag,Ac,gapVect2(i2),lc);
                    end
                end
            end
            subplot(1,2,2)
            plot(gapVect2*1000,BVect2*1000)
            title('B-Field, Air Gap Length & Source Current')
            legend([num2str((iVect2*1000)'),aa2])
            xlabel('Air Gap Length [mm]'), 
            ylabel('Magnetic Flux Density B [mT]')
            grid on;