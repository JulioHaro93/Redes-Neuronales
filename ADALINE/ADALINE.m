clc;
format long

p = readmatrix('input_p.txt');
t = readmatrix('output_t.txt');
global maxE;
global alpha;

if exist('pesos.txt', 'file')==2 
    delete('pesos.txt');
end;

e =0;
allErrors = [];
numerillosAux = [];

% Función de pérdida
function j = J(y, ypred)
    j = (y - ypred)^2;
end

% LMS
function [w, b] = LMS(W, B, p, alpha, e)
    w = W + 2 * alpha * e * p';
    b = B + 2 * alpha * e;
end

% Purelin
function a = purelin(W, p, b)
    a = W * p';
    return
end

global epoch
epoch = 100;  

function erroresEpoca= regresor()
    if exist('pesos.txt', 'file')==2 
    delete('pesos.txt');
    end;

    disp("Preparando regresor");
    global epoch;
    maxE = 0.000001;
    alpha  = 0.3;
    erroresEpoca = [];
    epocas = [];
    error=0;
    
    list = [];
    kEpoch=[];
    k=1;
    r = input("Agregue el número de bits: ");
    W = rand(1, r);
   
    for i = 1:2^r
        numerillo = dec2bin(i - 1, r); 
        list = [list; numerillo];
    end

    numMatrix = double(list) - double('0');
    list = numMatrix;  
    W=[];
    for letra = 1:r
        W = [W, rand];
    end
    errAux = 0;
    aux = 0;

    while aux < epoch
        for peso = 1:size(list, 1)
            p = list(peso, :);
            
            
            a = purelin(W, p, [0; 0; 0]);
            if a == 0
                continue
            end
           
            t= peso-1;
            e = (t-a)^2;
            errAux =+e;
            
            for i = 1:length(W)
                W(i) = W(i) + (2*alpha*(t-a)*p(i));
                try
                    file = fopen("pesos.txt", "a");
                    if file == -1
                        error("No se pudo abrir el archivo.");
                    end
                    disp(W(i))
                    fprintf(file, "%f\n", W(i));
                    fclose(file);

                catch ME
                    disp("No se pudo abrir el archivo");
                    disp(ME.message);
                end
                i=i+3;
            end
            
            if (isnan(e) ==1)
                break
            end
            if(t==7)
                error = errAux/size(list,1);
                erroresEpoca =[erroresEpoca; error];
                epocas = [epocas;aux+1];
            end
        k=k+1
        kEpoch = [kEpoch, k];
        end
        aux = aux + 1;

    if (error < maxE && t==7)
        disp("Correcto!")
        disp("Número de épocas: ")
        disp(aux)
        
        break
    end

    end

    file = fopen("pesos.txt", "r"); % Abrir el archivo en modo de lectura
    
    if file == -1
        error("No se pudo abrir el archivo.");
    end
    pesos =[];
    % Inicializar listas para almacenar los pesos
    peso1 = [];
    peso2 = [];
    peso3 = [];
    counter = 1; % Contador para asignar valores de forma cíclica
    
    try
    while ~feof(file)
        line = strtrim(fgets(file)); 

        if contains(line, "=") 
            parts = split(line, "=");
            value = str2double(strtrim(parts{2})); 
        elseif ~isempty(line)
            value = str2double(line); 
        else
            continue;
        end
        pesos(end+1) = value;
        end
    catch ME
        disp("Error al leer el archivo:");
        disp(ME.message);
    end
    
    fclose(file); 
    
    peso1 = [];
    peso2 = [];
    peso3 = [];
    
    % Asignar valores cíclicamente a las listas
    for i = 1:3:length(pesos)
        if i <= length(pesos)
            peso1(end+1) = pesos(i); % Primer peso
        end
        if i+1 <= length(pesos)
            peso2(end+1) = pesos(i+1);
        end
        if i+2 <= length(pesos)
            peso3(end+1) = pesos(i+2); 
        end
    end
    
    hold on
    subplot(2,1,1)
    plot(epocas,erroresEpoca), 
    legend('Error cuadrático medio')
    xlabel('Épocas'), ylabel('Errores')
    title('Gráfica de errores para el entrenamiento de ADALINE en modo regresor')
    subplot(2,1,2)

    hold on;
    plot(kEpoch, peso1, 'DisplayName', 'W1');
    plot(kEpoch, peso2, 'DisplayName', 'W2');
    plot(kEpoch, peso3, 'DisplayName', 'W3');
    hold off;
    legend; 
    xlabel('Iteraciones (kEpoch)');
    ylabel('Peso (W)');
    title('Actualizaciones de pesos para el entrenamiento de ADALINE en modo regresor');

    % subplot(2,1,2)
    % plot(kEpoch,peso1)
    % legend('Actualización de pesos por iteración');
    % xlabel('W1'), ylabel('t');
    % title('Actualizaciones de pesos para el entrenamiento de ADALINE en modo regresor');
    % 
    % subplot(2,1,3)
    % plot(kEpoch,peso2)
    % legend('Actualización de pesos por iteración');
    % xlabel('W2'), ylabel('t');
    % title('Actualizaciones de pesos para el entrenamiento de ADALINE en modo regresor');
    % 
    % subplot(2,1,4)
    % plot(kEpoch,peso3)
    % legend('Actualización de pesos por iteración');
    % xlabel('W3'), ylabel('t');
    % title('Actualizaciones de pesos para el entrenamiento de ADALINE en modo regresor');
    % hold of

    return

