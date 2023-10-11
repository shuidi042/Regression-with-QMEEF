function [TrainTime, TestTime, TrainRMSE, TestRMSE, TestMAE, RWEP]= Linear_QMEEF(train_x, train_y, test_x, test_y, regularization, lambda, kermcc, kerqmee, threshold, maxIter)
%output:
    %TrainTime: training time 
    %TestTime: test time
    %TrainRMSE: training RMSE 
    %TestRMSE: test RMSE
    %RWEP: root weight error power
%input:
    % train_x£º training input (trainNum * inputDim)
    % train_y:   training output (trainNum * 1)
    % test_x:    test input ( testNum * inputDim)
    % test_y:    test output (testNum * 1)
    % regularization: a positive constant for regularization, such as 1e-3
    % lambda: mixture parameter in QMEEF
    % kermcc and kerqmee: kernel parameters in QMEEF
    % threshold: a threshold for performing quantization operator
    % maxIter: maximum iteration number, such as 50
    
    [trainNum,~] = size(train_x);
    [testNum,~] = size(test_x);
    %% training
    tic;
    W = QMEEF_Batch(train_x, train_y, regularization, lambda, kermcc, kerqmee, threshold, maxIter);
    TrainTime=toc;
    
    %% compute the training accuracy 
    Y_train=train_x*W;
    E_train=train_y-Y_train;
    TrainRMSE=sqrt(sum(E_train.^2,1)/trainNum);
    
   %% compute the testing accuracy 
    tic;
    if isempty(test_x) && isempty(test_y)
        TestRMSE= [];
        TestMAE= [];
    else
        Y_test=test_x*W;
        E_test=test_y-Y_test;
        TestRMSE=sqrt(sum(E_test.^2,1)/testNum);
        TestMAE=sum(abs(E_test))/testNum;  %   Calculate test MAE 
    end
    %
    W_opt= [2, 1]';
    RWEP = sqrt(1/2 * norm(W - W_opt)^2);
    TestTime=toc;
    
end

