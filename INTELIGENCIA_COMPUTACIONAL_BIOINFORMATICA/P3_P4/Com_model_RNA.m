clear all; close all;

load('henon_scg_v15_15.mat'); % 'iris_scg_2.mat' 'qsar_scg_21.mat' 
Aux=mean(AUX_MSE_TEST,2);   % Para Qsar e Iris: AuxF1Score_TEST
% scg_1 = Aux([1:3:15]);    % Para Qsar
scg_1 = Aux([1:3:30]);

load('henon_scg_v15_45.mat'); % 'iris_scg_5.mat''qsar_scg_56.mat'
Aux=mean(AUX_MSE_TEST,2);   % Para Qsar e Iris: AuxF1Score_TEST
% scg_2 = Aux([1:3:15]);    % Para Qsar
scg_2 = Aux([1:3:30]);

load('henon_scg_v15_70.mat'); % 'iris_scg_8.mat''qsar_scg_84.mat'
Aux=mean(AUX_MSE_TEST,2);   % Para Qsar e Iris: AuxF1Score_TEST
% scg_3 = Aux([1:3:15]);    % Para Qsar
scg_3 = Aux([1:3:30]);

load('henon_lm_v15_15.mat'); % 'iris_scg_2.mat''qsar_lm_21.mat'
Aux=mean(AUX_MSE_TEST,2);   % Para Qsar e Iris: AuxF1Score_TEST
% lm_1 = Aux([1:3:15]);    % Para Qsar
lm_1 = Aux([1:3:30]);

load('henon_lm_v15_45.mat'); % 'iris_scg_5.mat''qsar_lm_56.mat'
Aux=mean(AUX_MSE_TEST,2);   % Para Qsar e Iris: AuxF1Score_TEST
% lm_2 = Aux([1:3:15]);    % Para Qsar
lm_2 = Aux([1:3:30]);

load('henon_lm_v15_70.mat'); % 'iris_scg_8.mat''qsar_lm_84.mat'
Aux=mean(AUX_MSE_TEST,2);
% lm_3 = Aux([1:3:15]);    % Para Qsar
lm_3 = Aux([1:3:30]);

Muestras = [scg_1, scg_2, scg_3, lm_1, lm_2, lm_3]; 
etiqueta = ['Scg 1';'Scg 2';'Scg 3'; 'tLm 1'; 'tLm 2'; 'tLm 3']; 

criticalValue = 0.10;
p = testEstadistico(Muestras,etiqueta,criticalValue);
fprintf('P-valor = %3.2f\n', p);
