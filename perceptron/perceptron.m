clc;


max_epochs = 100;    
%Lectura de archivos
%Para el ejemplo 1, se utiliza target_t
%Para el ejemplo 2, se utiliza target_t2
%Para el ejemplo 3 se utiliza target_t3

X = readmatrix('input_p.txt');  % vectores por fila
D = readmatrix('target_t4clases.txt'); % targets

[num_samples, num_features] = size(X);

%inicializamos los pesos con 0 para disminuir el número de iteraciones, así
%como se inicializa el vector de pesos de manera aleatoria de 0 a 1, ésto
%para reducir el número de iteraciones también
W = rand(1, num_features);
b = 0;


hardlim = @(x) double(x >= 0);

for epoch = 1:max_epochs
    errors = 0;
    for i = 1:num_samples
        
        x = X(i, :);  
        x = x(:)';

        t = D(i);

        % Propagación hacia adelante
        a = hardlim(W * x' + b); 

        error = t - a;


        if error ~= 0
            W = W + learning_rate * error * x; 
            b = b + learning_rate * error; 
            errors = errors + 1;
        end
    end
    if errors == 0
        disp(['Convergió en la época ', num2str(epoch)]);
        break;
    end
end


disp('Pesos entrenados:');
disp(W);
disp('Sesgo entrenado:');
disp(b);

if num_features > 2

    disp('Reduciendo a las dos primeras dimensiones para graficar.');
    X_plot = X(:, 1:2);
    W_plot = W(1:2);
else
    X_plot = X;
    W_plot = W;
end

plotpv(X_plot', D');
linehandle = plotpc(W_plot, b);
set(linehandle, 'Linestyle', '-');
hold on; 
quiver(0, 0, W_plot(1), W_plot(2), 0, 'black', 'LineWidth', 2, 'MaxHeadSize', 2);
hold off;

fileID = fopen('w3.txt', 'w');

if fileID == -1
    error('No se pudo abrir el archivo.');
end


fprintf(fileID, 'Pesos:\n');
fprintf(fileID, mat2str(W_plot));

fclose(fileID);

fileID = fopen('b3.txt', 'w'); 

if fileID == -1
    error('No se pudo abrir el archivo.');
end


fprintf(fileID, 'Bias:\n');
fprintf(fileID, mat2str(b));

fclose(fileID);

