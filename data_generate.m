function [train_x, train_y, test_x, test_y] = data_generate(trainNum, testNum)
    W_opt=[2,1]';
    % training data
    x1=2*(2*rand(trainNum,1)-1)';
    x2=2*(2*rand(trainNum,1)-1)';
    train_x=[x1', x2'];
    train_y=train_x*W_opt;
    clear x1  x2 
    % testing data
    x1= linspace(-2, 2, testNum);
    x2= linspace(-2, 2, testNum);
    test_x=[x1', x2'];
    test_y=test_x*W_opt;
    clear x1  x2
end