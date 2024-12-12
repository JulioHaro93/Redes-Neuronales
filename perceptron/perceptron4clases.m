clc;

max_epochs = 100;    

X = readmatrix('input_p_4clases3.txt');

% Definir las matrices de etiquetas para las 4 clases, la puse así porque
% no supe como agregar la información en el txt
% Para la clase 1: {t1=[0,0], t2=[0,0]}
% Para la clase 2: {t3=[1,0], t4=[1,0]}
% Para la clase 3: {t5=[0,1], t6=[0,1]}
% Para la clase 4: {t7=[1,1], t8=[1,1]}
D1 = [0, 0; 0, 0];  % Para la clase 1
D2 = [1, 0; 1, 0];  % Para la clase 2
D3 = [0, 1; 0, 1];  % Para la clase 3
D4 = [1, 1; 1, 1];  % Para la clase 4

% Agrupamos todas las etiquetas en una matriz
D = [D1; D2; D3; D4];

[num_samples, num_features] = size(X);
num_classes = size(D, 2);  % Número de clases (4 en este caso)

% Inicializamos los pesos y bias
W = rand(num_classes, num_features);
b = [0;0]; % Un sesgo por clase
% Definimos la función hardlim
hardlim = @(x) double(x >= 0);

for epoch = 1:max_epochs
    errors = 0;
    for i = 1:num_samples
        
        x = X(i, :);  
        x = x(:)';
        t = D(i, :);
        % disp(W*x)
        % disp(b)
        % Propagación hacia adelante para cada clase
        a = hardlim(W * x' + b);
        error = t' - a;
        disp("_____________")
        disp(error)
        if any(error ~= 0)
            W = W + (error * x); 
            %disp(W)
            b = b + error; 
            disp(b)
            errors = errors + 1;
        end
        disp(epoch);
    end
    if epoch == max_epochs-1
       epoch=1;
    end

    if errors == 0
        disp(['Convergió en la época ', num2str(epoch)]);
        break;
    end

end

% Mostrar los resultados
disp('Pesos entrenados:');
disp(W);
disp('Sesgo entrenado:');
b=[0;0];
disp(b);

if num_features > 2
    disp('Reduciendo a las dos primeras dimensiones para graficar.');
    X_plot = X(:, 1:2);
    W_plot = W(:, 1:2);
else
    X_plot = X;
    W_plot = W;
end

plotpv(X_plot', D');
disp(W_plot)
disp(b)
linehandle = plotpc(W_plot, b);

set(linehandle, 'Linestyle', '-');
%set(line2,'linestyle','-');
hold on; 
for c = 1:num_classes
    quiver(0, 0, W_plot(c, 1), W_plot(c, 2), 0, 'black', 'LineWidth', 2, 'MaxHeadSize', 2);
end

hold off;

% Guardar los pesos y el sesgo en archivos
fileID = fopen('w4clases3.txt', 'w');
if fileID == -1
    error('No se pudo abrir el archivo.');
end
fprintf(fileID, 'Pesos:\n');
fprintf(fileID, mat2str(W));
fclose(fileID);

fileID = fopen('b4clases3.txt', 'w');
if fileID == -1
    error('No se pudo abrir el archivo.');
end
fprintf(fileID, 'Bias:\n');
fprintf(fileID, mat2str(b));
fclose(fileID);
