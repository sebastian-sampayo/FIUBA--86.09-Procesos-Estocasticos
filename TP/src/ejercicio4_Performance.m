% Test Performance
clear all;

% --------- Parámetros ------------
M = 1e5;
alpha = 1; % Parámetro de variable aleatoria usada para la amplitud
fc = 100e6; % [Hertz]
k = 10; % Cantidad de períodos de señal a trasmitir
kf = 100; % Cantidad de períodos de señal que entran en el largo temporal
          % del sistema. Determina distancia máxima posible de detectar.
sigma = 1; % Parámetro de variable aleatoria usada para la amplitud
v = 0; % [metros por segundo]
d0 = 100; % [metros]
N0 = 1e-7; % Potencia de ruido = N0/2
p = .5; % Probabilidad de que haya señal
% ---------------------------------
T = k/fc;
% s0 = N0/T;
% s0 = N0/2;
% s1 = (alpha*sigma)^2 + s0;
% % s1 = (T/2)*(alpha*sigma)^2 + s0;
% SNR = (s1-s0)/s0;
% -----------------------------------

% file_out = fopen('Performance.txt','a');
% fprintf(file_out, '\r\n--------------------------------------\r\n');
% fprintf(file_out, 'M =      %i\r\n', M);
% fprintf(file_out, 'alpha =  %.4g\r\n', alpha);
% fprintf(file_out, 'fc =     %.4g\r\n', fc);
% fprintf(file_out, 'k =      %i\r\n', k);
% fprintf(file_out, 'kf =     %i\r\n', kf);
% fprintf(file_out, 'sigma =  %.4g\r\n', sigma);
% fprintf(file_out, 'v =      %.4g\r\n', v);
% fprintf(file_out, 'd0 =     %.4g\r\n', d0);
% fprintf(file_out, 'N0 =     %.4g\r\n', N0);
% fprintf(file_out, 'p =      %.4g\r\n', p);
% fprintf(file_out, 'T =      %.4g\r\n', T);
% fprintf(file_out, '\r\n');
a = [1e-7 1e-2 .5 1];
for j=1:4
    N0 = a(j);
    iteraciones = 100;
    aciertos = 0;
    ECM = 0;
    p_est = 0;
    r1_est = 0;
    r0_est = 0;

    for i=1:iteraciones
        s = generar_onda_transmitida(alpha, fc, 0, k, kf, M);
        X = generar_onda_reflejada(alpha, fc, k, kf, sigma, v, d0, M);
        [R haysenial] = generar_onda_recibida(X, N0, p);
        [D, d0_est, umbral, r2] = detectar_y_estimar_posicion_inicial_modif(R, alpha, fc, k, kf, sigma, N0, p);
    %     disp(sprintf('Distancia real: %f', d0))
    %     disp(sprintf('Señal envíada: %i (1 si se envío señal)', haysenial))
    %     disp(sprintf('Detección de señal: %i (1 si detectó señal)', D))
    %     disp(sprintf('Distancia estimada: %f', d0_est))
    %     disp(sprintf('Detección correcta: %i (1 si fue correcto)', D==haysenial))
        aciertos = aciertos + (D==haysenial);
        if D==1
            ECM = ECM + (d0-d0_est)^2;
        end
        if haysenial==1
            r1_est = r1_est + r2;
        else
            r0_est = r0_est + r2;
        end
        % Cuento cantidad de veces que hubo señal
        p_est = p_est + haysenial;
    end
    r1_est = r1_est/p_est;
    r0_est = r0_est/(iteraciones-p_est);
    p_est = p_est/iteraciones;
    % figure(1)
    % hist_norm(r2);
    ECM = ECM/iteraciones;
    disp(sprintf('N0 = %.2e', N0))
    disp(sprintf('|r1|^2_promedio: %.2e', r1_est))
    disp(sprintf('Umbral: %.2e', umbral))
    disp(sprintf('|r0|^2_promedio: %.2e', r0_est))
    % disp(sprintf('p_est: %f', p_est))
    disp(sprintf('Efectividad (aciertos/iteraciones): %f', aciertos/iteraciones))
    % disp(sprintf('Error Cuadrático Medio: %e', ECM))
    % 
    % fprintf(file_out,'iteraciones: %i\r\n', iteraciones);
    % fprintf(file_out,'Efectividad (100*aciertos/iteraciones): %.4f%%\r\n', 100*aciertos/iteraciones);
    % fprintf(file_out,'Error Cuadrático Medio: %f\r\n', ECM);
    % fclose(file_out);
end

% subplot(311)
% plot(s)
% grid on
% title('Onda trasmitida')
% 
% subplot(312)
% plot(X)
% grid on
% title('Onda reflejada')
% 
% subplot(313)
% plot(R)
% grid on
% title('Onda recibida (reflejada + ruido)')