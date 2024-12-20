clc;

maxEpoch = 30;

n=0;

global data
global W

function main()
    % Lee los datos del archivo de texto
    data = readmatrix("Polinomio1.txt");

    % Genera los pesos iniciales de manera aleatoria y escalados al formato deseado
    num_pesos = 2; % Cantidad de filas en el formato dado
    rango_pesos = [0.68, 0.71]; % Rango de pesos aproximado
    pesos = rand(num_pesos, 2) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
    
    % Imprime los pesos iniciales generados
    disp("Pesos iniciales generados:");
    disp(pesos);

    % Gráfica de los datos iniciales
    figure;
    hold on;
    plot(data, 'DisplayName', 'Datos de entrada');
    legend;
    hold off;

    % Iteraciones (épocas) de entrenamiento
    n = 0;
    max_epocas = 30;
    while n < max_epocas
        % Propagación hacia adelante
        a1_1 = logsig(data);          % Primera transformación
        a1_2 = logsig(a1_1 * pesos); % Segunda transformación con pesos
        a1_3 = purelin(a1_2);        % Salida lineal

        % Muestra la salida en cada época
        disp("Salida en la época " + n + ":");
        disp(a1_3);

        % Incrementa la cuenta de épocas
        n = n + 1;
    end % Fin del while de épocas
end % Fin de la función principal

main();

disp("Salida")