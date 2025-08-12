%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Árbol decisión %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load ('Iris_datos.mat') % 'Qsar_datos.mat'

%%%%%%%%%%%%%%%%%%%% Condiciones de experimentación %%%%%%%%%%%%%%%%%%%%%%%
DiscrimType = 'linear';
TypeCV = 'Kfold';
k = 10; % Para Qsar: 5
rng('shuffle'); % modifica la semilla de los numeros aleatorios
filename = 'Iris_tree'; % 'Qsar_tree'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Árbol de decisión %%%%%%%%%%%%%%%%%%%%%%%%%%%
MaxNumSplits = size(INPUTS,1) - 1; % Por defecto
MinLeafSize = 1; % Para Iris: 1, 5 y 10; 
                 % Para Qsar: 1, 20 y 20
MinParentSize = 10; % Para Iris: 10, 15 y 20; 
                    %  Para Qsar: 10, 25 y 40
ResponseName = 'Iris Type'; % 'Chemical Type'
PredictorNames = {'SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'}; % Ocultar estar linea para Qsar

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Particiones %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Particiones del conjunto de datos
CV = cvpartition(OUTPUTS, TypeCV, k);

%% Entrenamiento de los 10 modelos mediante 10-fold
for i = 1:k
    trIdx = CV.training(i); 
    Mdl{i} = fitctree(INPUTS(trIdx,:), OUTPUTS(trIdx,:), 'MaxNumSplits', MaxNumSplits, 'MinLeafSize', MinLeafSize, 'MinParentSize', MinParentSize, 'PredictorNames', PredictorNames, 'ResponseName', ResponseName );
    % Mdl{i} = fitctree(INPUTS(trIdx,:), OUTPUTS(trIdx,:), 'MaxNumSplits', MaxNumSplits, 'MinLeafSize', MinLeafSize, 'MinParentSize', MinParentSize,'ResponseName', ResponseName ); % Para Qsar. Ocultar linea de arriba
    view(Mdl{i}, 'Mode','graph'); pause
end

% Cálculo de los resultados para entrenamiento 
for j=1:k
    trIdx = CV.training(j);
    REAL_TRAIN_OUTPUTS = predict(Mdl{j}, INPUTS(trIdx,:));
    [CM_TRAIN, ORDERCM] = confusionmat(OUTPUTS(trIdx, :), REAL_TRAIN_OUTPUTS);
    for i=1:NumClass
      %Para cada clase y cada modelo almacenamos las medidas de rendimiento
        [Recall(i,j), Spec(i,j), Precision(i,j), NPV(i,j), ACC(i,j), F1Score(i,j)] = performanceIndexes(CM_TRAIN,i)
    end
end

% Medidas de rendimiento de entrenamiento por clase (CM_TRAIN):
for i=1:NumClass
    fprintf('Resultados de ENTRENAMIENTO para la Clase %s\n', ORDERCM(i));
    fprintf('\t Recall = %3.2f\n', mean(Recall(i,2)));
    fprintf('\t Especificidad = %3.2f\n', mean(Spec(i,2)));
    fprintf('\t Precision = %3.2f\n', mean(Precision(i,2)));
    fprintf('\t Valor Predictivo Negativo = %3.2f\n', mean(NPV(i,2)));
    fprintf('\t Accuracy = %3.2f\n', mean(ACC(i,2)));
    fprintf('\t F1-Score = %3.2f\n', mean(F1Score(i,2)));
end;

% Medidas de rendimiento de entrenamiento (Global) para las 3 clases:
fprintf('Resultados de ENTRENAMIENTO para las 3 clases (GLOBAL): \n');
fprintf('\t Recall = %3.2f\n', mean(mean(Recall)));
fprintf('\t Especificidad = %3.2f\n', mean(mean(Spec)));
fprintf('\t Precision = %3.2f\n', mean(mean(Precision)));
fprintf('\t Valor Predictivo Negativo = %3.2f\n', mean(mean(NPV)));
fprintf('\t Accuracy = %3.2f\n', mean(mean(ACC)));
fprintf('\t F1-Score = %3.2f\n', mean(mean(F1Score)));

%% Cálculo de resultados para test
for j=1:k
    teIdx = CV.test(j)
    REAL_TEST_OUTPUTS = predict(Mdl{j}, INPUTS(teIdx,:));
    [CM_TEST,ORDERCM]=confusionmat(OUTPUTS(teIdx,:), REAL_TEST_OUTPUTS);
    for i=1:NumClass
        %Para cada clase y cada modelo almacenamos las medidas de
        %rendimiento
        [Recall_TEST(i,j), Spec_TEST(i,j), Precision_TEST(i,j), NPV_TEST(i,j), ACC_TEST(i,j), F1Score_TEST(i,j)] = performanceIndexes(CM_TEST,i)
    end
end

% Medidas de rendimiento de test por clase:
for i=1:NumClass
    fprintf('Resultados de TEST para la Clase %s\n', ORDERCM(i));
    fprintf('\t Recall = %3.2f\n', mean(Recall_TEST(i,2)));
    fprintf('\t Especificidad = %3.2f\n', mean(Spec_TEST(i,2)));
    fprintf('\t Precision = %3.2f\n', mean(Precision_TEST(i,2)));
    fprintf('\t Valor Predictivo Negativo = %3.2f\n', mean(NPV_TEST(i,2)));
    fprintf('\t Accuracy = %3.2f\n', mean(ACC_TEST(i,2)));
    fprintf('\t F1-Score = %3.2f\n', mean(F1Score_TEST(i,2)));
end;

% Medidas de rendimiento de test (Global) para las 3 clases:
fprintf('Resultados de TEST para las 3 clases (GLOBAL): \n');
fprintf('\t Recall = %3.2f\n', mean(mean(Recall_TEST)));
fprintf('\t Especificidad = %3.2f\n', mean(mean(Spec_TEST)));
fprintf('\t Precision = %3.2f\n', mean(mean(Precision_TEST)));
fprintf('\t Valor Predictivo Negativo = %3.2f\n', mean(mean(NPV_TEST)));
fprintf('\t Accuracy = %3.2f\n', mean(mean(ACC_TEST)));
fprintf('\t F1-Score = %3.2f\n', mean(mean(F1Score_TEST)));

% Se guardan las medidas finales de TEST y ENTRENAMIENTO con un filename establecido 
% para cada tipo de discriminante:
save(filename, 'Recall_TEST', 'Spec_TEST', 'Precision_TEST', 'NPV_TEST', 'ACC_TEST', 'F1Score_TEST','Recall', 'Spec', 'Precision', 'NPV', 'ACC', 'F1Score')
