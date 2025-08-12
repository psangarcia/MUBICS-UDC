clear all; close all;

load('Henon_35_SVMpolinomial.mat'); % 'Henon_15_SVMpolinomial.mat
Aux=mean(AUX_MSE_TEST,2);
SVM = Aux([1:3:30]);

load('henon_lm_v35_15.mat'); % 'henon_lm_v15_45.mat'
Aux=mean(AUX_MSE_TEST,2);
RNA = Aux([1:3:30]);

Muestras = [SVM, RNA]; 
etiqueta = ['SVM'; 'RNA']; 

criticalValue = 0.10;
p = testEstadistico(Muestras,etiqueta,criticalValue);
fprintf('P-valor = %3.2f\n', p);
