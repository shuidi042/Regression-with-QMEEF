%% The code to implement the fixed-point iterative algorithm under the Quantized Minimum Error Entropy with  with Fiducial Points (QMEEF)
function W = QMEEF_Batch(U, Y, regularization, lambda, kermcc, kerqmee, epsilon, maxIter)
%output:
    % W: the weight vector needed to be optimized
%input:
    % U： training input (trainNum * inputDim)
    % Y:  training output (trainNum * 1)
    % regularization: a positive constant for regularization, such as 1e-3
    % lambda: mixture parameter in QMEEF
    % kermcc and kerqmee: kernel parameters in QMEEF
    % epsilon: a threshold to perform quantization operator
    % maxIter: maximum number of iterations
    
    [trainNum, dimension] = size(U);
    class = size(Y,2);
    W = zeros(dimension,class);
    temp = regularization *eye(dimension);
    %% the additional kernel size to perform quantization operator is directly set the same as kerqmee in our experiments
    sigma_q = kerqmee; 
    for iter = 1: maxIter
       %% compute the errors
        W1=W;
        EE=Y-U*W;
       %% quantized method (see Algoritm 1 of the paper)
        [dicMem, nbMem] = MVQ(EE, epsilon, sigma_q);
       %% compute tau1, tau2, and tau3: fast method (only one "for.. end" is involved)
        tau1 =  zeros(trainNum, 1);
        tau2 =  zeros(trainNum, 1);
        for i=1:1:size(nbMem,2)
            tmp = nbMem(i)*exp(-(EE-dicMem(i)).^2/(2*kerqmee^2))/sqrt(2*pi*kerqmee^2);
            tau1 = tau1 + tmp;
            tau2 = tau2 + dicMem(i) * tmp;
        end
        tau1 = lambda/(kerqmee^2) * tau1;
        tau2 = lambda/(kerqmee^2) * tau2;
        tau3 = (1-lambda)/(kermcc^2) * exp(-EE.^2/(2*kermcc^2))/sqrt(2*pi*kermcc^2);
        clear E dicMem nbMem
       %% compute LAM and TT
        LAM = spdiags(tau1 + tau3, 0, trainNum, trainNum); %For reducing the memory expense
        clear  tmp2;
        TT = tau2;
        clear  tau1 tau2 tau3;
       %% compute the weights
        R = U'* LAM * U + temp;
        P = U'* LAM * Y - U'* TT;
        clear LAM  TT
        W = R\P;
        clear R P
        
       %% stopping criterion
        if norm(W-W1)^2/norm(W1)^2<=1e-10 
            break;
        end                     
    end
end






