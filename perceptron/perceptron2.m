% Parámetros de entrenamiento
max_epochs = 100;      % Número máximo de épocas
learning_rate = 0.1;   % Tasa de aprendizaje

% Datos de entrenamiento (ejemplo)
% Asegúrate de reemplazar `X` y `D` con tus propios datos de entrada y etiquetas
X = readmatrix('input_p.txt.txt');  % Matriz de entradas, cada columna es un punto de datos [x; y]
D =  readmatrix('target_t.txt.txt');  % Vector de etiquetas deseadas (1 para clase positiva, 0 para clase negativa)

% Inicialización de pesos y sesgo
[num_features, num_samples] = size(X);
W = rand(1, num_features) % Vector de pesos inicializado aleatoriamente
b = rand;                  % Sesgo inicializado aleatoriamente

% Entrenamiento del perceptrón
for epoch = 1:max_epochs
    errors = 0;
    for i = 1:num_samples
        % Selecciona el punto de datos y la etiqueta
        x = X(:, i);      % Punto de datos actual
        d = D(i);         % Etiqueta deseada
        
        % Propagación hacia adelante
        a = hardlim(W * x + b);  % Salida actual (0 o 1)
        
        % Calcula el error y actualiza si es necesario
        error = d - a;
        if error ~= 0
            W = W + error * x';  % Actualiza los pesos
            b = b +   error;       % Actualiza el sesgo
            errors = errors + 1;
        end
    end
    
    % Verifica si el entrenamiento ha convergido
    if errors == 0
        disp(['Convergió en la época ', num2str(epoch)]);
        break;
    end
end

% Resultado final
disp('Pesos entrenados:');
disp(W);
disp('Sesgo entrenado:');
disp(b);

plotpv(p,D')
W2=W;
%generamos el producto vectorial de W para poderlo graficar en R2

disp('El resultado es:');
disp(result);

linehandle = plotpc(W',b);
set(linehandle,'Linestyle', '--');