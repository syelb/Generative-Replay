% Compute ordinary least squares solution based on data, design matrix (dm)
% and contrast matrix (cm)
% data is time x variable
% dm is time x explanatory variables (design matrix)
% Contrast matrix should be orthogonal
% 
% This is based on the more general ols function by Tim Behrens

function [betas,var_betas,tstat_betas]=ols_PS(data,dm,cm)

if(size(data,1)~=size(dm,1))
  error('DATA and DESIGN MATRIX have different number of time points');
elseif(size(dm,2)~=size(cm,2))
  error('DESIGN MATRIX and CONTRAST MATRIX have different number of predictors')
end

pdm   = pinv(dm); % pseudoinverse of design matrix
pe    = pdm*data; 
betas = cm*pe;

if(nargout>1) % get variance of estimates
    
    prevar = diag(cm*pdm*pdm'*cm');
    tR     = trace(eye(size(dm,1))-dm*pdm);

    res   = data-dm*pe; % get residuals
    sigsq = sum(res.*res/tR);
    
    var_betas = prevar*sigsq;
    
    if(nargout>2) % get t_stats of estimates
        
        tstat_betas = betas./sqrt(var_betas);
        
    end
    
end