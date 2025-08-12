%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%   REDUCCIÓN DE LA DIMENSIÓN   %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% ANÁLISIS DE COMPONENTES PRINCIPALES %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
% Cargamos el conjunto de datos normalizado de QSAR:
load ('qsar_norm.mat')

inputs = INPUTS; 
outputs = OUTPUTS;

% Técnica de validación (kfold con 5 paquetes):
TypeCV = 'KFold';
k = 5;

% Se plantean 3 repeticiones:
iterac = 3;

% Se establece un valor mínimo de 90 en la varianza de PCA:
explainedLimit=90;

% En lo que respecta a la versión de red neuronal, se establecen los correspondientes parámetros:

% Selección del algoritmo de aprendizaje:
trainFcn = 'trainlm';

% Número de unidades en la capa oculta:
hiddenLayerSize = 84;

% Se genera el archivo de salida para la posterior conservación de resultados:
filename = 'qsar_lm_84_pca';

% Se procede a la generación de la matriz que almacena el número
% de componentes para cada iteración y fold planteadas:
totalcoef = zeros(iterac, k);
for iter=1:iterac
    CV = cvpartition(outputs,TypeCV,k);
    for i=1:k
        trIdx=CV.training(i);
        [coef, score, latent, t, explained]=pca(inputs(trIdx,:));

        % Se establece como minimo un componente principal a considerar
        sumexplained=explained(1);

        ncoef=1;
        while(sumexplained<explainedLimit)
            ncoef=ncoef+1;
            sumexplained=sumexplained+explained(ncoef);
        end

        %Almacenamos el número de componentes utilizados, que 
        %nos servirá para ver si hay mucha variabilidad en los
        %componentes seleccionados
        totalcoef(iter,i)=ncoef;

        % Se establecen las entradas transformadas y la red neuronal:
        inputs_pca=inputs*coef(:,[1:ncoef]);
        net = patternnet(hiddenLayerSize, trainFcn, 'mse');

        % Función de transferencia de las unidades de la red generada:
        net.layers{1}.transferFcn = 'purelin';
        net.layers{2}.transferFcn = 'softmax';

        % División de los conjuntos de datos:
        net.divideParam.trainRatio = 70/100; % Conjunto de entrenamiento.
        net.divideParam.valRatio = 30/100; % Conjunto de validación.
        net.divideParam.testRatio = 0/100;

        %Se procede al entrenamiento de la versión de red
        %con las entradas transformadas y las targets correspondientes
        x = inputs_pca';
        t = onehotencode(outputs,2)';   

        % TRAIN
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
%%%%%%%%%%%%%%%%%%%%%%%% Medidas de rendimiento %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Cambio dimensionalidades medidas rendimiento entrenamiento:
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

%% Cambio dimensionalidades medidas rendimiento test:
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Comparación de PCA con técnicas anteriores %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all;
load('qsar_DiscrimLineal.mat');
DiscrimLineal = [mean(F1Score_TEST)]';

load('qsar_pseudoQuadratic.mat');
DiscrimQuadr = [mean(F1Score_TEST)]';

load('qsar_tree_20_25.mat');
Tree = [mean(F1Score_TEST)]';

load('Qsar_SVMLineal.mat');
Aux = mean(AuxF1Score_TEST,2);
SVMLineal = Aux([1:3:15]);

load('qsar_lm_84.mat');
Aux_rna = mean(AuxF1Score_TEST,2);
RNA = Aux([1:3:15]);

load('qsar_lm_84_pca.mat');
Aux_PCA = mean(AuxF1Score_TEST,2);
PCA = Aux_PCA([1:3:15]);

Muestras = [DiscrimLineal, DiscrimQuadr, Tree, SVMLineal, RNA, PCA];
etiqueta = ['Disc_lineal';'Disc_cuadra'; 'Arbo_decisi'; 'Svmi_lineal'; 'redn_lineal'; 'comp_princi'];

criticalValue = 0.10;
p = testEstadistico(Muestras,etiqueta,criticalValue);
fprintf('P-valor = %3.2f\n', p);


