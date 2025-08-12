%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% PRÁCTICA 3: PARTE 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%    SERIE DE HENON   %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('Henon.mat');
datos = x(1:1500); 

% Parámetros:

d = 150 % Tamaño de ventana (d1 = 15 y d2 = 35)
KernelFunction = 'linear'; % 'polynomial' , 'rbf'
TypeCV = 'Kfold';
k = 10;
iterac = 3;
BoxConstraint = 10 

rng(1); % modifica la semilla de los numeros aleatorios
filename = 'Henon_vent1'; % 'Henon_d1_SVMLineal'; % 'Henon_d1_SVMpolinomial', 'Henon_d1_SVMrbf' 
                          % 'Henon_d2_SVMLineal'; % 'Henon_d2_SVMpolinomial', 'Henon_d2_SVMrbf'


% Conjuntos de datos con diferente tamaño de ventana:
[INPUTS,OUTPUTS] = slidingwindow(datos,d);

% Normalización de los datos:
INPUTS = normalize(INPUTS);
OUTPUTS = normalize(OUTPUTS);

% Validación:
for iter = 1:iterac
    CV = cvpartition(OUTPUTS, TypeCV, k, 'Stratify', false);
    for i = 1:k
        %TRAIN
        trIdx = CV.training(i); 
        % Mdl{iter,i} = fitrsvm(INPUTS(trIdx,:), OUTPUTS(trIdx,:), 'KernelFunction', KernelFunction, 'BoxConstraint', BoxConstraint); 
        % Mdl{iter,i} = fitrsvm(INPUTS(trIdx,:), OUTPUTS(trIdx,:), 'KernelFunction', KernelFunction, 'BoxConstraint', BoxConstraint, 'PolynomialOrder',2); 
        Mdl{iter,i} = fitrsvm(INPUTS(trIdx,:), OUTPUTS(trIdx,:), 'KernelFunction', KernelFunction, 'BoxConstraint', BoxConstraint,'KernelScale', 1);
        REAL_TRAIN_OUTPUTS = predict(Mdl{iter,i}, INPUTS(trIdx,:));
        
        % TEST
        teIdx = CV.test(i);
        REAL_TEST_OUTPUTS = predict(Mdl{iter,i}, INPUTS(teIdx,:));

        MSE_TRAIN(iter,i) = immse(REAL_TRAIN_OUTPUTS, OUTPUTS(trIdx,:));
        MSE_TEST(iter,i) = immse(REAL_TEST_OUTPUTS, OUTPUTS(teIdx,:)); 
    end
end

% Error cuadrático medio para entrenamiento:
% Se lleva a cabo el reshape con el fin de transformar la matriz generada
% en un vector y mostrar la media y desviación típica correspondientes:

AUX_MSE_TRAIN=reshape(MSE_TRAIN,[iterac*k,1]);
AUX_MSE_TEST=reshape(MSE_TEST,[iterac*k,1]);

% Visualización de los resultados obtenidos para entrenamiento y test:
fprintf('\t MSE entrenamiento = %5.4e +- %5.4e\n', mean(AUX_MSE_TRAIN(:)), std(AUX_MSE_TRAIN(:)));
fprintf('\t MSE test = %5.4e +- %5.4e\n', mean(AUX_MSE_TEST(:)), std(AUX_MSE_TEST(:)));

% Se guardan los filenames correspondientes, con las medidas de MSE en 
% test y entrenamiento para cada versión de SVM generada:
save(filename, 'AUX_MSE_TRAIN', 'AUX_MSE_TEST');