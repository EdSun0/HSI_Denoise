function  [L] =  TWNNM( Y, Par, NSig)
%% 
dim  = size(Y);
L    = Y;
% for i = 1:Par.iter
    for mode = 1:3
        Y_mode = Unfold(L, dim, mode);
        Y_mode = WSNM(Y_mode, Par.c1, Par.p, Par.w(mode), NSig);
%         Y_mode  = WNNM(Y_mode, Par.c1, NSig);
        L      = Fold(Y_mode, dim, mode);
    end
end
%%
% maxIter =10;
% % errList = zeros(maxIter, 1);
% % if isempty(initial)
% %     Y(mark) = 0; %mean(Y(logical(1-ind)));
% % else
% %     Y(mark) = initial(mark);
% % end
% 
% dim = size(Y);
% M = cell(ndims(Y), 1);
% for i = 1:ndims(Y)
%     M{i} = Y;
% end
% X = Y;
% Xsum = zeros(dim);
% Ysum = zeros(dim);
% alpha = ones(1,3) ./ NSig;
% beta  = ones(1,3);
% Csum = alpha + beta;
% for k = 1:maxIter
%     Xsum = Xsum * 0;
%     Ysum = Ysum * 0;
%     for i = 1:ndims(Y)
%         site = circshift(dim, [1-i, 1-i]);
%         Mpro = alpha(i)/Csum(i) * X + beta(i)/Csum(i) * Y;
% %         [mid, D(i)] = Pro2TraceNorm(reshape(shiftdim(Mpro,i-1), dim(i), []),...
% %             gamma(i)/Csum(i));
% %         [mid]       = WSNM(reshape(shiftdim(Mpro,i-1), dim(i), []), Par.c1, Par.p, Par.w(i), 1);
%         [mid]       = WNNM(reshape(shiftdim(Mpro,i-1), dim(i), []), Par.c1, Par.w(i)/(Csum(i)*dim(2)));
%         M{i} = shiftdim(reshape(mid, site), -i+1+ndims(Y));
%         Xsum = Xsum + alpha(i)*M{i};
%         Ysum = Ysum + beta(i)*M{i};
%     end
%     X = Xsum / (sum(alpha) + 1e-10);
%     Ysum = Ysum / (sum(beta) + 1e-10);
% %     errList(k) = norm(Y(mark)-Ysum(mark));
% %     Y(mark) = Ysum(mark);
% end
% return;

function [X] = Unfold( X, dim, i )
X = reshape(shiftdim(X,i-1), dim(i), []);
end
function [X] = Fold(X, dim, i)
dim = circshift(dim, [1-i, 1-i]);
X = shiftdim(reshape(X, dim), length(dim)+1-i);
end
