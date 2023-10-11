function [dicMem, nbMem] = MVQ(E, epsilon, sigma)
%output
    % dicMem is a vector to store code words obtained with quantization operator 
    % nbMem is another vector to store coefficients obtained with quantization operator 
%input:
    %E is a vector to store error samples
    %epsilon is the quantization threshold
    %sigma is the kernel size
    
    trainNum = size(E, 1);
    %%%%% modified quantization operator adopted in our paper
    dicMem=[]; %  a set storing dictionary members (dictionary of error)
    nbMem=[]; % a set storing the number of each dictionary member family (number of dictionary member£©
    for i=1:1:trainNum
        if i==1
            dicMem=[dicMem,E(i)];
            nbMem=[nbMem,1];
        else
            E_temp=(dicMem-repmat(E(i),size(dicMem,1),size(dicMem,2))).^2; %square of the distance
            [minDis,minLocal]=min(E_temp);       
            if minDis>epsilon^2   %square of the threshold
                dicMem=[dicMem,E(i)];
                nbMem=[nbMem,1];
            else     
                nbMem(minLocal)= nbMem(minLocal)+1*kernelDiffer(dicMem(minLocal), E(i), sigma);        
            end
        end
    end
end


function y1 =  kernelDiffer(x1, x2, kerpar1)   
     y1  = exp(- sum((x1 - x2).^2) / (2*kerpar1^2) );   
end