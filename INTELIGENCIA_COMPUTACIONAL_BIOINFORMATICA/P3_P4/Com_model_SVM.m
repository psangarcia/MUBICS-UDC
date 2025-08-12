%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Comparación de SVMs %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all;

load('Henon_15_SVMLineal.mat'); % 'Henon_35_SVMLineal.mat' 'iris_SVMLineal_10_1m.mat' 'Qsar_SVMLineal.mat'
Aux=mean(AUX_MSE_TEST,2);   % Para Qsar e Iris: AuxF1Score_TEST
% SVMLineal = Aux([1:3:15]);    % Para Qsar
SVMLineal = Aux([1:3:30]);

load('Henon_15_SVMpolinomial.mat'); % 'Henon_35_SVMLineal.mat'; 'iris_SVMpolinomial_10_1m.mat' 'Qsar_SVMpolinomial.mat'
Aux=mean(AUX_MSE_TEST,2);   % Para Qsar e Iris: AuxF1Score_TEST
% SVMpolinomial = Aux([1:3:15]);    % Para Qsar
SVMpolinomial = Aux([1:3:30]);

load('Henon_15_SVMrbf.mat'); % 'Henon_35_SVMLineal.mat' 'iris_SVMrbf_10_1m.mat' 'Qsar_SVMrbf.mat'
Aux=mean(AUX_MSE_TEST,2);   % Para Qsar e Iris: AuxF1Score_TEST
% SVMrbf = Aux([1:3:15]);   % Para Qsar
SVMrbf = Aux([1:3:30]);

Muestras = [SVMLineal, SVMpolinomial, SVMrbf];
etiqueta = ['SVM Lin';'SVM pol';'Svm rbf'];

criticalValue = 0.10;
p = testEstadistico(Muestras,etiqueta,criticalValue);
fprintf('P-valor = %3.2f\n', p);