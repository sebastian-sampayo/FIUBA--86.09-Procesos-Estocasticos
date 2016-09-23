% Ejercicio 5

% Test Performance
clear all;

% --------- Parámetros ------------
M = 1e5;
alpha = 1; % Parámetro de variable aleatoria usada para la amplitud
k = 10; % Cantidad de períodos de señal a trasmitir
kf = 1000; % Cantidad de períodos de señal que entran en el largo temporal
          % del sistema. Determina distancia máxima posible de detectar.
sigma = 1; % Parámetro de variable aleatoria usada para la amplitud
v = 300; % [metros por segundo]
d0 = 100; % [metros]
iteraciones = 1000;

file_out = fopen('ej5_Tabla_Performance.csv','w');
fprintf(file_out, '--------------------------------------\r\n');
fprintf(file_out, 'M =               %i\r\n', M);
fprintf(file_out, 'alpha =           %.4g\r\n', alpha);
fprintf(file_out, 'k =               %i\r\n', k);
fprintf(file_out, 'kf =              %i\r\n', kf);
fprintf(file_out, 'sigma =           %.4g\r\n', sigma);
fprintf(file_out, 'v =               %.4g\r\n', v);
fprintf(file_out, 'd0 =              %.4g\r\n', d0);
fprintf(file_out, 'iteraciones =     %i\r\n', iteraciones);
fprintf(file_out, '--------------------------------------\r\n');
fprintf(file_out, '\r\n');
fprintf(file_out, '"Parámetros variables","Filtro sin modificar","Filtro Modificado"\r\n');
fprintf(file_out, '"N0","fc","p","Pe","Efectividad","ECM","Pe","Efectividad","ECM"\r\n');

N0_vector = [1e-10, 1e-5, 1e-2, 1];
fc_vector = [500e6, 100e6, 10e6, 100e3];
p_vector = [.2, .4, .6, .8];

matriz_de_parametros = [N0_vector;fc_vector;p_vector];

for j=1:size(matriz_de_parametros,1)
    for k=1:size(matriz_de_parametros,2)
        %---- Parámetros variables ----
        if j==2
            fc = matriz_de_parametros(j,k);
        else
            fc = 100e6;
        end
        if j==1
            N0 = matriz_de_parametros(j,k);
        else
            N0 = 1e-2;
        end
        if j==3
            p = matriz_de_parametros(j,k);
        else
            p = .5;
        end
        P1 = p;
        P0 = 1-p;
        gama = (1-p)/p;
        % ---------------
        fprintf(file_out, '%.4g,%.4g,%.4g', N0,fc,p);
        
        % ----------  Filtro sin modificar ----------
        T = k/fc;
        s0 = N0/2;
        % s1 = (alpha*sigma)^2 + s0;
        s1 = (T/2)*(alpha*sigma)^2 + s0;
        A = (2*s0*s1*(log(gama)-2*log(sqrt(s0/s1)))/(s1-s0));
        if A>=0
            Pe = 2*((.5-(1-normcdf(sqrt(A),0,sqrt(s1))))*P1 + (1-normcdf(sqrt(A),0,sqrt(s0)))*P0);
        else
            Pe = NaN;
        end
        % --------------------------
       
        aciertos = 0;
        ECM = 0;
        for i=1:iteraciones
            s = generar_onda_transmitida(alpha, fc, 0, k, kf, M);
            X = generar_onda_reflejada(alpha, fc, k, kf, sigma, v, d0, M);
            [R haysenial] = generar_onda_recibida(X, N0, p);
            [D, d0_est] = detectar_y_estimar_posicion_inicial(R, alpha, fc, k, kf, sigma, N0, p);
            aciertos = aciertos + (D==haysenial);
            if D==1
                ECM = ECM + (d0-d0_est)^2;
            end
        end
        ECM = ECM/iteraciones;
        fprintf(file_out, ',%.4g,%.4g,%.4g', Pe,aciertos/iteraciones,ECM);
        
        % Recalculo para filtro modificado
        % ----------  Filtro modificado ----------
        T = k/fc;
        s0 = N0/2;
        s1 = (alpha*sigma)^2 + s0;
%         s1 = (T/2)*(alpha*sigma)^2 + s0;
        A = (2*s0*s1*(log(gama)-2*log(sqrt(s0/s1)))/(s1-s0));
        Pe = 2*((.5-(1-normcdf(sqrt(A),0,sqrt(s1))))*P1 + (1-normcdf(sqrt(A),0,sqrt(s0)))*P0);
        % --------------------------
        
        aciertos = 0;
        ECM = 0;
        for i=1:iteraciones
            s = generar_onda_transmitida(alpha, fc, 0, k, kf, M);
            X = generar_onda_reflejada(alpha, fc, k, kf, sigma, v, d0, M);
            [R haysenial] = generar_onda_recibida(X, N0, p);
            [D, d0_est] = detectar_y_estimar_posicion_inicial_modif(R, alpha, fc, k, kf, sigma, N0, p);
            aciertos = aciertos + (D==haysenial);
            if D==1
                ECM = ECM + (d0-d0_est)^2;
            end
        end
        ECM = ECM/iteraciones;
        fprintf(file_out, ',%.4g,%.4g,%.4g',Pe,aciertos/iteraciones,ECM);
        
        fprintf(file_out, '\r\n');
    end
    fprintf(file_out, '\r\n');
end
fclose(file_out);


