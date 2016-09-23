%-------------------------------------------------------------------
% Generador de ruido blanco gaussiano
%-------------------------------------------------------------------
%
% N = generar_ruido_blanco_gaussiano(N0, M)
% Varianza: N0/2
% M cantidad de muestras

function N = generar_ruido_blanco_gaussiano(N0, M)
    N = va_normal(rand(1,M), rand(1,M), 0, sqrt(N0/2));
end