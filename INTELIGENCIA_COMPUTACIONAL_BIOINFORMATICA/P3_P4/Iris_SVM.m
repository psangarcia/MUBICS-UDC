%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%   SVMs en Iris  %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
load ('iris_datos.mat');

% Condiciones de experimentación:
TypeCV = 'Kfold';
k = 10;
iterac = 3;
BoxConstraint = 10;

% Planteamiento de las diferentes versiones de SVMs en el problema tratado:
%t = templateSVM('KernelFunction', 'linear', 'BoxConstraint', BoxConstraint);
%t = templateSVM('KernelFunction', 'polynomial', 'PolynomialOrder', 2, 'BoxConstraint', BoxConstraint);
% t = templateSVM('KernelFunction', 'rbf', 'KernelScale', 1, 'BoxConstraint', BoxConstraint);


rng('shuffle'); % modifica la semilla de los numeros aleatorios

filename = 'iris_SVMLineal'; % 'iris_SVMpolinomial', 'iris_SVMrbf'

NumClass=3; 

%% Entrenamiento y test de las particiones generadas:
for iter = 1:iterac
    CV = cvpartition(OUTPUTS, TypeCV, k);
    for i = 1:k
        %TRAIN
        trIdx = CV.training(i);
        Mdl{iter,i} = fitcecoc(INPUTS(trIdx,:), OUTPUTS(trIdx,:), 'Learners',t); % Por defecto, onevsone
        REAL_TRAIN_OUTPUTS = predict(Mdl{iter,i}, INPUTS(trIdx,:));
        [CM_TRAIN, ORDERCM_TRAIN] = confusionmat(OUTPUTS(trIdx, :), REAL_TRAIN_OUTPUTS);

        % TEST
        teIdx = CV.test(i);
        REAL_TEST_OUTPUTS = predict(Mdl{iter,i}, INPUTS(teIdx,:));
        [CM_TEST,ORDERCM_TEST]=confusionmat(OUTPUTS(teIdx,:), REAL_TEST_OUTPUTS);
        
        for j=1:NumClass
            [Recall_TRAIN(iter,i,j), Spec_TRAIN(iter,i,j), Precision_TRAIN(iter,i,j), NPV_TRAIN(iter,i,j), ACC_TRAIN(iter,i,j), F1Score_TRAIN(iter,i,j)] = performanceIndexes(CM_TRAIN,j)
            [Recall_TEST(iter,i,j), Spec_TEST(iter,i,j), Precision_TEST(iter,i,j), NPV_TEST(iter,i,j), ACC_TEST(iter,i,j), F1Score_TEST(iter,i,j)] = performanceIndexes(CM_TEST,j)
        end
    end
end


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
fprintf('\t Recall = %5.4e +- %5.4e\n', mean(Recall_TRAIN(:)), std(Recall_TRAIN(:)));
fprintf('\t Especificidad = %5.4e +- %5.4e\n', mean(Spec_TRAIN(:)), std(Spec_TRAIN(:)));
fprintf('\t Precision = %5.4e +- %5.4e\n', mean(Precision_TRAIN(:)), std(Precision_TRAIN(:)));
fprintf('\t Valor Predictivo Negativo = %5.4e +- %5.4e\n', mean(NPV_TRAIN(:)), std(NPV_TRAIN(:)));
fprintf('\t Accuracy = %5.4e +- %5.4e\n', mean(ACC_TRAIN(:)), std(ACC_TRAIN(:)));
fprintf('\t F1-Score = %5.4e +- %5.4e\n', mean(F1Score_TRAIN(:)), std(F1Score_TRAIN(:)));

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

% Medidas de rendimiento de test globales:
fprintf('Resultados de TEST para las clases (GLOBAL): \n');
fprintf('\t Recall = %5.4e +- %5.4e\n', mean(Recall_TEST(:)), std(Recall_TEST(:)));
fprintf('\t Especificidad = %5.4e +- %5.4e\n', mean(Spec_TEST(:)), std(Spec_TEST(:)));
fprintf('\t Precision = %5.4e +- %5.4e\n', mean(Precision_TEST(:)), std(Precision_TEST(:)));
fprintf('\t Valor Predictivo Negativo = %5.4e +- %5.4e\n', mean(NPV_TEST(:)), std(NPV_TEST(:)));
fprintf('\t Accuracy = %5.4e +- %5.4e\n', mean(ACC_TEST(:)), std(ACC_TEST(:)));
fprintf('\t F1-Score = %5.4e +- %5.4e\n', mean(F1Score_TEST(:)), std(F1Score_TEST(:)));


% Se guardan las medidas finales de TEST y ENTRENAMIENTO con un filename 
% para cada versión de SVM establecida:
save(filename, 'Recall_TEST', 'Spec_TEST', 'Precision_TEST', 'NPV_TEST', 'ACC_TEST', 'F1Score_TEST','AuxF1Score_TEST','Recall_TRAIN', 'Spec_TRAIN', 'Precision_TRAIN', 'NPV_TRAIN', 'ACC_TRAIN', 'F1Score_TRAIN')