%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% REDES NEURONALES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
%% Cargar los datos
load ('iris_datos.mat') % 'iris_datos.mat' 'qsar_norm.mat' 

%% Procesar los datos:
x = INPUTS'; 
t = onehotencode(OUTPUTS,2)'; 

%% Selección del algoritmo de aprendizaje:
trainFcn = 'trainscg';  % 'trainlm', 'trainscg'

%% Parámetros:
% Para cada algoritmo de aprendizaje, se entrenarán 3 versiones diferentes
% de la red neuronal, acorde con las especificaciones del guión.

% Tamaño de la capa oculta:
hiddenLayerSize =8; % Para Iris: 2, 8 y 5
                     % Para Qsar: 21, 84 y 56

% k-fold:
TypeCV = 'Kfold';
k = 10; % 5 para Qsar
iterac = 3;

% Archivo de salida
filename = 'iris_scg_8' % 'iris_scg_2' 'iris_scg_8' 'iris_scg_5' 'iris_lm_2' 'iris_lm_8' 'iris_lm_5'
                        % 'qsar_scg_21' 'qsar_scg_84' 'qsar_scg_56' 'qsar_lm_21' 'qsar_lm_84' 'qsar_lm_56' 
                  
%% Crear la red neuronal en el proceso de clasificación:
net = patternnet(hiddenLayerSize, trainFcn);  % 'mse' para trainlm

% Función de transferencia de las unidades de la red
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'softmax';

% División de los datos
net.divideParam.trainRatio = 70/100; % Conjunto de entrenamiento.
net.divideParam.valRatio = 30/100; % Conjunto de validación.
net.divideParam.testRatio = 0/100; % Conjunto de test.