end



% Clasificador
function clasificador()
    disp("Clasificador en construcción...");

    global epoch;
    maxE = 0.000001;
    alpha  = 0.3;
    erroresEpoca = [];
    epocas = [];
    error=0;
    W = rand(1, 3);  
    list = [];
    
    if exist('pesos.txt', 'file')==2 
    delete('pesos.txt');
    end;

    list = [];
    kEpoch=[];
    k=1;
    r = input("Agregue el número de bits: ");
    W = rand(1, r);
   
    for i = 1:2^r
        numerillo = dec2bin(i - 1, r);
        list = [list; numerillo];
    end

    numMatrix = double(list) - double('0');
    list = numMatrix;  
    W=[];
    for letra = 1:r
        W = [W, rand];
    end
    errAux = 0;
    aux = 0;

    while aux < epoch
        for peso = 1:size(list, 1)
            p = list(peso, :);
            
            
            a = purelin(W, p, [0; 0; 0]);
            if a == 0
                continue
            end
           
            t= peso-1;
            e = (t-a)^2;
            errAux =+e;
            
            for i = 1:length(W)
                W(i) = W(i) + (2*alpha*(t-a)*p(i));
                try
                    file = fopen("pesos.txt", "a");
                    if file == -1
                        error("No se pudo abrir el archivo.");
                    end
                    disp(W(i))
                    fprintf(file, "%f\n", W(i));
                    fclose(file);

                catch ME
                    disp("No se pudo abrir el archivo");
                    disp(ME.message);
                end
                i=i+3;
            end
            
            if (isnan(e) ==1)
                break
            end
            if(t==7)
                error = errAux/size(list,1);
                erroresEpoca =[erroresEpoca; error];
                epocas = [epocas;aux+1];
            end
        k=k+1
        kEpoch = [kEpoch, k];
        end
        aux = aux + 1;

    if (error < maxE && t==7)
        disp("Correcto!")
        disp("Número de épocas: ")
        disp(aux)
        
        break
    end

    end

    file = fopen("pesos.txt", "r"); % Abrir el archivo en modo de lectura
    
    if file == -1
        error("No se pudo abrir el archivo.");
    end
    pesos =[];
    % Inicializar listas para almacenar los pesos
    peso1 = [];
    peso2 = [];
    peso3 = [];
    counter = 1; % Contador para asignar valores de forma cíclica
    
    try
    while ~feof(file)
        line = strtrim(fgets(file)); 

        if contains(line, "=") 
            parts = split(line, "=");
            value = str2double(strtrim(parts{2})); 
        elseif ~isempty(line)
            value = str2double(line); 
        else
            continue;
        end
        pesos(end+1) = value;
        end
    catch ME
        disp("Error al leer el archivo:");
        disp(ME.message);
    end
    
    fclose(file); 
    
    peso1 = [];
    peso2 = [];
    peso3 = [];
    
    % Asignar valores cíclicamente a las listas
    for i = 1:3:length(pesos)
        if i <= length(pesos)
            peso1(end+1) = pesos(i); % Primer peso
        end
        if i+1 <= length(pesos)
            peso2(end+1) = pesos(i+1);
        end
        if i+2 <= length(pesos)
            peso3(end+1) = pesos(i+2); 
        end
    end
    
    hold on
    subplot(2,1,1)
    plot(epocas,erroresEpoca), 
    legend('Error cuadrático medio')
    xlabel('Épocas'), ylabel('Errores')
    title('Gráfica de errores para el entrenamiento de ADALINE en modo regresor')
    subplot(2,1,2)

    hold on;
    plot(kEpoch, peso1, 'DisplayName', 'W1');
    plot(kEpoch, peso2, 'DisplayName', 'W2');
    plot(kEpoch, peso3, 'DisplayName', 'W3');
    hold off;
    legend; 
    xlabel('Iteraciones (kEpoch)');
    ylabel('Peso (W)');
    title('Actualizaciones de pesos para el entrenamiento de ADALINE en modo regresor');

    % subplot(2,1,2)
    % plot(kEpoch,peso1)
    % legend('Actualización de pesos por iteración');
    % xlabel('W1'), ylabel('t');
    % title('Actualizaciones de pesos para el entrenamiento de ADALINE en modo regresor');
    % 
    % subplot(2,1,3)
    % plot(kEpoch,peso2)
    % legend('Actualización de pesos por iteración');
    % xlabel('W2'), ylabel('t');
    % title('Actualizaciones de pesos para el entrenamiento de ADALINE en modo regresor');
    % 
    % subplot(2,1,4)
    % plot(kEpoch,peso3)
    % legend('Actualización de pesos por iteración');
    % xlabel('W3'), ylabel('t');
    % title('Actualizaciones de pesos para el entrenamiento de ADALINE en modo regresor');
    % hold of

    return

end

% Menú principal
while true
    disp("Adaline en construcción...");
    n = input("Para modo clasificador teclee 1\nPara modo regresor teclee 2\nPara salir escriba 0\n");
    
    switch n
        case 1
            disp("Ha elegido modo clasificador para ADALINE");
            clasificador();
        case 2
            disp("Ha elegido modo regresor para ADALINE");
            r = regresor();
            disp("Errores generados:");
            disp(r);
        case 0
            break
        otherwise
            disp("Por favor agregue un dato correcto");
    end
end

disp("Ha finalizado el programa.");