function [Out] = ThickCoil_Fiorillo(mode,X,n,L,R1,R2)

%n = 100;
%n_0 = 30.3030*1000;
%i_c = 1;
%L = 33/1000;
%R1 = 14.6/1000;
%R2 = 22/1000;

%mu_0 = 1.257e-6;
%mu_r = 100000;

if (mode == 0)
    %H
    natL = log(((2*R2)+sqrt((4*(R2^2))+(L^2)))/((2*R1)+sqrt((4*(R1^2))+(L^2))));
    Out = (n*X*natL)/(2*(R2-R1));
elseif (mode == 1)
    %i
    natL = log(((2*R2)+sqrt((4*(R2^2))+(L^2)))/((2*R1)+sqrt((4*(R1^2))+(L^2))));
    Out = (X*2*((R2)-(R1)))/(natL*n);
else
    fprintf('1 finds H field \n 0 finds current i \n')
    
end

