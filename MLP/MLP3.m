clc;

maxEpoch = 30000;

n=0;

global data
global W

function main()
    % Archivos para guardar y cargar pesos y conteo de ejecuciones
    ejecuciones_file = "ejecuciones.txt";
    pesos1_file = "pesos1.txt";
    pesos2_file = "pesos2.txt";
    pesos3_file = "pesos3.txt";

    % Leer o inicializar número de ejecuciones
    if isfile(ejecuciones_file)
        num_ejecuciones = str2double(fileread(ejecuciones_file));
    else
        num_ejecuciones = 0;
    end

    % Incrementar el contador de ejecuciones y guardarlo
    num_ejecuciones = num_ejecuciones + 1;
    fid = fopen(ejecuciones_file, 'w');
    fprintf(fid, '%d', num_ejecuciones);
    fclose(fid);

    % Lee los datos desde el archivo
    data = readmatrix("Polinomio4.txt"); % Carga los datos (esperado n x 2)

    % Verifica que el archivo tenga dos columnas (entrada y objetivo)
    if size(data, 2) ~= 2
        error("El archivo debe contener exactamente dos columnas: entrada y objetivo.");
    end

    % Inicializa los conjuntos vacíos
    train_data = [];
    val_data = [];
    test_data = [];

    % Longitud del bloque (3 para entrenamiento, 1 para validación, 1 para prueba)
    block_size = 5;

    % Recorre los datos en bloques
    for i = 1:block_size:size(data, 1)
        % Define índices para los bloques
        idx_train = i:min(i+2, size(data, 1)); % Tres datos para entrenamiento
        idx_val = min(i+3, size(data, 1));    % Uno para validación
        idx_test = min(i+4, size(data, 1));   % Uno para prueba

        % Añade los datos correspondientes a cada conjunto
        train_data = [train_data; data(idx_train, :)];
        if idx_val <= size(data, 1)
            val_data = [val_data; data(idx_val, :)];
        end
        if idx_test <= size(data, 1)
            test_data = [test_data; data(idx_test, :)];
        end
    end

    fprintf("Datos de entrenamiento: %d muestras\n", size(train_data, 1));
    fprintf("Datos de validación: %d muestras\n", size(val_data, 1));
    fprintf("Datos de prueba: %d muestras\n", size(test_data, 1));

    % Separa las entradas (P) y los objetivos (target)
    entradas = train_data(:, 1);  % Columna 1: entrada P
    objetivos = train_data(:, 2); % Columna 2: target

    val_entradas = val_data(:, 1);
    val_objetivos = val_data(:, 2);

    % Genera o carga pesos
    num_pesos1 = 16; % Número de neuronas en la primera capa
    num_pesos2 = 14; % Número de neuronas en la segunda capa
    rango_pesos = [0, 0.1];

    if num_ejecuciones == 1
        % Primera ejecución: inicializa aleatoriamente
        pesos1 = rand(num_pesos1, 1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
        pesos2 = rand(num_pesos2, num_pesos1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
        pesos3 = rand(1, num_pesos2) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
    else
        % Cargar pesos desde archivos
        pesos1 = load(pesos1_file);
        pesos2 = load(pesos2_file);
        pesos3 = load(pesos3_file);
    end

    % Parámetros de entrenamiento
    learning_rate = 0.001;
    max_epocas = 3000;
    earlyStopping = [];
    val_errors = [];
    errorTrain=0;
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
            error_total = error_total + error;

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

        % Guarda el error promedio en el conjunto de entrenamiento
        earlyStopping(end + 1) = error_total / length(entradas);

        % Validación cada 10 épocas
        if mod(epoch, 10) == 0
            val_error_total = 0;
            for i = 1:length(val_entradas)
                entrada = val_entradas(i);
                objetivo = val_objetivos(i);

                % Propagación hacia adelante
                a1 = logsig(pesos1 * entrada);
                a2 = logsig(pesos2 * a1);
                salida = purelin(pesos3 * a2);

                % Cálculo del error
                val_error_total = val_error_total + abs(objetivo - salida);
            end

            val_error_promedio = val_error_total / length(val_entradas);
            val_errors(end + 1) = val_error_promedio;
            fprintf("Época %d, Error validación promedio: %.8f\n", epoch, val_error_promedio);
        end
        % Early stopping cada 300 épocas
        if mod(epoch, 300) == 0
            if epoch > 300 && earlyStopping(epoch) > earlyStopping(epoch-200) && earlyStopping(epoch-200) > earlyStopping(epoch-299)
                disp("Error, el error va en crecimiento, se detuvo el programa por early stopping");
                break;
            end
        end
        
        % Imprime el error promedio por época
        fprintf("Época %d, Error entrenamiento promedio: %.8f\n", epoch, error_total / length(entradas));
    end
    error_train = 0;

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
            error_train = error_train + error;

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
    if(errorTrain >0.000001)
        Disp("Los datos no se ajustan al entrenamiento")
    end
    % Guarda los pesos finales
    save(pesos1_file, 'pesos1', '-ascii');
    save(pesos2_file, 'pesos2', '-ascii');
    save(pesos3_file, 'pesos3', '-ascii');

    % Muestra los pesos finales
    disp("Pesos finales:");
    disp("Pesos capa 1:");
    disp(pesos1);
    disp("Pesos capa 2:");
    disp(pesos2);
    disp("Pesos capa 3:");
    disp(pesos3);

    
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
