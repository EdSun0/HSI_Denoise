function  [par]=ParSet(nSig, subspace)

%% Patch-based Iteration Parameters
par.nSig        =   nSig;                               % Variance of the noise image
par.SearchWin   =   40;
par.step        =   3;

par.c1          =   2000*sqrt(2);                       % Constant num for multispectral image

par.k_subspace = subspace;
par.iter       = 1;
par.p          = 1;
par.alpha      = 0.2;
par.lam        = 0.01;
par.Innerloop_X= 70;
par.w          = [0.05 0.95 0.01];

%% Patch and noise Parameters
if nSig<=0.2
    par.patsize       =   5;
    par.patnum        =   200;
    par.Iter          =   2;
    par.lamada        =   0.52;     
elseif nSig <= 0.3
    par.patsize       =   7;
    par.patnum        =   200;
    par.Iter          =   2;
    par.lamada        =   0.56; 
elseif nSig <= 0.4
    par.patsize       =   7;
    par.patnum        =   200;
    par.Iter          =   2;
    par.lamada        =   0.56; 
else
    par.patsize       =   9;
    par.patnum        =   200;
    par.Iter          =   2;
    par.lamada        =   0.58; 
end 
end


