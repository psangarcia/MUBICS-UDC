%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ~ QSAR ~ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% El conjunto de datos QSAR biodegradation forma parte de un proyecto para 
% el desarrollo de modelos QSAR (Quantitative Structure Activity 
% Relationships) en el estudio de relaciones entre la estructura química y 
% la biodegradación de moléculas. Contiene 1055 muestras de compuestos 
% químicos y 41 descriptores moleculares como variables para determinar la 
% clasificación de las entradas a una de las 2 clases: biodegradable / 
% no biodegradable. 

%%%%%%%%%%%%%%%%%%%%%%%% PROCESADO DE DATOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Normalización de los datos de qsar
% Cuando existen valores muy distintos en las variables se debe realizar
% una normalización de los datos, es decir, un reescalado de las variables
% de entrada.
% Procesado de los datos
% Normalización de los datos
qsar_norm = normalize(biodeg.Variables);

%% Crear matriz de entradas (INPUTS) y de salidas (OUTPUTS)
INPUTS = [qsar_norm];
OUTPUTS = [biodeg.RB];

%% Número de clases y datos existente
NumClass = size(unique(OUTPUTS),1);
NumData = size(OUTPUTS,1);

% El procesamiento realizado nos valdrá para realizar los modelos lineal y
% cuadrático, por lo que guardaremos las variables obtenidas en un archivo Qsar_datos.m
save ('Qsar_datos', "qsar_norm", "INPUTS", "OUTPUTS", "NumData", "NumClass")
