%######################################################
%% the code to generate noise sequence mentioned in the paper 
function ns = noise_regression(M, a, nType)
%output:
    %ns£º the obtained noise sequence
%input:
    % M£º the length of the noise sequence
    % a:   the ratio of outliers in noise sequence
    % nType: noise type (four cases are considered: 'type1', 'type2', 'type3' or 'type4')

    switch nType
       case 'type1'
         % ns1:  noise B to model outliers, and is set to be drawn from a Gaussian distribution with zero-mean and relatively large variance
         M1 = round(M*a);
         ns1 = 0+ sqrt(100)*randn(1, M1);
         % ns2: noise A to model the inner noise, and is set to be drawn from a mixed Gaussian distribution in this case
         M2 = M - M1; 
         b = 1/3;
         N=round(M2*b);
         s1= -5 + sqrt(0.04)*randn(1,N);
         s2=  3 + sqrt(0.04)*randn(1,M2-N);
         ns2=[s1,s2];
         % ns: mixed noise 
         ns = [ns1, ns2]';
         index=randperm(M);
         ns=ns(index,:);
    end
end
