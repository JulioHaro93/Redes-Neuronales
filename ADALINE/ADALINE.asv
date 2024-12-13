clc;
format long


global maxE;
global alpha;

if exist('pesos.txt', 'file')==2 
    delete('pesos.txt');
end;

e =0;
allErrors = [];
numerillosAux = [];

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
    if exist('bias.txt', 'file') ==2
        delete('bias.txt')
    end

    disp("Preparando regresor");
    global epoch;
    maxE = 0.000001;
    alpha  = 0.3;
    erroresEpoca = [];
    epocas = [];
    error=0;
    bias = [0.000001;0.000001;0.000001];

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
            
            a = purelin(W, p, bias);
            if a == 0
                continue
            end
           
            t= peso-1;
            e = (t-a)^2;
            errAux =+e;
            
            for i = 1:length(W)
                W(i) = W(i) + (2*alpha*(t-a)*p(i));
                bias(i)= bias(i) + (2*alpha*(t-a));
                try
                    file = fopen("pesos.txt", "a");
                    if file == -1
                        error("No se pudo abrir el archivo.");
                    end

                    fprintf(file, "%f\n", W(i));
                    fclose(file);

                catch ME
                    disp("No se pudo abrir el archivo");
                    disp(ME.message);
                end
                try
                    file = fopen("bias.txt", "a");
                    if file == -1
                        error("No se pudo abrir el archivo.");
                    end

                    fprintf(file, "%f\n", bias(i));
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

    file = fopen("pesos.txt", "r"); 
    
    if file == -1
        error("No se pudo abrir el archivo.");
    end
    pesos =[];
   
    peso1 = [];
    peso2 = [];
    peso3 = [];
    counter = 1; 
    
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
    

    for i = 1:3:length(pesos)
        if i <= length(pesos)
            peso1(end+1) = pesos(i); 
        end
        if i+1 <= length(pesos)
            peso2(end+1) = pesos(i+1);
        end
        if i+2 <= length(pesos)
            peso3(end+1) = pesos(i+2); 
        end
    end
    
    file = fopen("bias.txt", "r"); 
    
    if file == -1
        error("No se pudo abrir el archivo.");
    end
    sesgos =[];
   
    sesgo1 = [];
    sesgo2 = [];
    sesgo3 = [];
    counter = 1; 
    
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
        sesgos(end+1) = value;
        end
    catch ME
        disp("Error al leer el archivo:");
        disp(ME.message);
    end
    
    fclose(file); 
    
    sesgo1 = [];
    sesgo2 = [];
    sesgo3 = [];
    

    for i = 1:3:length(pesos)
        if i <= length(pesos)
            sesgo1(end+1) = pesos(i);
        end
        if i+1 <= length(pesos)
            sesgo2(end+1) = pesos(i+1);
        end
        if i+2 <= length(pesos)
            sesgo3(end+1) = pesos(i+2); 
        end
    end
    
    hold on
    subplot(3,1,1)
    plot(epocas,erroresEpoca), 
    legend('Error cuadrático medio')
    xlabel('Épocas'), ylabel('Errores')
    title('Gráfica de errores para el entrenamiento de ADALINE en modo regresor')
    subplot(3,1,2)

    hold on;
    plot(kEpoch, peso1, 'DisplayName', 'W1');
    plot(kEpoch, peso2, 'DisplayName', 'W2');
    plot(kEpoch, peso3, 'DisplayName', 'W3');
    hold off;
    legend; 
    xlabel('Iteraciones (kEpoch)');
    ylabel('Peso (W)');
    title('Actualizaciones de pesos para el entrenamiento de ADALINE en modo regresor');
    
    subplot(3,1,3)
    hold on;
    plot(kEpoch, sesgo1, 'DisplayName', 'bias1');
    plot(kEpoch, sesgo2, 'DisplayName', 'bias2');
    plot(kEpoch, sesgo3, 'DisplayName', 'bias3');
    hold off;
    legend; 
    xlabel('Iteraciones (kEpoch)');
    ylabel('Bias (sesgos)');
    title('Actualizaciones de bias para el entrenamiento de ADALINE en modo regresor');

    return

end

