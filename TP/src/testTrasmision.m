% Test
clear all;
% --------- Par�metros ------------
M = 1e5;
alpha = 1; % Par�metro de variable aleatoria usada para la amplitud
fc = 100e6; % [Hertz]
k = 100; % Cantidad de per�odos de se�al a trasmitir
kf = 10*k; % Cantidad de per�odos de se�al que entran en el largo temporal
          % del sistema. Determina distancia m�xima posible de detectar.
sigma = 1; % Par�metro de variable aleatoria usada para la amplitud
v = 300; % [metros por segundo]
d0 = 100; % [metros]
N0 = 1e-2; % Potencia de ruido = N0/2
p = .5; % Probabilidad de que haya se�al
% ---------------------------------
T = k/fc;
% s0 = N0/2;
% s1 = (alpha*sigma)^2 + s0;
% s1 = (T/2)*(alpha*sigma)^2 + s0;
% -----------------------------------

% iteraciones = 100;
% aciertos = 0;
disp(sprintf('N0 = %f', N0))
% for i=1:iteraciones

    s = generar_onda_transmitida(alpha, fc, 0, k, kf, M);
    X = generar_onda_reflejada(alpha, fc, k, kf, sigma, v, d0, M);
    [R haysenial] = generar_onda_recibida(X, N0, p);
%     [D, d0_est, umbral, r2] = detectar_y_estimar_posicion_inicial_modif(R, alpha, fc, k, kf, sigma, N0, p);
%     [D, d0_est, v_est] = detectar_y_estimar_pos_y_vel(R, alpha, fc, k, kf, sigma, N0, p);
    [D, d0_est, umbral, r2, umbral2] = detectar_y_estimar_posicion_inicial_exp(R, alpha, fc, k, kf, sigma, N0, p);
    disp(sprintf('|r1|^2: %.2e', r2))
    disp(sprintf('Umbral1: %.2e', umbral))
    disp(sprintf('Umbral2: %.2e', umbral2))
    disp(sprintf('Distancia real: %f', d0))
%     disp(sprintf('Velocidad real: %f', v))
    disp(sprintf('Se�al env�ada: %i (1 si se env�o se�al)', haysenial))
    disp(sprintf('Detecci�n de se�al: %i (1 si detect� se�al)', D))
    disp(sprintf('Distancia estimada: %f', d0_est))
%     disp(sprintf('Velocidad estimada: %f', v_est))
    disp(sprintf('Detecci�n correcta: %i (1 si fue correcto)', D==haysenial))
%     aciertos = aciertos + (D==haysenial);
% end
% disp(sprintf('Efectividad (aciertos/iteraciones): %f', aciertos/iteraciones))
subplot(311)
plot(s)
grid on
title('Onda trasmitida')

subplot(312)
plot(X)
grid on
title('Onda reflejada')

subplot(313)
plot(R)
grid on
title('Onda recibida (reflejada + ruido)')