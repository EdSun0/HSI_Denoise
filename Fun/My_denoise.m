function [E_Img]= My_denoise4_N( N_Img, Par )
E_Img       =  N_Img;                                      
[H, W, B]   =  size(E_Img);
  N         =  H * W;
tol         = 1e-6;
bet=1;
lambd=0.05;
 mu=0.2;
%% First step: spectral dimension reduction 
   Y          =  reshape(E_Img, N, B)';
   normY  = norm(Y,'fro'); 
sizeD = size(Y);
S     = zeros(sizeD);
V     = zeros(sizeD);
G     = zeros(sizeD);
   [w, Rw]    = estNoise(Y,'additive','off');
   Rw_ori     = Rw;
   Y          = sqrt(inv(Rw_ori))*Y;
   [w, Rw]    = estNoise(Y,'additive','off');
   [k, E]     = hysime(Y,w,Rw,'on');
   k_subspace = Par.k_subspace;
   E         =  E(:,1:k_subspace);
   S_Img     =  reshape((E'*Y)', H, W, k_subspace);
%% non-local patch grouping and noise estimation
    [Spa_Img, Spa_Wei]   =  WS_Denoising(S_Img, Par);
%% 
    Z = reshape(Spa_Img./Spa_Wei, N, k_subspace);
    Spa_Img = reshape(Spa_Img, N, k_subspace);
    Spa_Wei = reshape(Spa_Wei, N, k_subspace);
%% Update ADMM
     k = 1;
     while k <=40 
        %% update Z
        T1=Y-S-G;
        V2=V/bet;
        Z = (Par.lam*Spa_Img + (E'*(T1+V2))') ./ (Par.lam*Spa_Wei + 1);
        %% update E
        E_est   = (T1 + V2)*Z;
        [U,~,V1] = svd(E_est,'econ');
        E = U*V1';
        X = E*Z';
        %% update G
         G=bet*(Y-X-S)/(bet+2*mu)+V/(bet+2*mu);
        %% update S    
        T2=Y- X - G;
        temp = T2 +  V2;
%         S= Generalized_Soft_Thresholding(temp , lambd,1/2);         
        S= Logarithm(temp , lambd,1/2);
%   S = sign(Y-E*Z').*max(0,abs(Y-E*Z')-(Par.alpha));
        %% update V
        V = V + bet*(T2-S);
        k = k + 1;
        %% Stop criterion  
        leq = Y-X-S-G;
        stop = norm(leq,'fro')/normY;
          if stop<=tol
              fprintf(' stop iter = %d\n',k)
          break;
          end
        end
    E_Img = E*Z';
    E_Img = sqrt(Rw_ori)*E_Img;
    E_Img = reshape(E_Img', H, W, B);
    end