function clasificador2D()
    global epoch;
    maxE = 0.1;
    alpha  = 0.01;
    erroresEpoca = [];
    epocas = [];
    error=0;
    W = rand(1, 3);  
    list = [];
    
    if exist('pesos.txt', 'file')==2
        try
        delete('pesos.txt');
        catch
            disp("No fue posible eliminar el archivo, tal vez se encuentre abierto")
        end
    end;
    

    list = [];
    kEpoch=[];
    k=1;
    X=[];
    T=[];
    b=[];
    X = readmatrix("./inputs/input_p.txt");
                T = readmatrix("./targets/target_t.txt");
                [num_samples,num_features] = size(X);
                W = rand(1,num_features);
                b= rand(1,num_features);
                errAux = 0;
                aux = 0;
            
                while aux < epoch
                    for peso = 1:size(X, 1)
                    p = X(peso, :);
                    a = purelin(W, p, b);
            
                    t= T(peso);
            
                    e = (t-a)^2;
                    errAux = errAux + e;
            
                    for i = 1:length(W)
                        W(i) = W(i) + (2*alpha*(t-a)*p(i));
                        b(i) = b(i) + (2*alpha*(t-a));
                        try
                            file = fopen("pesos.txt", "a");
                            if file == -1
                                error("No se pudo abrir el archivo.");
                            end
            
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
                    if(peso==8)
                        error = errAux/size(X,1);
                        erroresEpoca =[erroresEpoca; error];
                        epocas = [epocas;aux+1];
                        end
                    k=k+1;
                    kEpoch = [kEpoch, k];
                    end
                    aux = aux + 1;
                    if (error < maxE)
                    disp("Correcto!")
                    disp("Número de épocas: ")
                    disp(aux)
                    break
                end
                end
                
                
                file = fopen("pesos.txt", "r");
                
                if file == -1
                    error("No se pudo abrir el archivo.");
                end
                disp('Pesos entrenados:');
                disp(W);
                disp('Sesgo entrenado:');
                disp(b);
                
                pesos =[];
                peso1 = [];
                peso2 = [];
                counter = 1;
    
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
    
    
                for i = 1:2:length(pesos)
                    if i <= length(pesos)
                        peso1(end+1) = pesos(i);
                    end
                    if i+1 <= length(pesos)
                        peso2(end+1) = pesos(i+1);
                    end
                end
                 
    
                if num_features > 2
                
                    disp('Reduciendo a las dos primeras dimensiones para graficar.');
                    X_plot = X(:, 1:2);
                    W_plot = W(1:2);
                else
                    X_plot = X;
                    W_plot = W;
                end
                    disp("KEPOCH KEPOCH")
                disp(kEpoch);

                subplot(2,1,1)
                plotpv(X_plot', T');
                linehandle = plotpc(W, [0,0]);
                set(linehandle, 'Linestyle', '-');
                mBoundary = -(1/(W_plot(2)/W_plot(1)));
            
                hold on
                quiver(0, 0, W(1), W(2), 0, 'black', 'LineWidth', 2, 'MaxHeadSize', 2);
                hold off;
                hold on
                subplot(2,1,2)
                plot(kEpoch, peso1, 'DisplayName', 'W1');
                plot(kEpoch, peso2, 'DisplayName', 'W2');
                legend('Actualización de pesos por iteración');
                xlabel('t'), ylabel('Pesos');
                title('Actualizaciones de pesos para el entrenamiento para ADALINE en modo clasificador');
                hold off


                hold of

end

