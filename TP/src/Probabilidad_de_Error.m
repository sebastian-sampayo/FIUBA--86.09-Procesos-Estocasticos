% Probabilidad de Error / Análisis de Umbral.

% En estos gráficos se puede ver donde se encuentra realmente el umbral de
% desición. Dado que ambas variables aleatorias (R|H_0 y R|H_1) tienen distribución
% Gaussiana y media nula, el umbral -es decir, la intersección entre las
% curvas- quedará determinado por el desvío de cada una. Cuanto menor sea
% esta diferencia, más se alejará del 0 el umbral.
% Aquí se puede ver también que, si la potencia de ruido es muy grande,
% ambos desvíos serán iguales, dado que debido al factor (T/2) que
% multiplica la potencia de señal, esta se hace muy pequeña en relación a
% N0/2.
%  sigma0 = ...
%  sigma1 = ....
% Así, el umbral de desición se hace extremadamente alto.
% En consecuencia, la probabilidad de error dado H1 crece (área bajo la
% curva de fdp_1 en la región R_0).
% Figura filtro sin modif, N0=1e-5. Decir: Para valores mayores de N0 se
% obtiene el mismo gráfico.

% Nuevamente se comprueba con esto, que anulando el factor T/2 se
% obtendrán desvíos diferentes con potencias de ruido mayores, permitiendo
% así que exista un umbral de desición razonable.
%
% En conclusión, la siguiente señal, con ruido de N0=1e-5, no es efectivamente
% detectada por el programa utilizando el filtro sin modificar. Como así
% tampoco señales con ruidos mayores.
% Fig. señal + ruido 1e-5
% En cambio, una señal, con ruido N0=1, es efectivamente detectada por el
% filtro modificado.
% Fig. señal + ruido 1


clear all;
disp('Nuevo Test');

fdp_N = @(n,mu,sigma) (1./(2*pi*sigma.^2) .* exp(-1/2 * ((n-mu)./sigma).^2));

% --------- Parámetros ------------
M = 1e5;
alpha = 1; % Parámetro de variable aleatoria usada para la amplitud
fc = 100e6; % [Hertz]
k = 100; % Cantidad de períodos de señal a trasmitir
kf = 100; % Cantidad de períodos de señal que entran en el largo temporal
          % del sistema. Determina distancia máxima posible de detectar.
sigma = 1; % Parámetro de variable aleatoria usada para la amplitud
v = 0; % [metros por segundo]
d0 = 100; % [metros]
N0 = 1e-10; % Potencia de ruido = N0/2
p = .5; % Probabilidad de que haya señal
P1 = p;
P0 = 1-p;
gama = (1-p)/p;
% ---------------------------------
T = k/fc;
s0 = N0/2
% s0 = N0/T
s1 = (alpha*sigma)^2 + s0
% s1 = (T/2)*(alpha*sigma)^2 + s0
% s0 = N0*T/4
% s1 = (T/2)^2 +s0


A = (2*s0*s1*(log(gama)-2*log(sqrt(s0/s1)))/(s1-s0))
sqrt(A);


Pe = 2*((.5-(1-normcdf(sqrt(A),0,sqrt(s1))))*P1 + (1-normcdf(sqrt(A),0,sqrt(s0)))*P0)

r_max = 4;
r = linspace(-r_max, r_max, 1000);
fdp_0 = fdp_N(r, 0, sqrt(s0));
fdp_1 = fdp_N(r, 0, sqrt(s1));

figure(1)
clf
hold all;
plot(r,fdp_0*P0,'linewidth',2)
plot(r,fdp_1*P1)
grid on;
hold off;
legend('P_0\cdotfdp_{R|H_0}', 'P_1\cdotfdp_{R|H_1}');
xlabel('||r||');
title('Filtro modificado. N_0 = 1. P_0=0.5');

% print('-dpng','fdp_N0_1_Filtro_modif.png');