%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ~ IRIS ~ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% El archivo de iris.data se trata de un conjunto de datos que corresponden
% con 4 variables que representan la anchura y longitud del sepalo y el
% petalo de 3 clases de iris. En total hay 150 ejemplos de iris que se
% clsifican en bloques según su clase: de 1 a 50 vienen de setosa, de 51 a 
% 100 es versicolor y 101 a 150 es virginica, de forma que lo tenemos en 
% cuenta para las particiones en entrenamiento y test. 

%%%%%%%%%%%%%%%%%%%%%%%% PROCESADO DE DATOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Normalización de los datos de iris
% Cuando existen valores muy distintos en las variables se debe realizar
% una normalización de los datos, es decir, un reescalado de las variables
% de entrada.
iris_norm = normalize(iris, "DataVariables",["VarName1" "VarName2" "VarName3" "VarName4"]);

%% Crear matriz de entradas (INPUTS) y de salidas (OUTPUTS)
INPUTS = [iris_norm.VarName1, iris_norm.VarName2, iris_norm.VarName3, iris_norm.VarName4];
OUTPUTS = [iris_norm.Irissetosa];

%% Número de clases y datos existente
NumClass = size(unique(OUTPUTS),1);
NumData = size(OUTPUTS,1);

% El procesamiento realizado nos valdrá para realizar el modelo cuadrático
% por lo que guardaremos las variables obtenidas en un archivo Iris_datos.m
save ('Iris_datos', "iris", "iris_norm", "INPUTS", "OUTPUTS", "NumData", "NumClass")