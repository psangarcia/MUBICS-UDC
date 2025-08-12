%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% COMPARACIÓN DE MODELOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all;
load('Iris_DiscrimLineal.mat'); % 'Qsar_DiscrimLineal.mat'
DiscrimLineal = [mean(F1Score_TEST)]';

load('Iris_DiscrimQuadr.mat'); % 'Qsar_DiscrimpseudoQuadr.mat'
DiscrimQuadr = [mean(F1Score_TEST)]';

% load('Iris_arbol.mat'); % 'Qsar_arbol.mat'
% Tree = [mean(F1Score_TEST)]';

Muestras = [DiscrimLineal, DiscrimQuadr]; %, Tree
etiqueta = ['Disc lineal'; 'Disc cuadra']; % ; 'Arbol decis'

criticalValue = 0.10;
p = testEstadistico(Muestras,etiqueta,criticalValue);
fprintf('P-valor = %3.2f\n', p);
