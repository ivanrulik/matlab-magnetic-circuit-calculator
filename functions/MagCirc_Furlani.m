function [Out] = MagCirc_Furlani(mode,X,mu_r,n,Ag,Ac,lg,lc)
mu_0 = 1.257e-6;
if (mode == 0) 
    Out = (X*mu_0*n)/((Ag/Ac)*(mu_0/mu_r)*lc+lg); %B
elseif (mode == 1)
    Out = X*((Ag/Ac)*(mu_0/mu_r)*lc+lg)/(mu_0*n); %i
else
    fprintf('1 finds B field \n 0 finds current i \n')
end

