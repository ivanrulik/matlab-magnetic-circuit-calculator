function [Out] = MagCirc_Final(mode,X,LCoil,R1Coil,R2Coil,nTurns,ThCore,WdCore,WdGap,LCore1,LCore2,LCoreG,LGap,mu_r)
mu_0 = 1.257e-6;
%INPUT VARIABLES_________________
%mode determines the main input and output of the function by 0 or 1
%X_0 is source current
%X_1 is Bfield on gap
%LCoil is the length of the coil
%R1coil and R2coil are the inner and outter radius of the coil
%nTurns is the number of turns on the coil
%Thcore is the thickness of the core and gap
%WdCore, WdGap are the widths of the core section and gap section (coregap section has the same width as the gap section)
%LCore1, LCore2, LCoreG, LGap are the lengths of the core, coregap and gap sections
%mu_r is the relative permeability of the core material
%INTERNAL VARIABLES______________
%ACore, AGap (=ACoreG) is the cross-sectional area of the core, coregap and gap sections
ACore = ThCore*WdCore;
ACoreG = ThCore*WdGap;
AGap = ACoreG;
%RCore, RCoreG, RGap, and REqv are the reluctance of the core, coregap, gap and equivalent of the whole circuit
RCore = (LCore1+(LCore2*2))/(mu_0*mu_r*ACore);
RCoreG = (LCoreG*2)/(mu_0*mu_r*ACoreG);
RGap = (LGap)/(mu_0*AGap);
REqv = RCore + RCoreG + RGap;
%HCoil is the magnetic field for thick coils
%VmCoil is the magnetomotive force of the coil

%OUTPUT VARIABLES________________
%Out0 is Bfield on gap
%Out1 is source current
if (mode == 0)%X is current i and out is BField
    lnCoil = log(((2*R2Coil)+sqrt((4*R2Coil^2)+(LCoil^2)))/((2*R1Coil)+sqrt((4*R1Coil^2)+(LCoil^2))));
    HCoil = (nTurns*X*lnCoil)/(2*(R2Coil-R1Coil));
    VmCoil = HCoil*LCoil;
    
    Out = (VmCoil)/(AGap*REqv); %B
elseif (mode == 1)%X is BField and Out is current i
    lnCoil = log(((2*R2Coil)+sqrt((4*R2Coil^2)+(LCoil^2)))/((2*R1Coil)+sqrt((4*R1Coil^2)+(LCoil^2))));
    altHCoil = (nTurns*lnCoil)/(2*(R2Coil-R1Coil));
    
    Out = (X*AGap*REqv)/(LCoil*altHCoil); %i
else
    fprintf('1 finds B field \n 0 finds current i \n')
end