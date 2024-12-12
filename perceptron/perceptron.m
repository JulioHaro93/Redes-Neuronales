clc;
disp("____________EJEMPLO1_______________")


data = readmatrix('input_p.txt.txt');
data2 = readmatrix('target_t.txt.txt');
maxepoch = 100;

n=size(data);



p =[vector1,vector2,vector3,vector4,vector5,vector6,vector7,vector8];


W= rand(n)
b=rand(1)
t = data2';
plotpv(p,t)

i=1;
vectoresSalidas=tuplitaVectorSalida.empty;
for vector = p
    vectorTupla = tuplitaVectorSalida(vector,data2(i));
    i=i+1;
    if(i==0)
        vectoresSalidas(end)=vectorTupla;
    end
    vectoresSalidas(end+1) =vectorTupla;

end
disp(vectoresSalidas(1).vector);
disp(W(1:2)*vectoresSalidas(1).vector);
a = hardlim((W(1:2)*vectoresSalidas(1).vector)+b);

aux2=false;
aux = 1;
while(aux<100 && aux2== false)
    for vector = vectoresSalidas
        if(a == vectoresSalidas(aux).salida)
            disp("hacen match");
            if(aux == length(vectoresSalidas))
                aux2=true;
            end
        else
            disp("multiplica");
            aux2=false;
        end
        if(aux == length(vectoresSalidas))
                aux=1;
        end
        aux=aux+1;
    end
end


linehandle = plotpc(W',b);

%set(linehandle, 'Color', 'r');
%set(linehandle,'Linestyle', '--')



%salida

% 
% x = data(:, 1);
% y = data(:, 2);
% scatter(x,y,'red','filled')
% grid on;
% axis equal;
% xlim([-2 2]);
% xline(0, LineWidth=1.5)
% ylim([-2 2]);
% yline(0,LineWidth=1.5)
% 
% hold on;
% x_line = -2:2;
% y_line = 0.7*x_line;
% plot(x_line, y_line, 'b-', 'LineWidth', 1.5)
% 
% quiver(0,0,-0.5,0.5,LineWidth=2,Color='#000000',MaxHeadSize=2)
% 
% hold off;
% disp("The next step is to find the weights and biases")


%quiver(zeros(size(x)), zeros(size(y)), x, y, 0, 'MaxHeadSize', 0.5);
%xlabel('x');
%ylabel('y');
%title('Vectores en R^2 desde el origen');
%grid on;
%axis equal;

% vector1 = data(1,:)';
% vector2 = data(2,:)';
% vector3 = data(3,:)';
% vector4 = data(4,:)';
% vector5 = data(5,:)';
% vector6 = data(6,:)';
% vector7 = data(7,:)';
% vector8 = data(8,:)';