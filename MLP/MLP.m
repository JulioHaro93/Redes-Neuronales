clc;

maxEpoch = 30000;

n=0;

global data
global W

function main()
    % Parámetros iniciales
    data = readmatrix("Polinomio1.txt"); % Carga los datos (n x 1 esperado)
    if size(data, 2) > 1
        data = data'; % Asegura que data sea un vector columna
    end

    % Genera pesos iniciales aleatorios
    num_pesos1 = 16; % Número de neuronas en la primera capa
    num_pesos2 = 14; % Número de neuronas en la segunda capa
    rango_pesos = [0.68, 0.71];
    pesos1 = rand(num_pesos1, size(data, 1)) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
    pesos2 = rand(num_pesos2, num_pesos1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
    pesos3 = rand(1, num_pesos2) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);

    % Define una salida deseada (ejemplo)
    target = ones(1, size(data, 2)); % Salida deseada uniforme

    % Iteraciones de entrenamiento
    learning_rate = 0.01;
    max_epocas = 30;
    for epoch = 1:max_epocas
        % Propagación hacia adelante
        a1_1 = logsig(pesos1 * data);      % Capa 1
        a1_2 = logsig(pesos2 * a1_1);     % Capa 2
        a1_3 = purelin(pesos3 * a1_2);    % Salida final

        % Cálculo del error
        error = target - a1_3;

        % Backpropagation
        % Gradiente en la salida
        delta3 = error; % Derivada de purelin es 1
        % Gradiente en la capa intermedia
        delta2 = (pesos3' * delta3) .* (a1_2 .* (1 - a1_2)); % logsig'
        delta1 = (pesos2' * delta2) .* (a1_1 .* (1 - a1_1)); % logsig'

        % Ajuste de pesos
        pesos3 = pesos3 + learning_rate * (delta3 * a1_2');
        pesos2 = pesos2 + learning_rate * (delta2 * a1_1');
        pesos1 = pesos1 + learning_rate * (delta1 * data');

        % Imprime el error promedio en la época
        fprintf("Época %d, Error promedio: %.4f\n", epoch, mean(abs(error), 'all'));
    end

    % Muestra los pesos finales
    disp("Pesos finales:");
    disp(pesos1);
    disp(pesos2);
    disp(pesos3);

    % Muestra la salida final
    figure;
    hold on;
    plot(data, 'DisplayName', 'Datos de entrada');
    plot(a1_3, 'DisplayName', 'Salida final');
    legend;
    hold off;

end % Fin de la función principal

main();

%disp("Salida")