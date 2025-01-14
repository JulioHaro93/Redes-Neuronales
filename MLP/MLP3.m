clc;

maxEpoch = 30000;

n=0;

global data
global W


function UnoSuno()
num_val = 0;
ejecuciones_file = "./polinomio3/1S1/ejecuciones.txt";
pesos1_file = "./polinomio3/1S1/pesos1.txt";
pesos2_file = "./polinomio3/1S1/pesos2.txt";
bias1_file = "./polinomio3/1S1/bias1.txt";
bias2_file = "./polinomio3/1S1/bias2.txt";

if isfile(ejecuciones_file)
    num_ejecuciones = str2double(fileread(ejecuciones_file));
else
    num_ejecuciones = 0;
end

num_ejecuciones = num_ejecuciones + 1;
fid = fopen(ejecuciones_file, 'w');
fprintf(fid, '%d', num_ejecuciones);
fclose(fid);

data = readmatrix("./Polinomios/Polinomio3.txt");

if size(data, 2) ~= 2
    error("El archivo debe contener exactamente dos columnas: entrada y objetivo.");
end

train_data = [];
val_data = [];
test_data = [];

block_size = 5;

for i = 1:block_size:size(data, 1)
    idx_train = i:min(i+2, size(data, 1));
    idx_val = min(i+3, size(data, 1));
    idx_test = min(i+4, size(data, 1));

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

entradas = train_data(:, 1);
objetivos = train_data(:, 2);

val_entradas = val_data(:, 1);
val_objetivos = val_data(:, 2);

num_pesos1 = 16;
rango_pesos = [-1, 1];

if num_ejecuciones == 1
    pesos1 = rand(num_pesos1, 1) * diff(rango_pesos) + rango_pesos(1);
    pesos2 = rand(1, num_pesos1) * diff(rango_pesos) + rango_pesos(1);
    bias1 = rand(num_pesos1, 1) * diff(rango_pesos) + rango_pesos(1);
    bias2 = rand(1, 1) * diff(rango_pesos) + rango_pesos(1);
else
    pesos1 = load(pesos1_file);
    pesos2 = load(pesos2_file);
    bias1 = load(bias1_file);
    bias2 = load(bias2_file);
end

learning_rate = 0.01;
max_epocas = input("Ingrese el valor máximo de épocas: ");
earlyStopping = [];
val_errors = [];