function clasificador4D()
    global epoch;
    maxE = 0.1;
    alpha  = 0.000001;
    erroresEpoca = [];
    epocas = [];
    error=0;
    W = rand(1, 3);  
    list = [];
    
    if exist('pesos.txt', 'file')==2
        try
        delete('pesos.txt');
        catch
            disp("No fue posible eliminar el archivo, tal vez se encuentre abierto")
        end
    end;
    


    list = [];
    kEpoch=[];
    k=1;
    X=[];
    T=[];
    b=[];
    X = readmatrix("./inputs/input_p.txt");
                T = readmatrix("./targets/target4clases.txt");
                [num_samples,num_features] = size(X);
                W = rand(1,num_features);
                b= rand(1,num_features);
                errAux = 0;
                aux = 0;
                D1 = [0, 0; 0, 0];  
                D2 = [1, 0; 1, 0]; 
                D3 = [0, 1; 0, 1];  
                D4 = [1, 1; 1, 1];  
                

                T = [D1; D2; D3; D4];
                
                [num_samples, num_features] = size(X);
                num_classes = size(T, 2);
                W = rand(num_classes, num_features);

                while aux < epoch
                    for peso = 1:size(X, 1)
                    p = X(peso, :);
                    a = purelin(W, p, b);
                    a = a';
                    t= T(peso,:);

                    e = (t-a).^2;
                    errAux = errAux + e;
            
                    for i = 1:size(W, 1)
                        for j = 1:size(W, 2)
                        
                            W(i, j) = W(i, j) + (2 * alpha * (t(i) - a(i)) * p(j));
                            b(i) = b(i);
                        try
                            file = fopen("pesos.txt", "a");
                            if file == -1
                                error("No se pudo abrir el archivo.");
                            end
            
                            fprintf(file, "%f\n", W(i,j));
                            fclose(file);
            
                        catch ME
                            disp("No se pudo abrir el archivo");
                            disp(ME.message);
                        end
                        end
                        i=i+5;
                    end
            
                    if (isnan(e) ==1)
                        break
                    end
                    if(peso==8)
                        error = errAux/size(X,1);
                        erroresEpoca =[erroresEpoca; error];
                        epocas = [epocas;aux+1];
                        end
                    k=k+1;
                    kEpoch = [kEpoch, k];
                    end
                    aux = aux + 1;
                    if (error < maxE)
                    disp("Correcto!")
                    disp("Número de épocas: ")
                    disp(aux)
                    break
                end
                end
                
                
                file = fopen("pesos.txt", "r");
                
                if file == -1
                    error("No se pudo abrir el archivo.");
                end
                disp('Pesos entrenados:');
                disp(W);
                disp('Sesgo entrenado:');
                disp(b);
                
                pesos =[];
                peso1 = [];
                peso2 = [];
                counter = 1;
    
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
                peso3 =[];
                peso4=[];
    
                for i = 1:4:length(pesos)
                    if i <= length(pesos)
                        peso1(end+1) = pesos(i);
                    end
                    if i+1 <= length(pesos)
                        peso2(end+1) = pesos(i+1);
                    end
                    if i+2 <= length(pesos)
                        peso3(end+1) = pesos(i+2);
                    end
                    if i+3 <= length(pesos)
                        peso4(end+1) = pesos(i+3)
                    end
                end
                
                if num_features == 2
                    X_plot = X(:, 1:2);
                    W_plot = W(:, 1:2);
                else
                    X_plot = X;
                    W_plot = W;
                end
                
                X_plot = X_plot / max(abs(X_plot(:)));
                W_plot = W_plot / max(abs(W_plot(:)));
                

                subplot(2, 1, 1);
                plotpv(X_plot', T');
                
                hold on;
                for c = 1:size(W_plot, 1)

                    mBoundary = -W_plot(c, 1) / W_plot(c, 2);
                    bBoundary = [0;0];
                    disp(W_plot(c,:))
                    disp(bBoundary);
                    linehandle = plotpc(W_plot(c, :), bBoundary(c));
                    set(linehandle, 'LineStyle', '-');
                    hold off;
                end
                
                hold on
                subplot(2,1,2)
                plot(kEpoch, peso1, 'DisplayName', 'W1');
                plot(kEpoch, peso2, 'DisplayName', 'W2');
                legend('Actualización de pesos por iteración');
                xlabel('t'), ylabel('Pesos');
                title('Actualizaciones de pesos para el entrenamiento para ADALINE en modo clasificador');
                hold off


                hold of

end



function clasificador()
    disp("Clasificador en construcción...");
    
    n = input("Por favor elija alguna de las opciones para el clasificador.\n" + ...
        "para clasificador de 2 clases está las opciones 1\n" + ...
        "para la clasificación de 4 clases están las opciones 2\n" + ...
        "__\n");

    while true
        switch n
            case 1
                disp("Ha elegido modo clasificador para ADALINE para 2 clases distintas");
                clasificador2D();
                break
            case 2
                disp("Ha elegido como clasificador para ADALINE para 4 clases distintas")
                clasificador4D()
                break
            otherwise
                disp("Por favor agregue un dato correcto");
                break
        end
    end

    return

end

%:::::::::::::::::::::::::MENÚ::::::::::::::::::::::

if exist("pesos.txt",'file')==2
    try
        delete("pesos.txt");
        disp("pesos.txt anterior elimiando")
    catch
        disp("No fue posible eliminar el archivo")
    end
end
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