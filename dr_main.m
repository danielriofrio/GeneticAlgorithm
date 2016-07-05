%% Script general

xs = -5:0.1:5;
ys = -5:0.1:5;

[xss, yss] = meshgrid(xs,ys);

fxy_2 = xss.^2 + yss.^2 - 10;
fxy_3 = -xss.^2 - yss.^2 - 10;
fxy_4 = 20 + xss.^2 + yss.^2 - 10*(cos(2*pi*xss)+cos(2*pi*yss));

%%

     a = 20;
     b = 0.2;
     c = 2*pi;
     s1 = xss.^2 + yss.^2;
     s2 = cos(c*xss) + cos(c*yss);
     fxy_5 = -a*exp(-b*sqrt((1/2)*s1))-exp((1/2)*s2)+a+exp(1);
%%

xi = 1;
for i=-5:0.1:5
    yi = 1;
    for j=-5:0.1:5
        fxy_5(xi, yi) = dr_f4(i,j);        
        yi = yi + 1;
    end
    xi = xi + 1;
end
figure,
surface(fxy_5);
grid on;

%%
figure, 
surface(xs, ys, fxy_2);
grid on;
axis square;

%figure, 
%surface(fxy_3);
%grid on;

figure,
surface(xs, ys, fxy_4);
grid on;
axis square;

figure,
surface(xs, ys, fxy_5);
grid on;
axis square;

%% Representación de una solución:
% 10 bits [signo][x][x][x][x][signo][y][y][y][y], 
% limita la búsqueda entre -15 y +15, tanto para x, como para y.
individuo = [0,0,0,0,0,0,0,0,0,0];

% translation to integer numbers.
signo_x = individuo(1);
signo_y = individuo(6);
numero_x_binario = individuo(2:5);
numero_y_binario = individuo(7:10);

x_decimal = bi2de(numero_x_binario);
y_decimal = bi2de(numero_y_binario);

if(signo_x == 1)
    x_decimal = -x_decimal;
end

if(signo_y == 1)
    y_decimal = -y_decimal;
end

%% Evaluación de fitness:

fitness = x_decimal^2 + y_decimal^2 - 10;

%% Crossover (one-point crossover)
individuo_1 = [1, 0, 0, 1, 0, 1, 1, 0, 0];
individuo_2 = [0, 1, 1, 1, 1, 0, 1, 0, 0];

n = size(individuo_1,2);
p = randi(n);

hijo_1 = zeros(1, n);
hijo_2 = zeros(1, n);

hijo_1(1:p) = individuo_1(1:p);
hijo_1(p+1:n) = individuo_2(p+1:n);

hijo_2(1:p) = individuo_2(1:p);
hijo_2(p+1:n) = individuo_1(p+1:n);

%% Mutation (assuming hijo_1 is selected)

m = randi(n);
if(hijo_1(m)==1)
    hijo_1(m)=0;
else
    hijo_1(m)=1;
end

%% Combining all

function_handler = @dr_f1;
population_size = 100;
individual_size = 10;
crossover_probability = 0.1;
mutation_probability = 0.01;
max_generations = 150;

[BestSolutionXG, BestFitnessXG, bestSolution, bestFitness, final_G] ...
                                         = dr_ga(function_handler, ...
                                           population_size, ...
                                           individual_size, ...
                                           crossover_probability,...
                                           mutation_probability,...
                                           max_generations);

[x,y] = dr_toIntegers(bestSolution);
x, y


%% Fitness Plot

figure,
plot(BestFitnessXG(:));