for epoch = 1:max_epocas
    error_total = 0;

    for i = 1:length(entradas)
        entrada = entradas(i);
        objetivo = objetivos(i);

        a1 = logsig(pesos1 * entrada + bias1);
        salida = purelin(pesos2 * a1 + bias2);

        error = objetivo - salida;
        error_total = error_total + error;

        delta2 = error;
        delta1 = (pesos2' * delta2) .* a1 .* (1 - a1);

        pesos2 = pesos2 + learning_rate * delta2 * a1';
        pesos1 = pesos1 + learning_rate * delta1 * entrada;
        bias2 = bias2 + learning_rate * delta2;
        bias1 = bias1 + learning_rate * delta1;
    end

    earlyStopping(end + 1) = error_total / length(entradas);

    if mod(epoch, 50) == 0
        val_error_total = 0;
        for i = 1:length(val_entradas)
            entrada = val_entradas(i);
            objetivo = val_objetivos(i);

            a1 = logsig(pesos1 * entrada + bias1);
            salida = purelin(pesos2 * a1 + bias2);

            val_error_total = val_error_total + abs(objetivo - salida);
        end
        if earlyStopping(epoch) > earlyStopping(epoch-5)
            num_val = num_val + 1;
        else
            num_val = 0;
        end
        if num_val == 5
            disp("Detenido por earlyStopping");
            disp(epoch)
            break;
        end
        val_errors(end + 1) = val_error_total / length(val_entradas);
    end
end

save(pesos1_file, 'pesos1', '-ascii');
save(pesos2_file, 'pesos2', '-ascii');
save(bias1_file, 'bias1', '-ascii');
save(bias2_file, 'bias2', '-ascii');

salidas_finales = zeros(length(entradas), 1);

for i = 1:length(entradas)
    entrada = entradas(i);
    a1 = logsig(pesos1 * entrada + bias1);
    salidas_finales(i) = purelin(pesos2 * a1 + bias2);
end

figure;
plot(entradas, objetivos, 'o', 'DisplayName', 'Objetivo');
hold on;
plot(entradas, salidas_finales, 'x', 'DisplayName', 'Salida final');
legend;
title('Comparación entre objetivo y salida final');
xlabel('Entrada');
ylabel('Salida');
hold off;

figure;
plot(earlyStopping, '-', 'DisplayName', 'Error de entrenamiento');
title('Error de entrenamiento por época');
xlabel('Época');
ylabel('Error');
legend;
end

function UnoSSuno()
num_val = 0;
ejecuciones_file = "./polinomio2/1SS1/ejecuciones.txt";
pesos1_file = "./polinomio2/1SS1/pesos1.txt";
pesos2_file = "./polinomio2/1SS1/pesos2.txt";
pesos3_file = "./polinomio2/1SS1/pesos3.txt";
bias1_file = "./polinomio2/1SS1/bias1.txt";
bias2_file = "./polinomio2/1SS1/bias2.txt";
bias3_file = "./polinomio2/1SS1/bias3.txt";

if isfile(ejecuciones_file)
    num_ejecuciones = str2double(fileread(ejecuciones_file));
else
    num_ejecuciones = 0;
end

num_ejecuciones = num_ejecuciones + 1;
fid = fopen(ejecuciones_file, 'w');
fprintf(fid, '%d', num_ejecuciones);
fclose(fid);

data = readmatrix("./Polinomios/Polinomio2.txt");

if size(data, 2) ~= 2
    error("El archivo debe contener exactamente dos columnas: entrada y objetivo.");
end

train_data = [];
val_data = [];
test_data = [];

block_size = 5;

for i = 1:block_size:size(data, 1)
    idx_train = i:min(i+2, size(data, 1));
    idx_val = min(i+3, size(data, 1));
    idx_test = min(i+4, size(data, 1));

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

entradas = train_data(:, 1);
objetivos = train_data(:, 2);

val_entradas = val_data(:, 1);
val_objetivos = val_data(:, 2);

num_pesos1 = 16;
num_pesos2 = 14;
rango_pesos = [-1, 1];

if num_ejecuciones == 1
    pesos1 = rand(num_pesos1, 1) * diff(rango_pesos) + rango_pesos(1);
    pesos2 = rand(num_pesos2, num_pesos1) * diff(rango_pesos) + rango_pesos(1);
    pesos3 = rand(1, num_pesos2) * diff(rango_pesos) + rango_pesos(1);
    bias1 = rand(num_pesos1, 1) * diff(rango_pesos) + rango_pesos(1);
    bias2 = rand(num_pesos2, 1) * diff(rango_pesos) + rango_pesos(1);
    bias3 = rand(1, 1) * diff(rango_pesos) + rango_pesos(1);
else
    pesos1 = load(pesos1_file);
    pesos2 = load(pesos2_file);
    pesos3 = load(pesos3_file);
    bias1 = load(bias1_file);
    bias2 = load(bias2_file);
    bias3 = load(bias3_file);
end

learning_rate = 0.01;
max_epocas = input("Ingrese el valor máximo de épocas: ");
earlyStopping = [];
val_errors = [];

for epoch = 1:max_epocas
    error_total = 0;

    for i = 1:length(entradas)
        entrada = entradas(i);
        objetivo = objetivos(i);

        a1 = logsig(pesos1 * entrada + bias1);
        a2 = logsig(pesos2 * a1 + bias2);
        salida = purelin(pesos3 * a2 + bias3);

        error = objetivo - salida;
        error_total = error_total + error;

        delta3 = error;
        delta2 = (pesos3' * delta3) .* a2 .* (1 - a2);
        delta1 = (pesos2' * delta2) .* a1 .*(1 - a1);

        pesos3 = pesos3 + learning_rate * delta3 * a2';
        pesos2 = pesos2 + learning_rate * delta2 * a1';
        pesos1 = pesos1 + learning_rate * delta1 * entrada;
        bias3 = bias3 + learning_rate * delta3;
        bias2 = bias2 + learning_rate * delta2;
        bias1 = bias1 + learning_rate * delta1;
    end

    earlyStopping(end + 1) = error_total / length(entradas);

    if mod(epoch, 10) == 0
        val_error_total = 0;
        for i = 1:length(val_entradas)
            entrada = val_entradas(i);
            objetivo = val_objetivos(i);

            a1 = logsig(pesos1 * entrada + bias1);
            a2 = logsig(pesos2 * a1 + bias2);
            salida = purelin(pesos3 * a2 + bias3);

            val_error_total = val_error_total + abs(objetivo - salida);
        end
        if earlyStopping(epoch) > earlyStopping(epoch-5)
            num_val = num_val + 1;
        else
            num_val = 0;
        end
        if num_val == 3
            disp("Detenido por earlyStopping");
            disp(epoch)
            break;
        end

        val_errors(end + 1) = val_error_total / length(val_entradas);
    end
end

save(pesos1_file, 'pesos1', '-ascii');
save(pesos2_file, 'pesos2', '-ascii');
save(pesos3_file, 'pesos3', '-ascii');
save(bias1_file, 'bias1', '-ascii');
save(bias2_file, 'bias2', '-ascii');
save(bias3_file, 'bias3', '-ascii');

salidas_finales = zeros(length(entradas), 1);

for i = 1:length(entradas)
    entrada = entradas(i);
    a1 = logsig(pesos1 * entrada + bias1);
    a2 = logsig(pesos2 * a1 + bias2);
    salidas_finales(i) = purelin(pesos3 * a2 + bias3);
end

figure;
plot(entradas, objetivos, 'o', 'DisplayName', 'Objetivo');
hold on;
plot(entradas, salidas_finales, 'x', 'DisplayName', 'Salida final');
legend;
title('Comparación entre objetivo y salida final');
xlabel('Entrada');
ylabel('Salida');
hold off;

figure;
plot(earlyStopping, '-', 'DisplayName', 'Error de entrenamiento');
title('Error de entrenamiento por época');
xlabel('Época');
ylabel('Error');
legend;
end



function polinomio_1()

disp("Para elegir el perceptrón multicapa de una capa seleccione 1")
disp("Para elegir el perceptrón multicapa de dos capas seleccione 2")
n = input(": ");
switch n
    case 1
        UnoSuno()
    case 2
        UnoSSuno()
    case 3
        disp("regresando al menú principal")
    otherwise
        disp("No tengo esa opción")
end
end


function UnoSUno_2()
num_val = 0;
ejecuciones_file = "./polinomio2/1S1/ejecuciones.txt";
pesos1_file = "./polinomio2/1S1/pesos1.txt";
pesos2_file = "./polinomio2/1S1/pesos2.txt";
bias1_file = "./polinomio2/1S1/bias1.txt";
bias2_file = "./polinomio2/1S1/bias2.txt";

if isfile(ejecuciones_file)
    num_ejecuciones = str2double(fileread(ejecuciones_file));
else
    num_ejecuciones = 0;
end

num_ejecuciones = num_ejecuciones + 1;
fid = fopen(ejecuciones_file, 'w');
fprintf(fid, '%d', num_ejecuciones);
fclose(fid);

data = readmatrix("./Polinomios/Polinomio2.txt");

if size(data, 2) ~= 2
    error("El archivo debe contener exactamente dos columnas: entrada y objetivo.");
end


train_data = [];
val_data = [];
test_data = [];
block_size = 5;

for i = 1:block_size:size(data, 1)
    idx_train = i:min(i+2, size(data, 1));
    idx_val = min(i+3, size(data, 1));
    idx_test = min(i+4, size(data, 1));
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

entradas = train_data(:, 1);  
objetivos = train_data(:, 2); 

val_entradas = val_data(:, 1);
val_objetivos = val_data(:, 2);


R = 1; 
S1 = 16; 
S2 = 1;
rango_pesos = [-1, 1];

% Pesos 1
if isfile(pesos1_file)
    pesos1 = load(pesos1_file);
else
    pesos1 = rand(S1, R) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Bias 1
if isfile(bias1_file)
    bias1 = load(bias1_file);
else
    bias1 = rand(S1, 1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Pesos 2
if isfile(pesos2_file)
    pesos2 = load(pesos2_file);
else
    pesos2 = rand(S2, S1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Bias 2
if isfile(bias2_file)
    bias2 = load(bias2_file);
else
    bias2 = rand(S2, 1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

learning_rate = 0.01;
max_epocas = 5000;
earlyStopping = [];
val_errors = [];

for epoch = 1:max_epocas
    error_total = 0;

    for i = 1:length(entradas)
        entrada = entradas(i);
        objetivo = objetivos(i);

        % Propagación hacia adelante
        a1 = logsig(pesos1 * entrada + bias1);
        salida = purelin(pesos2 * a1 + bias2);

        % Cálculo del error
        error = objetivo - salida;
        error_total = error_total + error;

        % Ajuste de pesos y bias
        delta2 = error;
        pesos2 = pesos2 + learning_rate * (delta2 * a1');
        bias2 = bias2 + learning_rate * delta2;

        delta1 = (pesos2' * delta2) .* a1 .* (1 - a1); % logsig backprop
        pesos1 = pesos1 + learning_rate * (delta1 * entrada);
        bias1 = bias1 + learning_rate * delta1;
    end

    earlyStopping(end + 1) = error_total / length(entradas);

    if mod(epoch, 10) == 0
        val_error_total = 0;
        for i = 1:length(val_entradas)
            entrada = val_entradas(i);
            objetivo = val_objetivos(i);
            a1 = logsig(pesos1 * entrada + bias1);
            salida = purelin(pesos2 * a1 + bias2);
            val_error_total = val_error_total + abs(objetivo - salida);
        end
        val_errors(end + 1) = val_error_total / length(val_entradas);
    end

    if mod(epoch, 10) == 0 && epoch > 40 && earlyStopping(epoch) > earlyStopping(epoch - 1)
        num_val = num_val + 1;
    else
        num_val = 0;
    end

    if num_val >= 20
        disp("Error en crecimiento, deteniendo por early stopping.");
        break;
    end
end


save(pesos1_file, 'pesos1', '-ascii');
save(pesos2_file, 'pesos2', '-ascii');
save(bias1_file, 'bias1', '-ascii');
save(bias2_file, 'bias2', '-ascii');

salidas_finales = zeros(length(entradas), 1);
for i = 1:length(entradas)
    a1 = logsig(pesos1 * entradas(i) + bias1);
    salidas_finales(i) = purelin(pesos2 * a1 + bias2);
end

figure;
plot(entradas, objetivos, 'o', 'DisplayName', 'Objetivo');
hold on;
plot(entradas, salidas_finales, 'x', 'DisplayName', 'Salida final');
legend;
title('Comparación entre objetivo y salida final');
xlabel('Entrada');
ylabel('Salida');
hold off;

figure;
plot(earlyStopping, '-', 'DisplayName', 'Error de entrenamiento');
title('Error de entrenamiento por época');
xlabel('Época');
ylabel('Error');
legend;
end


function UnoSSuno_2()
num_val = 0;
ejecuciones_file = "./polinomio2/1SS1/ejecuciones.txt";
pesos1_file = "./polinomio2/1SS1/pesos1.txt";
pesos2_file = "./polinomio2/1SS1/pesos2.txt";
pesos3_file = "./polinomio2/1SS1/pesos3.txt";
bias1_file = "./polinomio2/1SS1/bias1.txt";
bias2_file = "./polinomio2/1SS1/bias2.txt";
bias3_file = "./polinomio2/1SS1/bias3.txt";

% Leer o inicializar número de ejecuciones
if isfile(ejecuciones_file)
    num_ejecuciones = str2double(fileread(ejecuciones_file));
else
    num_ejecuciones = 0;
end

num_ejecuciones = num_ejecuciones + 1;
fid = fopen(ejecuciones_file, 'w');
fprintf(fid, '%d', num_ejecuciones);
fclose(fid);

data = readmatrix("./Polinomios/Polinomio2.txt");

if size(data, 2) ~= 2
    error("El archivo debe contener exactamente dos columnas: entrada y objetivo.");
end

train_data = [];
val_data = [];
test_data = [];

block_size = 5;


for i = 1:block_size:size(data, 1)
    idx_train = i:min(i+2, size(data, 1));
    idx_val = min(i+3, size(data, 1));
    idx_test = min(i+4, size(data, 1));

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

entradas = train_data(:, 1);
objetivos = train_data(:, 2);

val_entradas = val_data(:, 1);
val_objetivos = val_data(:, 2);

num_pesos1 = 16;
num_pesos2 = 14;
rango_pesos = [-1, 1];

if num_ejecuciones == 1
    pesos1 = rand(num_pesos1, 1) * diff(rango_pesos) + rango_pesos(1);
    pesos2 = rand(num_pesos2, num_pesos1) * diff(rango_pesos) + rango_pesos(1);
    pesos3 = rand(1, num_pesos2) * diff(rango_pesos) + rango_pesos(1);
    bias1 = rand(num_pesos1, 1) * diff(rango_pesos) + rango_pesos(1);
    bias2 = rand(num_pesos2, 1) * diff(rango_pesos) + rango_pesos(1);
    bias3 = rand(1, 1) * diff(rango_pesos) + rango_pesos(1);
else
    pesos1 = load(pesos1_file);
    pesos2 = load(pesos2_file);
    pesos3 = load(pesos3_file);
    bias1 = load(bias1_file);
    bias2 = load(bias2_file);
    bias3 = load(bias3_file);
end

learning_rate = 0.3;
max_epocas = 5000;
earlyStopping = [];
val_errors = [];

for epoch = 1:max_epocas
    error_total = 0;

    for i = 1:length(entradas)
        entrada = entradas(i);
        objetivo = objetivos(i);

        % Propagación hacia adelante
        a1 = logsig(pesos1 * entrada + bias1);
        a2 = logsig(pesos2 * a1 + bias2);
        salida = purelin(pesos3 * a2 + bias3);

        % Cálculo del error
        error = objetivo - salida;
        error_total = error_total + error;

        % Backpropagation
        delta3 = error;
        delta2 = (pesos3' * delta3) .* a2 .* (1 - a2);
        delta1 = (pesos2' * delta2) .* a1 .*(1 - a1);

        % Actualización de pesos y bias
        pesos3 = pesos3 + learning_rate * delta3 * a2';
        pesos2 = pesos2 + learning_rate * delta2 * a1';
        pesos1 = pesos1 + learning_rate * delta1 * entrada;
        bias3 = bias3 + learning_rate * delta3;
        bias2 = bias2 + learning_rate * delta2;
        bias1 = bias1 + learning_rate * delta1;
    end

    earlyStopping(end + 1) = error_total / length(entradas);

    if mod(epoch, 1200) == 0
        val_error_total = 0;
        for i = 1:length(val_entradas)
            entrada = val_entradas(i);
            objetivo = val_objetivos(i);

            a1 = logsig(pesos1 * entrada + bias1);
            a2 = logsig(pesos2 * a1 + bias2);
            salida = purelin(pesos3 * a2 + bias3);

            val_error_total = val_error_total + abs(objetivo - salida);
        end
        if earlyStopping(epoch) > earlyStopping(epoch-1000)
            num_val = num_val +1;
        else
            num_val =0;
        end
        if num_val ==5
            disp(num_val)
            disp("Detenido por earlyStopping")
            break
        end
        val_errors(end + 1) = val_error_total / length(val_entradas);
    end
end


save(pesos1_file, 'pesos1', '-ascii');
save(pesos2_file, 'pesos2', '-ascii');
save(pesos3_file, 'pesos3', '-ascii');
save(bias1_file, 'bias1', '-ascii');
save(bias2_file, 'bias2', '-ascii');
save(bias3_file, 'bias3', '-ascii');
salidas_finales = zeros(length(entradas), 1);

salidas_finales = zeros(length(entradas), 1);
for i = 1:length(entradas)
    entrada = entradas(i);
    a1 = logsig(pesos1 * entrada + bias1);
    a2 = logsig(pesos2 * a1 + bias2);
    salidas_finales(i) = purelin(pesos3 * a2 + bias3);
end

figure;
plot(entradas, objetivos, 'o', 'DisplayName', 'Objetivo');
hold on;
plot(entradas, salidas_finales, 'x', 'DisplayName', 'Salida final');
legend;
title('Comparación entre objetivo y salida final');
xlabel('Entrada');
ylabel('Salida');
hold off;

figure;
plot(earlyStopping, '-', 'DisplayName', 'Error de entrenamiento');
title('Error de entrenamiento por época');
xlabel('Época');
ylabel('Error');
legend;
end


function polinomio_2()
disp("Para elegir el perceptrón multicapa de una capa seleccione 1")
disp("Para elegir el perceptrón multicapa de una capa seleccione 2")
n = input(": ");
switch n
    case 1
        UnoSUno_2()
    case 2
        UnoSSuno_2()
    case 3
        disp("regresando al menú principal")
    otherwise
        disp("No tengo esa opción")
end
end


function UnoSUno_3()
num_val = 0;
ejecuciones_file = "./polinomio3/1S1/ejecuciones.txt";
pesos1_file = "./polinomio3/1S1/pesos1.txt";
pesos2_file = "./polinomio3/1S1/pesos2.txt";
bias1_file = "./polinomio3/1S1/bias1.txt";
bias2_file = "./polinomio3/1S1/bias2.txt";

% Leer o inicializar número de ejecuciones
if isfile(ejecuciones_file)
    num_ejecuciones = str2double(fileread(ejecuciones_file));
else
    num_ejecuciones = 0;
end

num_ejecuciones = num_ejecuciones + 1;
fid = fopen(ejecuciones_file, 'w');
fprintf(fid, '%d', num_ejecuciones);
fclose(fid);

data = readmatrix("./Polinomios/Polinomio3.txt");

if size(data, 2) ~= 2
    error("El archivo debe contener exactamente dos columnas: entrada y objetivo.");
end

train_data = [];
val_data = [];
test_data = [];
block_size = 5;

for i = 1:block_size:size(data, 1)
    idx_train = i:min(i+2, size(data, 1));
    idx_val = min(i+3, size(data, 1));
    idx_test = min(i+4, size(data, 1));
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

entradas = train_data(:, 1);  
objetivos = train_data(:, 2); 

val_entradas = val_data(:, 1);
val_objetivos = val_data(:, 2);


R = 1;
S1 = 16;
S2 = 1;
rango_pesos = [-1, 1];

% Pesos 1
if isfile(pesos1_file)
    pesos1 = load(pesos1_file);
else
    pesos1 = rand(S1, R) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Bias 1
if isfile(bias1_file)
    bias1 = load(bias1_file);
else
    bias1 = rand(S1, 1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Pesos 2
if isfile(pesos2_file)
    pesos2 = load(pesos2_file);
else
    pesos2 = rand(S2, S1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Bias 2
if isfile(bias2_file)
    bias2 = load(bias2_file);
else
    bias2 = rand(S2, 1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

learning_rate = 0.01;
max_epocas = 5000;
earlyStopping = [];
val_errors = [];
epochs =[];
for epoch = 1:max_epocas
    error_total = 0;

    for i = 1:length(entradas)
        entrada = entradas(i);
        objetivo = objetivos(i);

        % Propagación hacia adelante
        a1 = logsig(pesos1 * entrada + bias1);
        salida = purelin(pesos2 * a1 + bias2);

        % Cálculo del error
        error = objetivo - salida;
        error_total = error_total + error;

        % Ajuste de pesos y bias
        delta2 = error;
        pesos2 = pesos2 + learning_rate * (delta2 * a1');
        bias2 = bias2 + learning_rate * delta2;

        delta1 = (pesos2' * delta2) .* a1 .* (1 - a1); % logsig backprop
        pesos1 = pesos1 + learning_rate * (delta1 * entrada);
        bias1 = bias1 + learning_rate * delta1;
    end

    % Guardar el error
    earlyStopping(end + 1) = error_total / length(entradas);

    if mod(epoch, 10) == 0
        val_error_total = 0;
        for i = 1:length(val_entradas)
            entrada = val_entradas(i);
            objetivo = val_objetivos(i);
            a1 = logsig(pesos1 * entrada + bias1);
            salida = purelin(pesos2 * a1 + bias2);
            val_error_total = val_error_total + abs(objetivo - salida);
        end
        val_errors(end + 1) = val_error_total / length(val_entradas);
    end

    if mod(epoch, 10) == 0 && epoch > 40 && earlyStopping(epoch) > earlyStopping(epoch - 1)
        num_val = num_val + 1;
    else
        num_val = 0;
    end

    if num_val >= 20
        disp("Error en crecimiento, deteniendo por early stopping.");
        break;
    end
    epochs(end +1) = epoch;
end
disp(val_errors);
disp(epochs)

% Guardar los pesos y bias finales
save(pesos1_file, 'pesos1', '-ascii');
save(pesos2_file, 'pesos2', '-ascii');
save(bias1_file, 'bias1', '-ascii');
save(bias2_file, 'bias2', '-ascii');

% Comparar salidas finales
salidas_finales = zeros(length(entradas), 1);
for i = 1:length(entradas)
    a1 = logsig(pesos1 * entradas(i) + bias1);
    salidas_finales(i) = purelin(pesos2 * a1 + bias2);
end

figure;
plot(entradas, objetivos, 'o', 'DisplayName', 'Objetivo');
hold on;
plot(entradas, salidas_finales, 'x', 'DisplayName', 'Salida final');
legend;
title('Comparación entre objetivo y salida final');
xlabel('Entrada');
ylabel('Salida');
hold off;

figure;
plot(earlyStopping, '-', 'DisplayName', 'Error de entrenamiento');

title('Error de entrenamiento por época');
xlabel('Época');
ylabel('Error');
legend;

end

function UnoSSuno_3()
num_val = 0;
ejecuciones_file = "./polinomio3/1SS1/ejecuciones.txt";
pesos1_file = "./polinomio3/1SS1/pesos1.txt";
pesos2_file = "./polinomio3/1SS1/pesos2.txt";
bias1_file = "./polinomio3/1SS1/bias1.txt";
bias2_file = "./polinomio3/1SS1/bias2.txt";

if isfile(ejecuciones_file)
    num_ejecuciones = str2double(fileread(ejecuciones_file));
else
    num_ejecuciones = 0;
end

num_ejecuciones = num_ejecuciones + 1;
fid = fopen(ejecuciones_file, 'w');
fprintf(fid, '%d', num_ejecuciones);
fclose(fid);

data = readmatrix("./Polinomios/Polinomio3.txt");

if size(data, 2) ~= 2
    error("El archivo debe contener exactamente dos columnas: entrada y objetivo.");
end

train_data = [];
val_data = [];
test_data = [];
block_size = 5;

for i = 1:block_size:size(data, 1)
    idx_train = i:min(i+2, size(data, 1));
    idx_val = min(i+3, size(data, 1));
    idx_test = min(i+4, size(data, 1));
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

entradas = train_data(:, 1);  
objetivos = train_data(:, 2); 

val_entradas = val_data(:, 1);
val_objetivos = val_data(:, 2);


R = 1;
S1 = 16;
S2 = 1;
rango_pesos = [-1, 1];

% Pesos 1
if isfile(pesos1_file)
    pesos1 = load(pesos1_file);
else
    pesos1 = rand(S1, R) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Bias 1
if isfile(bias1_file)
    bias1 = load(bias1_file);
else
    bias1 = rand(S1, 1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Pesos 2
if isfile(pesos2_file)
    pesos2 = load(pesos2_file);
else
    pesos2 = rand(S2, S1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Bias 2
if isfile(bias2_file)
    bias2 = load(bias2_file);
else
    bias2 = rand(S2, 1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

learning_rate = 0.01;
max_epocas = 5000;
earlyStopping = [];
val_errors = [];

for epoch = 1:max_epocas
    error_total = 0;

    for i = 1:length(entradas)
        entrada = entradas(i);
        objetivo = objetivos(i);

        % Propagación hacia adelante
        a1 = logsig(pesos1 * entrada + bias1);
        salida = purelin(pesos2 * a1 + bias2);

        % Cálculo del error
        error = objetivo - salida;
        error_total = error_total + error;

        % Ajuste de pesos y bias
        delta2 = error;
        pesos2 = pesos2 + learning_rate * (delta2 * a1');
        bias2 = bias2 + learning_rate * delta2;

        delta1 = (pesos2' * delta2) .* a1 .* (1 - a1);
        pesos1 = pesos1 + learning_rate * (delta1 * entrada);
        bias1 = bias1 + learning_rate * delta1;
    end

    earlyStopping(end + 1) = error_total / length(entradas);

    if mod(epoch, 10) == 0
        val_error_total = 0;
        for i = 1:length(val_entradas)
            entrada = val_entradas(i);
            objetivo = val_objetivos(i);
            a1 = logsig(pesos1 * entrada + bias1);
            salida = purelin(pesos2 * a1 + bias2);
            val_error_total = val_error_total + abs(objetivo - salida);
        end
        val_errors(end + 1) = val_error_total / length(val_entradas);
    end

    if mod(epoch, 10) == 0 && epoch > 40 && earlyStopping(epoch) > earlyStopping(epoch - 1)
        num_val = num_val + 1;
    else
        num_val = 0;
    end

    if num_val >= 20
        disp("Error en crecimiento, deteniendo por early stopping.");
        break;
    end
end

save(pesos1_file, 'pesos1', '-ascii');
save(pesos2_file, 'pesos2', '-ascii');
save(bias1_file, 'bias1', '-ascii');
save(bias2_file, 'bias2', '-ascii');

salidas_finales = zeros(length(entradas), 1);
for i = 1:length(entradas)
    a1 = logsig(pesos1 * entradas(i) + bias1);
    salidas_finales(i) = purelin(pesos2 * a1 + bias2);
end

figure;
plot(entradas, objetivos, 'o', 'DisplayName', 'Objetivo');
hold on;
plot(entradas, salidas_finales, 'x', 'DisplayName', 'Salida final');
legend;
title('Comparación entre objetivo y salida final');
xlabel('Entrada');
ylabel('Salida');
hold off;

figure;
plot(epochs, earlyStopping, '-', 'DisplayName', 'Error de entrenamiento');

title('Error de entrenamiento por época');
xlabel('Época');
ylabel('Error');
legend;

end

function polinomio_3()

disp("Para elegir el perceptrón multicapa de una capa seleccione 1")
disp("Para elegir el perceptrón multicapa de dos capas seleccione 2")
n = input(": ");
switch n
    case 1
        UnoSUno_3()
    case 2
        UnoSSuno_3()
    case 3
        disp("regresando al menú principal")
    otherwise
        disp("No tengo esa opción")
end
end


function UnoSUno_4()
num_val = 0;
ejecuciones_file = "./polinomio4/1S1/ejecuciones.txt";
pesos1_file = "./polinomio4/1S1/pesos1.txt";
pesos2_file = "./polinomio4/1S1/pesos2.txt";
bias1_file = "./polinomio4/1S1/bias1.txt";
bias2_file = "./polinomio4/1S1/bias2.txt";

% Leer o inicializar número de ejecuciones
if isfile(ejecuciones_file)
    num_ejecuciones = str2double(fileread(ejecuciones_file));
else
    num_ejecuciones = 0;
end

num_ejecuciones = num_ejecuciones + 1;
fid = fopen(ejecuciones_file, 'w');
fprintf(fid, '%d', num_ejecuciones);
fclose(fid);

data = readmatrix("./Polinomios/Polinomio4.txt");

if size(data, 2) ~= 2
    error("El archivo debe contener exactamente dos columnas: entrada y objetivo.");
end

train_data = [];
val_data = [];
test_data = [];
block_size = 5;

for i = 1:block_size:size(data, 1)
    idx_train = i:min(i+2, size(data, 1));
    idx_val = min(i+3, size(data, 1));
    idx_test = min(i+4, size(data, 1));
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

entradas = train_data(:, 1);  
objetivos = train_data(:, 2); 

val_entradas = val_data(:, 1);
val_objetivos = val_data(:, 2);

R = 1;
S1 = 16;
S2 = 1;
rango_pesos = [-1, 1];

% Pesos 1
if isfile(pesos1_file)
    pesos1 = load(pesos1_file);
else
    pesos1 = rand(S1, R) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Bias 1
if isfile(bias1_file)
    bias1 = load(bias1_file);
else
    bias1 = rand(S1, 1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Pesos 2
if isfile(pesos2_file)
    pesos2 = load(pesos2_file);
else
    pesos2 = rand(S2, S1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Bias 2
if isfile(bias2_file)
    bias2 = load(bias2_file);
else
    bias2 = rand(S2, 1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

learning_rate = 0.01;
max_epocas = 5000;
earlyStopping = [];
val_errors = [];
epochs =[];
for epoch = 1:max_epocas
    error_total = 0;

    for i = 1:length(entradas)
        entrada = entradas(i);
        objetivo = objetivos(i);

        % Propagación hacia adelante
        a1 = logsig(pesos1 * entrada + bias1);
        salida = purelin(pesos2 * a1 + bias2);

        % Cálculo del error
        error = objetivo - salida;
        error_total = error_total + error;

        % Ajuste de pesos y bias
        delta2 = error;
        pesos2 = pesos2 + learning_rate * (delta2 * a1');
        bias2 = bias2 + learning_rate * delta2;

        delta1 = (pesos2' * delta2) .* a1 .* (1 - a1); % logsig backprop
        pesos1 = pesos1 + learning_rate * (delta1 * entrada);
        bias1 = bias1 + learning_rate * delta1;
    end


    earlyStopping(end + 1) = error_total / length(entradas);

    if mod(epoch, 10) == 0
        val_error_total = 0;
        for i = 1:length(val_entradas)
            entrada = val_entradas(i);
            objetivo = val_objetivos(i);
            a1 = logsig(pesos1 * entrada + bias1);
            salida = purelin(pesos2 * a1 + bias2);
            val_error_total = val_error_total + abs(objetivo - salida);
        end
        val_errors(end + 1) = val_error_total / length(val_entradas);
    end

    if mod(epoch, 10) == 0 && epoch > 40 && earlyStopping(epoch) > earlyStopping(epoch - 1)
        num_val = num_val + 1;
    else
        num_val = 0;
    end

    if num_val >= 20
        disp("Error en crecimiento, deteniendo por early stopping.");
        break;
    end
    epochs(end +1) = epoch;
end
disp(val_errors);
disp(epochs);

save(pesos1_file, 'pesos1', '-ascii');
save(pesos2_file, 'pesos2', '-ascii');
save(bias1_file, 'bias1', '-ascii');
save(bias2_file, 'bias2', '-ascii');

% Comparar salidas finales
salidas_finales = zeros(length(entradas), 1);
for i = 1:length(entradas)
    a1 = logsig(pesos1 * entradas(i) + bias1);
    salidas_finales(i) = purelin(pesos2 * a1 + bias2);
end

figure;
plot(entradas, objetivos, 'o', 'DisplayName', 'Objetivo');
hold on;
plot(entradas, salidas_finales, 'x', 'DisplayName', 'Salida final');
legend;
title('Comparación entre objetivo y salida final');
xlabel('Entrada');
ylabel('Salida');
hold off;

figure;
plot(earlyStopping, '-', 'DisplayName', 'Error de entrenamiento');

title('Error de entrenamiento por época');
xlabel('Época');
ylabel('Error');
legend;

end

function UnoSSuno_4()
num_val = 0;
ejecuciones_file = "./polinomio4/1SS1/ejecuciones.txt";
pesos1_file = "./polinomio4/1SS1/pesos1.txt";
pesos2_file = "./polinomio4/1SS1/pesos2.txt";
pesos3_file = "./polinomio4/1SS1/pesos3.txt";
bias1_file = "./polinomio4/1SS1/bias1.txt";
bias2_file = "./polinomio4/1SS1/bias2.txt";
bias3_file = "./polinomio4/1SS1/bias3.txt";


if isfile(ejecuciones_file)
    num_ejecuciones = str2double(fileread(ejecuciones_file));
else
    num_ejecuciones = 0;
end

num_ejecuciones = num_ejecuciones + 1;
fid = fopen(ejecuciones_file, 'w');
fprintf(fid, '%d', num_ejecuciones);
fclose(fid);

data = readmatrix("./Polinomios/Polinomio4.txt");

if size(data, 2) ~= 2
    error("El archivo debe contener exactamente dos columnas: entrada y objetivo.");
end

train_data = [];
val_data = [];
test_data = [];

block_size = 5;

for i = 1:block_size:size(data, 1)
    idx_train = i:min(i+2, size(data, 1));
    idx_val = min(i+3, size(data, 1));
    idx_test = min(i+4, size(data, 1));

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

entradas = train_data(:, 1);
objetivos = train_data(:, 2);

val_entradas = val_data(:, 1);
val_objetivos = val_data(:, 2);


num_pesos1 = 16;
num_pesos2 = 14;
rango_pesos = [-1, 1];

if num_ejecuciones == 1
    pesos1 = rand(num_pesos1, 1) * diff(rango_pesos) + rango_pesos(1);
    pesos2 = rand(num_pesos2, num_pesos1) * diff(rango_pesos) + rango_pesos(1);
    pesos3 = rand(1, num_pesos2) * diff(rango_pesos) + rango_pesos(1);
    bias1 = rand(num_pesos1, 1) * diff(rango_pesos) + rango_pesos(1);
    bias2 = rand(num_pesos2, 1) * diff(rango_pesos) + rango_pesos(1);
    bias3 = rand(1, 1) * diff(rango_pesos) + rango_pesos(1);
else
    pesos1 = load(pesos1_file);
    pesos2 = load(pesos2_file);
    pesos3 = load(pesos3_file);
    bias1 = load(bias1_file);
    bias2 = load(bias2_file);
    bias3 = load(bias3_file);
end

learning_rate = 0.01;
max_epocas = 5000;
earlyStopping = [];
val_errors = [];

for epoch = 1:max_epocas
    error_total = 0;

    for i = 1:length(entradas)
        entrada = entradas(i);
        objetivo = objetivos(i);

        % Propagación hacia adelante
        a1 = logsig(pesos1 * entrada + bias1);
        a2 = logsig(pesos2 * a1 + bias2);
        salida = purelin(pesos3 * a2 + bias3);

        % Cálculo del error
        error = objetivo - salida;
        error_total = error_total + error;

        % Backpropagation
        delta3 = error;
        delta2 = (pesos3' * delta3) .* a2 .* (1 - a2);
        delta1 = (pesos2' * delta2) .* a1 .*(1 - a1);

        % Actualización de pesos y bias
        pesos3 = pesos3 + learning_rate * delta3 * a2';
        pesos2 = pesos2 + learning_rate * delta2 * a1';
        pesos1 = pesos1 + learning_rate * delta1 * entrada;
        bias3 = bias3 + learning_rate * delta3;
        bias2 = bias2 + learning_rate * delta2;
        bias1 = bias1 + learning_rate * delta1;
    end

    earlyStopping(end + 1) = error_total / length(entradas);

    if mod(epoch, 6600) == 0
        val_error_total = 0;
        for i = 1:length(val_entradas)
            entrada = val_entradas(i);
            objetivo = val_objetivos(i);

            a1 = logsig(pesos1 * entrada + bias1);
            a2 = logsig(pesos2 * a1 + bias2);
            salida = purelin(pesos3 * a2 + bias3);

            val_error_total = val_error_total + abs(objetivo - salida);
        end
        if earlyStopping(epoch) > earlyStopping(epoch-1000)
            num_val = num_val +1;
        else
            num_val =0;
        end
        if num_val ==5
            disp(num_val)
            disp("Detenido por earlyStopping")
            break
        end

        val_errors(end + 1) = val_error_total / length(val_entradas);
    end
end

% Guardar pesos y bias
save(pesos1_file, 'pesos1', '-ascii');
save(pesos2_file, 'pesos2', '-ascii');
save(pesos3_file, 'pesos3', '-ascii');
save(bias1_file, 'bias1', '-ascii');
save(bias2_file, 'bias2', '-ascii');
save(bias3_file, 'bias3', '-ascii');
salidas_finales = zeros(length(entradas), 1);

salidas_finales = zeros(length(entradas), 1);
for i = 1:length(entradas)
    entrada = entradas(i);
    a1 = logsig(pesos1 * entrada + bias1);
    a2 = logsig(pesos2 * a1 + bias2);
    salidas_finales(i) = purelin(pesos3 * a2 + bias3);
end

figure;
plot(entradas, objetivos, 'o', 'DisplayName', 'Objetivo');
hold on;
plot(entradas, salidas_finales, 'x', 'DisplayName', 'Salida final');
legend;
title('Comparación entre objetivo y salida final');
xlabel('Entrada');
ylabel('Salida');
hold off;

figure;
plot(earlyStopping, '-', 'DisplayName', 'Error de entrenamiento');
title('Error de entrenamiento por época');
xlabel('Época');
ylabel('Error');
legend;

end


function UnoSSSuno_4()
num_val = 0;
ejecuciones_file = "./polinomio4/1SSS1/ejecuciones.txt";
pesos1_file = "./polinomio4/1SSS1/pesos1.txt";
pesos2_file = "./polinomio4/1SSS1/pesos2.txt";
pesos3_file = "./polinomio4/1SSS1/pesos3.txt";
bias1_file = "./polinomio4/1SSS1/bias1.txt";
bias2_file = "./polinomio4/1SSS1/bias2.txt";
bias3_file = "./polinomio4/1SSS1/bias3.txt";


if isfile(ejecuciones_file)
    num_ejecuciones = str2double(fileread(ejecuciones_file));
else
    num_ejecuciones = 0;
end

num_ejecuciones = num_ejecuciones + 1;
fid = fopen(ejecuciones_file, 'w');
fprintf(fid, '%d', num_ejecuciones);
fclose(fid);

data = readmatrix("./Polinomios/Polinomio4.txt");

if size(data, 2) ~= 2
    error("El archivo debe contener exactamente dos columnas: entrada y objetivo.");
end

train_data = [];
val_data = [];
test_data = [];
block_size = 5;

for i = 1:block_size:size(data, 1)
    idx_train = i:min(i+2, size(data, 1));
    idx_val = min(i+3, size(data, 1));
    idx_test = min(i+4, size(data, 1));
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

entradas = train_data(:, 1);  
objetivos = train_data(:, 2); 

val_entradas = val_data(:, 1);
val_objetivos = val_data(:, 2);


R = 1;
S1 = 10;
S2 = 10;
S3 = 1;
rango_pesos = [-1, 1];

% Pesos 1
if isfile(pesos1_file)
    pesos1 = load(pesos1_file);
else
    pesos1 = rand(S1, R) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Bias 1
if isfile(bias1_file)
    bias1 = load(bias1_file);
else
    bias1 = rand(S1, 1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Pesos 2
if isfile(pesos2_file)
    pesos2 = load(pesos2_file);
else
    pesos2 = rand(S2, S1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Bias 2
if isfile(bias2_file)
    bias2 = load(bias2_file);
else
    bias2 = rand(S2, 1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Pesos 3
if isfile(pesos3_file)
    pesos3 = load(pesos3_file);
else
    pesos3 = rand(S3, S2) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

% Bias 3
if isfile(bias3_file)
    bias3 = load(bias3_file);
else
    bias3 = rand(S3, 1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
end

learning_rate = 0.01;
max_epocas = 5000;
earlyStopping = [];
val_errors = [];

for epoch = 1:max_epocas
    error_total = 0;

    for i = 1:length(entradas)
        entrada = entradas(i);
        objetivo = objetivos(i);

        % Propagación hacia adelante
        a1 = logsig(pesos1 * entrada + bias1);
        a2 = logsig(pesos2 * a1 + bias2);
        salida = purelin(pesos3 * a2 + bias3);

        % Cálculo del error
        error = objetivo - salida;
        error_total = error_total + error;

        % Ajuste de pesos y bias
        delta3 = error;
        pesos3 = pesos3 + learning_rate * (delta3 * a2');
        bias3 = bias3 + learning_rate * delta3;

        delta2 = (pesos3' * delta3) .* a2 .* (1 - a2); % logsig backprop
        pesos2 = pesos2 + learning_rate * (delta2 * a1');
        bias2 = bias2 + learning_rate * delta2;

        delta1 = (pesos2' * delta2) .* a1 .* (1 - a1); % logsig backprop
        pesos1 = pesos1 + learning_rate * (delta1 * entrada);
        bias1 = bias1 + learning_rate * delta1;
    end


    earlyStopping(end + 1) = error_total / length(entradas);

    if mod(epoch, 10) == 0
        val_error_total = 0;
        for i = 1:length(val_entradas)
            entrada = val_entradas(i);
            objetivo = val_objetivos(i);
            a1 = logsig(pesos1 * entrada + bias1);
            a2 = logsig(pesos2 * a1 + bias2);
            salida = purelin(pesos3 * a2 + bias3);
            val_error_total = val_error_total + abs(objetivo - salida);
        end
        val_errors(end + 1) = val_error_total / length(val_entradas);
    end

    if mod(epoch, 10) == 0 && epoch > 40 && earlyStopping(epoch) > earlyStopping(epoch - 1)
        num_val = num_val + 1;
    else
        num_val = 0;
    end

    if num_val >= 20
        disp("Error en crecimiento, deteniendo por early stopping.");
        break;
    end
end

save(pesos1_file, 'pesos1', '-ascii');
save(pesos2_file, 'pesos2', '-ascii');
save(pesos3_file, 'pesos3', '-ascii');
save(bias1_file, 'bias1', '-ascii');
save(bias2_file, 'bias2', '-ascii');
save(bias3_file, 'bias3', '-ascii');

salidas_finales = zeros(length(entradas), 1);
for i = 1:length(entradas)
    a1 = logsig(pesos1 * entradas(i) + bias1);
    a2 = logsig(pesos2 * a1 + bias2);
    salidas_finales(i) = purelin(pesos3 * a2 + bias3);
end

figure;
plot(entradas, objetivos, 'o', 'DisplayName', 'Objetivo');
hold on;
plot(entradas, salidas_finales, 'x', 'DisplayName', 'Salida final');
legend;
title('Comparación entre objetivo y salida final');
xlabel('Entrada');
ylabel('Salida');
hold off;

figure;
plot(1:length(earlyStopping), earlyStopping, '-', 'DisplayName', 'Error de entrenamiento');
title('Error de entrenamiento por época');
xlabel('Época');
ylabel('Error');
legend;

end




function polinomio_4()
disp("Para elegir el perceptrón multicapa de una capa seleccione 1")
disp("Para elegir el perceptrón multicapa de dos capas seleccione 2")
disp("Para elegir el perceptrón multicapa de tres capas selecciones 3")
n = input(": ");
switch n
    case 1
        UnoSUno_4()
    case 2
        UnoSSuno_4()
    case 3
        UnoSSSuno_4()
    case 4
        disp("regresando al menú principal")
    otherwise
        disp("No tengo esa opción")
end
end

function polinomio_5()
num_val=0;
ejecuciones_file = "./polinomio5/ejecuciones.txt";
pesos1_file = "./polinomio5/pesos1.txt";
pesos2_file = "./polinomio5/pesos2.txt";
pesos3_file = "./polinomio5/pesos3.txt";
pesos4_file = "./polinomio5/pesos4.txt";


if isfile(ejecuciones_file)
    num_ejecuciones = str2double(fileread(ejecuciones_file));
else
    num_ejecuciones = 0;
end

num_ejecuciones = num_ejecuciones + 1;
fid = fopen(ejecuciones_file, 'w');
fprintf(fid, '%d', num_ejecuciones);
fclose(fid);
errores =[];
data = readmatrix("./Polinomios/Polinomio5.txt");

if size(data, 2) ~= 2
    error("El archivo debe contener exactamente dos columnas: entrada y target");
end

train_data = [];
val_data = [];
test_data = [];

block_size = 5;


for i = 1:block_size:size(data, 1)
    
    idx_train = i:min(i+2, size(data, 1));
    idx_val = min(i+3, size(data, 1));
    idx_test = min(i+4, size(data, 1));
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


entradas = train_data(:, 1);
objetivos = train_data(:, 2);

val_entradas = val_data(:, 1);
val_objetivos = val_data(:, 2);


num_pesos1 = 10;
num_pesos2 = 10; 
num_pesos3 = 10;
num_pesos4 = 2;
rango_pesos = [0.5, 1];

if num_ejecuciones == 1

    pesos1 = rand(num_pesos1, 1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
    pesos2 = rand(num_pesos2, num_pesos1) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
    pesos3 = rand(num_pesos3, num_pesos2) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
    pesos4 = rand(1, num_pesos4) * (rango_pesos(2) - rango_pesos(1)) + rango_pesos(1);
else

    pesos1 = load(pesos1_file);
    pesos2 = load(pesos2_file);
    pesos3 = load(pesos3_file);
    pesos4 = load(pesos4_file);
end

learning_rate = 0.0007;
max_epocas = 5000;
earlyStopping = [];
val_errors = [];
errorTrain=0;
for epoch = 1:max_epocas
    error_total = 0;

    for i = 1:length(entradas)
        % Propagación hacia adelante
        entrada = entradas(i);
        objetivo = objetivos(i);

        % Capa 1
        a1 = logsig(pesos1 * entrada);
        % Capa 2
        a2 = logsig(pesos2 * a1);
        % Capa 3 (salida final)
        a3 = logsig(pesos3 * a2);
        salida = purelin(pesos4 * a3);

        error = objetivo - salida;

        error_total = error_total + error;


        % Backpropagation
        delta4 = error;
        delta3 = (pesos4' * delta4).*(a3.*(1-a3));
        delta2 = (pesos3' * delta3) .* (a2 .* (1 - a2));
        delta1 = (pesos2' * delta2) .* (a1 .* (1 - a1));

        % Ajuste de pesos
        pesos4 = pesos4 + learning_rate * (delta4 * a3');
        pesos3 = pesos3 + learning_rate * (delta3 * a2');
        pesos2 = pesos2 + learning_rate * (delta2 * a1');
        pesos1 = pesos1 + learning_rate * (delta1 * entrada);
    end

    earlyStopping(end + 1) = error_total / length(entradas);

    if mod(epoch, 24) == 0
        val_error_total = 0;
        for i = 1:length(val_entradas)
            entrada = val_entradas(i);
            objetivo = val_objetivos(i);

            a1 = logsig(pesos1 * entrada);
            a2 = logsig(pesos2 * a1);
            salida = purelin(pesos3 * a2);
            val_error_total = val_error_total + abs(objetivo - salida);
        end

        val_error_promedio = val_error_total / length(val_entradas);
    end

    if mod(epoch, 25) == 0
        disp("valdar epoch")
        if epoch > 50 && earlyStopping(epoch) > earlyStopping(epoch-1)
            disp(earlyStopping(epoch));
            disp(earlyStopping(epoch-1));
            num_val = num_val+1;
            disp(num_val);
        else
            num_val=0;
        end
    end
    if(num_val >=20)
        disp(num_val);
        disp("Error, el error va en crecimiento, se detuvo el programa por early stopping");
        break;
    end
end
error_train = 0;

for i = 1:length(entradas)

    % Propagación hacia adelante
    entrada = entradas(i);
    objetivo = objetivos(i);

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
    delta3 = error;
    delta2 = (pesos3' * delta3) .* (a2 .* (1 - a2));
    delta1 = (pesos2' * delta2) .* (a1 .* (1 - a1));

    % Ajuste de pesos
    pesos3 = pesos3 + learning_rate * (delta3 * a2');
    pesos2 = pesos2 + learning_rate * (delta2 * a1');
    pesos1 = pesos1 + learning_rate * (delta1 * entrada);
end
if(error_train <0.004)
    disp("ha terminado el aprendizaje")
else

end

save(pesos1_file, 'pesos1', '-ascii');
save(pesos2_file, 'pesos2', '-ascii');
save(pesos3_file, 'pesos3', '-ascii');
save(pesos4_file, 'pesos4', '-ascii');
salidas_finales = zeros(length(entradas), 1);
for i = 1:length(entradas)
    entrada = entradas(i);
    a1 = logsig(pesos1 * entrada);
    a2 = logsig(pesos2 * a1);
    a3 = logsig(pesos3 * a2);

    % Asegura dimensiones correctas
    pesos4 = pesos4(:)';
    a3 = a3(:);

    salidas_finales(i) = purelin(pesos4 * a3);
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
figure;
hold on;
plot(earlyStopping, '-', 'DisplayName','Objetivo');
hold off;
end


function main()

while 4<5
    disp("Elija un valor del 1 al 5 para evaluar el aprendizaje")
    disp("del perceptrón multicapa. El número de elección es el mismo número que se elije para el polinomio.")
    disp("ara terminar la ejecución del programa, escriba 0")
    eleccion =input("Teclee un valor: ");
    switch eleccion
        case 1
            disp("Ha elejido aproximar el polinomio 1");
            polinomio_1();

        case 2
            disp("Ha elegido aproximar el polinomio 2");
            polinomio_2();
        case 3
            disp("Ha elegido aproximar el polinomio 3");
            polinomio_3();
        case 4
            disp("Ha elegido aproximar el polinomio 4");
            polinomio_4();
        case 5
            disp("Ha elegido aproximar el polinomio 5");
            polinomio_5();
        case 0
            disp("Ha decidido  termiar el programa");
            break
        otherwise
            disp("No tengo esa opción")

    end

end
end



main();
