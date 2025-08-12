%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% REDES NEURONALES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
% Cargamos el conjunto de datos:
load ('Henon_v15.mat'); % 'Henon_v35' 'Henon_v15' 

x = INPUTS';
t = OUTPUTS';

%% Parámetros:
% Selección del algoritmo de aprendizaje:
trainFcn = 'trainscg';  % 'trainlm', 'trainscg'

% Para cada algoritmo de aprendizaje, se entrenarán 3 versiones diferentes
% de la red neuronal, acorde con las especificaciones del guión:
% Número de unidades en la capa oculta:
hiddenLayerSize = 70; % 15, 45, 70

TypeCV = 'Kfold';
k = 10;
iterac = 3;

% Archivo de salida
filename = 'henon_scg_v15_70' % 'henon_scg_v15_15' 'henon_scg_v15_45''henon_scg_v15_70'
                          % 'henon_lm_v15_15' 'henon_lm_v15_45''henon_llm_v15_70'
                          % 'henon_scg_v35_15' 'henon_scg_v35_45''henon_scg_v35_70'
                          % 'henon_lm_v35_15' 'henon_lm_v35_45''henon_llm_v35_70'
                         
                  
%% Crear la red neuronal en el proceso de clasificación:
net = fitnet(hiddenLayerSize, trainFcn);  

% Función de transferencia de las unidades de la red
net.layers{1}.transferFcn = 'tansig'; % tangente hiperbolica
net.layers{2}.transferFcn = 'purelin'; % lineal

% División de los datos
net.divideParam.trainRatio = 70/100; % Conjunto de entrenamiento.
net.divideParam.valRatio = 30/100; % Conjunto de validación.
net.divideParam.testRatio = 0/100; % Conjunto de test.

% Entrenamiento y test de la red:
for iter = 1:iterac
    CV = cvpartition(OUTPUTS, TypeCV, k, 'Stratify', false);
    for i = 1:k
        %TRAIN
        trIdx = CV.training(i)'; 
        net = train(net,x(:, trIdx),t(:,trIdx));
        Target_TRAIN = net(x(:, trIdx));
        OUTPUTS_TRAIN = Target_TRAIN';
        
        %TEST
        teIdx = CV.test(i)';
        Target_TEST = net(x(:, teIdx));
        OUTPUTS_TEST = Target_TEST';

        MSE_TRAIN(iter,i) = immse(OUTPUTS_TRAIN, OUTPUTS(trIdx,:));
        MSE_TEST(iter,i) = immse(OUTPUTS_TEST, OUTPUTS(teIdx,:)) 
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MSE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AUX_MSE_TRAIN=reshape(MSE_TRAIN,[iterac*k,1]);
AUX_MSE_TEST=reshape(MSE_TEST,[iterac*k,1]);

% Error cuadrático medio para train
fprintf('\t MSE entrenamiento = %5.4e +- %5.4e\n', mean(AUX_MSE_TRAIN(:)), std(AUX_MSE_TRAIN(:)));

% Error cuadrático medio para test
fprintf('\t MSE test = %5.4e +- %5.4e\n', mean(AUX_MSE_TEST(:)), std(AUX_MSE_TEST(:)));

save(filename, 'AUX_MSE_TEST', 'AUX_MSE_TRAIN')


