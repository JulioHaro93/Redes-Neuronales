clc;

maxEpoch = 30000;

n=0;

global data
global W

function main()
    % Lee los datos desde el archivo
    data = readmatrix("Polinomio5.txt"); % Carga los datos (esperado n x 2)
    
    % Validación del formato de datos
    if size(data, 2) ~= 2
        error("El archivo debe contener exactamente dos columnas: entrada y objetivo.");
    end

    % Separa las entradas (P) y los objetivos (target)
    entradas = data(:, 1);  % Columna 1: entrada P
    objetivos = data(:, 2); % Columna 2: target

    % Genera pesos iniciales aleatorios
    num_pesos1 = 16; % Número de neuronas en la primera capa
    num_pesos2 = 14; % Número de neuronas en la segunda capa
    rango_pesos = [0, 0.1];
    pesos1 = rand(num_pesos1, 1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
    pesos2 = rand(num_pesos2, num_pesos1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
    pesos3 = rand(1, num_pesos2) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);

    % Parámetros de entrenamiento
    learning_rate = 0.01;
    max_epocas = 300000;

    for epoch = 1:max_epocas
        error_total = 0;
        
        for i = 1:length(entradas)
            % Propagación hacia adelante
            entrada = entradas(i); % Entrada actual
            objetivo = objetivos(i); % Target correspondiente

            % Capa 1
            a1 = logsig(pesos1 * entrada);
            % Capa 2
            a2 = logsig(pesos2 * a1);
            % Capa 3 (salida final)
            salida = purelin(pesos3 * a2);

            % Cálculo del error
            error = objetivo - salida;
            error_total = error_total + abs(error);

            % Backpropagation
            % Gradientes
            delta3 = error; % Derivada de purelin es 1
            delta2 = (pesos3' * delta3) .* (a2 .* (1 - a2));
            delta1 = (pesos2' * delta2) .* (a1 .* (1 - a1));

            % Ajuste de pesos
            pesos3 = pesos3 + learning_rate * (delta3 * a2');
            pesos2 = pesos2 + learning_rate * (delta2 * a1');
            pesos1 = pesos1 + learning_rate * (delta1 * entrada);
        end

        % Imprime el error promedio por época
        fprintf("Época %d, Error promedio: %.4f\n", epoch, error_total / length(entradas));
    end

    % Muestra los pesos finales
    disp("Pesos finales:");
    disp("Pesos capa 1:");
    disp(pesos1);
    disp("Pesos capa 2:");
    disp(pesos2);
    disp("Pesos capa 3:");
    disp(pesos3);

    % Gráfica de la salida final vs objetivo
    salidas_finales = zeros(length(entradas), 1);
    for i = 1:length(entradas)
        entrada = entradas(i);
        a1 = logsig(pesos1 * entrada);
        a2 = logsig(pesos2 * a1);
        salidas_finales(i) = purelin(pesos3 * a2);
    end

    figure;
    plot(entradas, objetivos, 'b-', 'DisplayName', 'Objetivo');
    hold on;
    plot(entradas, salidas_finales, 'r--', 'DisplayName', 'Salida final');
    legend;
    title('Comparación entre objetivo y salida final');
    xlabel('Entrada');
    ylabel('Salida');
    hold off;
end

main();

%disp("Salida")