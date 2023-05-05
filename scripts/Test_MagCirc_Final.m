%Variables
mode = 0;
X = 300/1000;
LCoil = 26.3/1000;
R1Coil = 7.5/1000;
R2Coil = 17.8/1000;
nTurns = 1039;
ThCore = 10.7/1000;
WdCore = 14.6/1000;
WdGap = 2.1/1000;
LCore1 = 30.8/1000;
LCore2 = 57.9/1000;
LCoreG = 29/1000;
LGap = 2/1000;
mu_r = 1000;
BSat = 2.35;
%% Test modes
BSat
Sat_Current = MagCirc_Final(1,BSat,LCoil,R1Coil,R2Coil,nTurns,ThCore,WdCore,WdGap,LCore1,LCore2,LCoreG,0,mu_r)
%% Test
gapVect = (LGap/2:LGap/2:2*LGap);
iVect = (-X:X/9:X);
gLegend = zeros(length(iVect),1);
BVect = zeros(length(iVect),length(gapVect));
aa = [' [mm]';' [mm]';' [mm]';' [mm]'];
for j = 1:length(gapVect)
    gLegend(j)= int2str(gapVect(j));
    for i = 1:length(iVect)
        if (iVect(i) <= -Sat_Current  || iVect(i) >= Sat_Current)
            BVect(i,j) = MagCirc_Final(mode,Sat_Current*sign(iVect(i)),LCoil,R1Coil,R2Coil,nTurns,ThCore,WdCore,WdGap,LCore1,LCore2,LCoreG,gapVect(j),mu_r);
        else
            BVect(i,j) = MagCirc_Final(mode,iVect(i),LCoil,R1Coil,R2Coil,nTurns,ThCore,WdCore,WdGap,LCore1,LCore2,LCoreG,gapVect(j),mu_r);
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

gapVect2 = (LGap/10:LGap/10:LGap*4);
iVect2 = (X/4:X/4:X);
iLegend = zeros(length(iVect2),1);
BVect2 = zeros(length(gapVect2),length(iVect2));
aa2 = [' [mA]';' [mA]';' [mA]';' [mA]'];
for j2 = 1:length(iVect2)
    iLegend(j2)= int2str(iVect2(j2));
    for i2 = 1:length(gapVect2)
        if (iVect2(j2) <= -Sat_Current  || iVect2(j2) >= Sat_Current)
            BVect2(i2,j2) = MagCirc_Final(mode,Sat_Current*sign(iVect2(j2)),LCoil,R1Coil,R2Coil,nTurns,ThCore,WdCore,WdGap,LCore1,LCore2,LCoreG,gapVect2(i2),mu_r);
        else
            BVect2(i2,j2) = MagCirc_Final(mode,iVect2(j2),LCoil,R1Coil,R2Coil,nTurns,ThCore,WdCore,WdGap,LCore1,LCore2,LCoreG,gapVect2(i2),mu_r);
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