

%Esta es la red es el ejercicio visto en clase
p=[1.0;1.0;1.0];
s=[3.0;3.0];
w1=[1.0,-1.0,-1.0;1.0,1.0,-1.0];
w2 = [1.0,-0.1;-0.1,1.0];
a1 = (w1 * p) + s;


function [matriz] = poslin(matriz);
[rows,cols] = size(matriz);
for(i = 1:rows);
    for(j = 1:cols);
        if matriz(i,j)<0;
            matriz(i,j) =0;
        else
            continue
        end
    end
end
return;
end

function result = Recursiva(matriz, w)
    aux = w*matriz;
    isEqual = aux == matriz;
    if ((matriz(1) == 0.0 || matriz(2) == 0.0) && (isEqual(2) == 1))
        disp("El resultado es el siguiente:")
        result = matriz;
    else
        matrix = w*matriz;
        result = poslin(matrix);
        result2 = Recursiva(result, w);
    end
end

recursivita = Recursiva(a1, w2);
disp(recursivita)

%Aquí inician la práctica.
disp("_____________________________________________PRACTICA 1 _______________________________________________________")

function result = Recursiva2(matriz, w)
    aux = w*matriz;
    isEqual = aux == matriz;
    containsOne = any(isEqual == 1);
    if ((matriz(1) == 0.0 || matriz(2) == 0.0 || matriz(3) ==0.0 || matriz(4) ==0 || matriz(5) ==0 || matriz (6) ==0 || matriz(7) ==0 ) && (containsOne(1) == 1))
        disp("El resultado es el siguiente:")
        result = matriz
    else
        matrix = w*matriz;
        result = poslin(matrix);
        result2 = Recursiva2(result, w);

    end
end

function nums = generateRandomNumbers()
    nums = randi([-1, 1], 1, 7);
end


%R de 9
s1_2 = [9;9;9;9;9;9;9];


%Valor de P desconocido
p_2 = generateRandomNumbers();
p_2trans = p_2';
disp(p_2trans)
vector1 = generateRandomNumbers;
vector2 = generateRandomNumbers;
vector3 = generateRandomNumbers;
vector4 = generateRandomNumbers;
vector5 = generateRandomNumbers;
vector6 = generateRandomNumbers;
vector7 = generateRandomNumbers;

w1_2 = [vector1;vector2;vector3; vector4; vector5;vector6;vector7];
disp(w1_2)

%Valor de épsilon propuesto
epsilon = -0.8;
m = 7;
w2_2 =[];
w2_2 = epsilon * ones(m);
w2_2(logical(eye(m)))=1;

disp(w2_2);
a2_2 = (w1_2 * p_2trans) + s1_2;
disp(a2_2)

Recursiva2(a2_2,w2_2);

%Aquí inicia el segundo experimento
disp("_____________________________________________PRACTICA 2 _______________________________________________________")
epsilon = -0.5;
disp("Epsilon de -0.5")
m = 7;
w2_2 =[];
w2_2 = epsilon * ones(m);
w2_2(logical(eye(m)))=1;

disp(w2_2);
a2_2 = (w1_2 * p_2trans) + s1_2;
disp(a2_2);

Recursiva2(a2_2,w2_2);

epsilon = -0.3;
disp("Epsilon de -0.3")
m = 7;
w2_2 =[];
w2_2 = epsilon * ones(m);
w2_2(logical(eye(m)))=1;

disp(w2_2);
a2_2 = (w1_2 * p_2trans) + s1_2;
disp(a2_2)

Recursiva2(a2_2,w2_2);

epsilon = -0.1;
disp("Epsilon de -0.1")
m = 7;
w2_2 =[];
w2_2 = epsilon * ones(m);
w2_2(logical(eye(m)))=1;

disp(w2_2);
a2_2 = (w1_2 * p_2trans) + s1_2;
disp(a2_2)

recursiva = Recursiva2(a2_2,w2_2);

disp(recursiva);

disp("_____________________________________________PRACTICA 3 _______________________________________________________");


function result = Iterativa(matriz, w)

for i = 0:99;
    aux = w*matriz;
    isEqual = aux == matriz;
    if ((matriz(1) == 0.0 || matriz(2) == 0.0 || matriz(3) ==0.0 || matriz(4) ==0 || matriz(5) ==0 || matriz (6) ==0 || matriz(7) ==0 ) && (isEqual(2) == 1))
        disp("El resultado es el siguiente:");
        result = matriz;
        disp(result);
        break;
    else
        result = aux;
        continue;
    end
end
end

function num = generateRandomNumber();
    num = rand;
end

function num = generateFixedNumber()
    num = randi([1,10]);
end
fixed = generateFixedNumber();

s1_3 = [fixed;fixed;fixed;fixed;fixed;fixed;fixed]
disp(s1_3 + "s aleatorio")

epsilon3 = -generateRandomNumber();
disp(epsilon3 + "----> episilon aleatorio")
p_3 = generateRandomNumbers();
p_3trans = p_3';
disp(p_3trans + "P aleatorio");

vector1 = generateRandomNumbers;
vector2 = generateRandomNumbers;
vector3 = generateRandomNumbers;
vector4 = generateRandomNumbers;
vector5 = generateRandomNumbers;
vector6 = generateRandomNumbers;
vector7 = generateRandomNumbers;

w1_3 = [vector1;vector2;vector3; vector4; vector5;vector6;vector7]

w2_3 = [];

w2_2 = epsilon3 * ones(m);
w2_2(logical(eye(m)))=1;
disp(w2_2 + "\n w aleatorio");

a2_3 = (w1_3 * p_3trans) + s1_3;
disp(a2_2)

iterativa = Iterativa(a2_3, w2_2);
disp(iterativa);


disp("_____________________________________________PRACTICA 4 _______________________________________________________");
function result = Iterativa2(matriz, w)

for i = 0:9;
    aux = w*matriz;
    isEqual = aux == matriz;
    disp(aux)
    disp("intento"+i);
    if ((matriz(1) == 0.0 || matriz(2) == 0.0 || matriz(3) ==0.0 || matriz(4) ==0 || matriz(5) ==0 || matriz (6) ==0 || matriz(7) ==0 ) && (isEqual(2) == 1))
        disp("El resultado es el siguiente:");
        result = matriz;
        disp(result);
        break;
    else
        result = aux;
        continue;
    end
end
end


p_3trans = [1;-1;1;-1;1;-1;1];

epsilon1 = -0.1;
epsilon4 = 0.1;

vector1 = generateRandomNumbers;
vector2 = generateRandomNumbers;
vector3 = generateRandomNumbers;
vector4 = generateRandomNumbers;
vector5 = generateRandomNumbers;
vector6 = generateRandomNumbers;
vector7 = generateRandomNumbers;

w1_4 = [vector1;vector2;vector3; vector4; vector5;vector6;vector7];
disp(w1_4)

fixed = generateFixedNumber();
s1_4 = [fixed;fixed;fixed;fixed;fixed;fixed;fixed];

disp(s1_4)

a2_4 = (w1_4 * p_3trans) + s1_4;

w2_4_1 = epsilon1 * ones(m);
w2_4_1(logical(eye(m)))=1;
disp(w2_4_1);

w2_4_2 = epsilon4 * ones(m);
w2_4_2(logical(eye(m)))=1;
disp(w2_4_2);

iterativaUno = Iterativa2(a2_4, w2_4_1);
disp(iterativaUno);

iterativoDos = Iterativa2(a2_4, w2_4_2);
disp(iterativoDos);