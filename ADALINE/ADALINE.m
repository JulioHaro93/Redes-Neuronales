clc;
format long

p = readmatrix('input_p.txt');
t = readmatrix('output_t.txt');
global maxE;
global alpha;

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

global 
epoch = 100;  

function erroresEpoca= regresor()
    global epoch;
    maxE = 0.000001;
    alpha  = 0.3;
    erroresEpoca = [];
    epocas = [];
    error=0;
    W = rand(1, 3);  
    list = [];
    
    r = input("Agregue el número de bits: ");
    
  
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
            end
            if (isnan(e) ==1)
                break
            end
            if(t==7)
                error = errAux/size(list,1);
                erroresEpoca =[erroresEpoca; error];
                epocas = [epocas;aux+1];
            end
        end
        aux = aux + 1;
    if (error < maxE && t==7)
        disp("Correcto!")
        disp("Número de épocas: ")
        disp(aux)
        
        break
    end
    end
    plot(epocas,erroresEpoca), 
    legend('Error cuadrático medio')
    xlabel('Épocas'), ylabel('Errores')
    title('Gráfica de errores para el entrenamiento de ADALINE en modo regresor')
    return

end



% Clasificador
function clasificador()
    disp("Clasificador en construcción...");
end

% Adaline
function Adaline()
    disp("Adaline en construcción...");
end

% Menú principal
while true
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