function [psnr, ssim, ergas, msam] = MSIQA(imagery1, imagery2)

%==========================================================================
% Evaluates the quality assessment indices for two MSIs.
%
% Syntax:
%   [psnr, ssim, fsim, ergas, msam ] = MSIQA(imagery1, imagery2)
%
% Input:
%   imagery1 - the reference MSI data array
%   imagery2 - the target MSI data array
% NOTE: MSI data array  is a M*N*K array for imagery with M*N spatial
%	pixels, K bands and DYNAMIC RANGE [0, 255]. If imagery1 and imagery2
%	have different size, the larger one will be truncated to fit the
%	smaller one.
%
% Output:
%   psnr - Peak Signal-to-Noise Ratio
%   ssim - Structure SIMilarity
%   fsim - Feature SIMilarity
%   ergas - Erreur Relative Globale Adimensionnelle de Synth��se
%           (ERGAS, dimensionless global relative error of synthesis)
%   msam - Mean Spectral Angle Mapper
%
% See also StructureSIM, FeatureSIM, ErrRelGlobAdimSyn and SpectAngMapper
%
% by Yi Peng
%==========================================================================

[m, n, k] = size(imagery1);
[mm, nn, kk] = size(imagery2);
m = min(m, mm);
n = min(n, nn);
k = min(k, kk);
imagery1 = imagery1(1:m, 1:n, 1:k);
imagery2 = imagery2(1:m, 1:n, 1:k);

psnr = zeros(k, 1);
ssim = zeros(k, 1);
for i = 1:k
    psnr(i) =  10*log10(255^2/mse(imagery1(:, :, i) - imagery2(:, :, i)));
    ssim(i) =  ssim_index(imagery1(:, :, i), imagery2(:, :, i));
end
ergas = ErrRelGlobAdimSyn(imagery1,imagery2);
msam  = SAM3D(imagery1/255, imagery2/255);