% Entrenamiento y test de la red:
for iter = 1:iterac
    CV = cvpartition(OUTPUTS, TypeCV, k);
    for i = 1:k
        %TRAIN
        trIdx = CV.training(i)'; 
        net = train(net,x(:, trIdx),t(:,trIdx));
        Target_TRAIN = net(x(:, trIdx));
        OUTPUTS_TRAIN = onehotdecode(Target_TRAIN', char(unique(OUTPUTS)),2);
        [CM_TRAIN, ORDERCM_TRAIN] = confusionmat(OUTPUTS(trIdx, :), OUTPUTS_TRAIN);
        
        %TEST
        teIdx = CV.test(i)';
        Target_TEST = net(x(:, teIdx));
        OUTPUTS_TEST = onehotdecode(Target_TEST', char(unique(OUTPUTS)),2);
        [CM_TEST,ORDERCM_TEST]=confusionmat(OUTPUTS(teIdx,:), OUTPUTS_TEST);

        for j=1:NumClass
            [Recall_TRAIN(iter,i,j), Spec_TRAIN(iter,i,j), Precision_TRAIN(iter,i,j), NPV_TRAIN(iter,i,j), ACC_TRAIN(iter,i,j), F1Score_TRAIN(iter,i,j)] = performanceIndexes(CM_TRAIN,j);
            [Recall_TEST(iter,i,j), Spec_TEST(iter,i,j), Precision_TEST(iter,i,j), NPV_TEST(iter,i,j), ACC_TEST(iter,i,j), F1Score_TEST(iter,i,j)] = performanceIndexes(CM_TEST,j);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Medidas rendimiento %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Cambio dimensionalidades medidas rendimiento entrenamiento
AuxRecall = reshape(Recall_TRAIN, [iterac*k, NumClass]);
AuxSpec = reshape(Spec_TRAIN, [iterac*k, NumClass]);
AuxPrecision = reshape(Precision_TRAIN, [iterac*k, NumClass]);
AuxNPV = reshape(NPV_TRAIN, [iterac*k, NumClass]);
AuxACC = reshape(ACC_TRAIN, [iterac*k, NumClass]);
AuxF1Score = reshape(F1Score_TRAIN, [iterac*k, NumClass]);

% Medidas de rendimiento de entrenamiento por clase (CM_TRAIN):
for c = 1:NumClass
    fprintf('Resultados de ENTRENAMIENTO para la clase %s\n', ORDERCM_TRAIN(c));
    fprintf('\t Recall = %5.4e +- %5.4e\n', mean(AuxRecall(:,c)), std(AuxRecall(:,c)));
    fprintf('\t Especificidad = %5.4e +- %5.4e\n', mean(AuxSpec(:,c)), std(AuxSpec(:,c)));
    fprintf('\t Precision = %5.4e +- %5.4e\n', mean(AuxPrecision(:,c)), std(AuxPrecision(:,c)));
    fprintf('\t Valor Predictivo Negativo = %5.4e +- %5.4e\n', mean(AuxNPV(:,c)), std(AuxNPV(:,c)));
    fprintf('\t Accuracy = %5.4e +- %5.4e\n', mean(AuxACC(:,c)), std(AuxACC(:,c)));
    fprintf('\t F1-Score = %5.4e +- %5.4e\n', mean(AuxF1Score(:,c)), std(AuxF1Score(:,c)));
end

% Medidas de rendimiento de entrenamiento globales:
fprintf('Resultados de ENTRENAMIENTO para las clases (GLOBAL): \n');
fprintf('\t Recall = %5.4e +- %5.4e\n', mean(AuxRecall(:)), std(AuxRecall(:)));
fprintf('\t Especificidad = %5.4e +- %5.4e\n', mean(AuxSpec(:)), std(AuxSpec(:)));
fprintf('\t Precision = %5.4e +- %5.4e\n', mean(AuxPrecision(:)), std(AuxPrecision(:)));
fprintf('\t Valor Predictivo Negativo = %5.4e +- %5.4e\n', mean(AuxNPV(:)), std(AuxNPV(:)));
fprintf('\t Accuracy = %5.4e +- %5.4e\n', mean(AuxACC(:)), std(AuxACC(:)));
fprintf('\t F1-Score = %5.4e +- %5.4e\n', mean(AuxF1Score(:)), std(AuxF1Score(:)));

%% Cambio dimensionalidades medidas rendimiento test
AuxRecall_TEST = reshape(Recall_TEST, [iterac*k, NumClass]);
AuxSpec_TEST = reshape(Spec_TEST, [iterac*k, NumClass]);
AuxPrecision_TEST = reshape(Precision_TEST, [iterac*k, NumClass]);
AuxNPV_TEST = reshape(NPV_TEST, [iterac*k, NumClass]);
AuxACC_TEST = reshape(ACC_TEST, [iterac*k, NumClass]);
AuxF1Score_TEST = reshape(F1Score_TEST, [iterac*k, NumClass]);

% Medidas de rendimiento de test por clase (CM_TEST):
for c = 1:NumClass
    fprintf('Resultados de TEST para la clase %s\n', ORDERCM_TEST(c));
    fprintf('\t Recall = %5.4e +- %5.4e\n', mean(AuxRecall_TEST(:,c)), std(AuxRecall_TEST(:,c)));
    fprintf('\t Especificidad = %5.4e +- %5.4e\n', mean(AuxSpec_TEST(:,c)), std(AuxSpec_TEST(:,c)));
    fprintf('\t Precision = %5.4e +- %5.4e\n', mean(AuxPrecision_TEST(:,c)), std(AuxPrecision_TEST(:,c)));
    fprintf('\t Valor Predictivo Negativo = %5.4e +- %5.4e\n', mean(AuxNPV_TEST(:,c)), std(AuxNPV_TEST(:,c)));
    fprintf('\t Accuracy = %5.4e +- %5.4e\n', mean(AuxACC_TEST(:,c)), std(AuxACC_TEST(:,c)));
    fprintf('\t F1-Score = %5.4e +- %5.4e\n', mean(AuxF1Score_TEST(:,c)), std(AuxF1Score_TEST(:,c)));
end

% Medidas de rendimiento de test global:
fprintf('Resultados de TEST para las clases (GLOBAL): \n');
fprintf('\t Recall = %5.4e +- %5.4e\n', mean(AuxRecall_TEST(:)), std(AuxRecall_TEST(:)));
fprintf('\t Especificidad = %5.4e +- %5.4e\n', mean(AuxSpec_TEST(:)), std(AuxSpec_TEST(:)));
fprintf('\t Precision = %5.4e +- %5.4e\n', mean(AuxPrecision_TEST(:)), std(AuxPrecision_TEST(:)));
fprintf('\t Valor Predictivo Negativo = %5.4e +- %5.4e\n', mean(AuxNPV_TEST(:)), std(AuxNPV_TEST(:)));
fprintf('\t Accuracy = %5.4e +- %5.4e\n', mean(AuxACC_TEST(:)), std(AuxACC_TEST(:)));
fprintf('\t F1-Score = %5.4e +- %5.4e\n', mean(AuxF1Score_TEST(:)), std(AuxF1Score_TEST(:)));

save(filename, 'Recall_TEST', 'Spec_TEST', 'Precision_TEST', 'NPV_TEST', 'ACC_TEST', 'F1Score_TEST','AuxF1Score_TEST','Recall_TRAIN', 'Spec_TRAIN', 'Precision_TRAIN', 'NPV_TRAIN', 'ACC_TRAIN', 'F1Score_TRAIN')


