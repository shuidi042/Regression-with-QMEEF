%clear;
clc;
close all;
addpath(genpath('Algorithms'));
addpath(genpath('Linear_Regression'));
addpath(genpath('Pars_Data'));
%%
trainNum = 500;
testNum = 100;
MC=20;
if ~exist('noise_type','var')
    noise_type = 'type1';% noise type (if it is not specified, the fault choice is 'type1')
end
noise_rate = 0.1;
%% Parameters Setting
maxIter=30;
fileName = ['qmeef_parscv_noise_', noise_type, '.mat']; 
pars= [10, 0.4, 0.1, 0.8, 1]; 
C = pars(1);
lambda = pars(2);
kermcc = pars(3);
kerqmee = pars(4);
threshold = pars(5);
%%  Monte Carlo runs
rand('state', 1);% a random seed to reproduce the results
randn('state', 0);% a random seed to reproduce the results
 for mc=1:MC
    %% generate data 
    [train_x, train_y, test_x, test_y] = data_generate(trainNum, testNum);
    %% introduce the noise
    ns = noise_regression(length(train_y), noise_rate, noise_type);
    train_y1=train_y+ns;
    [~, ~, ~, RMSE(mc), MAE(mc), RWEP(mc)] = ...
        Linear_QMEEF(train_x, train_y1, test_x, test_y, C, lambda, kermcc, kerqmee, threshold, maxIter);
 end
tmp1  = [mean(RWEP), mean(RMSE), mean(MAE)]
qmeef_noise = tmp1;
%% Store results
filename = ['qmeef_noise_',noise_type,'.mat'];
save(filename, 'qmeef_noise');
