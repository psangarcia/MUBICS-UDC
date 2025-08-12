clear all; close all;

load('qsar_DiscrimLineal.mat'); % 'iris_DiscrimLineal.mat' 'qsar_DiscrimLineal.mat'
DiscrimLineal = [mean(F1Score_TEST)]';

load('qsar_pseudoQuadratic.mat'); % 'iris_DiscrimQuadr.mat' 'qsar_pseudoQuadratic.mat'
DiscrimQuadr = [mean(F1Score_TEST)]';

load('qsar_tree_20_25.mat'); % 'Iris_tree_10_20.mat' 'qsar_tree_20_25.mat'
Tree = [mean(F1Score_TEST)]';

load('Qsar_SVMLineal_1m.mat'); % 'iris_SVMLineal_10_1m.mat' 'Qsar_SVMLineal_1m.mat'
Aux=mean(AuxF1Score_TEST,2);
%SVM = Aux([1:3:30]);    % Para Iris
SVM = Aux([1:3:15]);

load('qsar_lm_84.mat'); % 'iris_lm_2.mat' 'qsar_lm_84.mat'
Aux=mean(AuxF1Score_TEST,2);
%RNA = Aux([1:3:30]);   % Para Iris
RNA = Aux([1:3:15]);

Muestras = [DiscrimLineal, DiscrimQuadr, Tree, SVM, RNA]; 
etiqueta = ['Disc lineal'; 'Disc cuadra'; 'Arbol decis'; 'SVM  Lineal'; 'RNA LevMarq']; 

criticalValue = 0.10;
p = testEstadistico(Muestras,etiqueta,criticalValue);
fprintf('P-valor = %3.2f\n', p);
