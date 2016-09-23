%-------------------------------------------------------------------
% Bloque transmisor.
%-------------------------------------------------------------------
%
% s = generar_onda_transmitida(alpha, fc, theta, k, kf, M)
% size(s) = [1 M]
%
%        | alpha*cos(2pi*fc*t + theta), para 0 <= t <= T 
% s(t) = | 
%        | 0                 , para T <= t <= Tf
%        
% k = T/Tc = T*fc  => T = k/fc
% kf = Tf/Tc = Tf*fc  => Tf = kf/fc
% 
% Ts: período de muestreo
% M: cantidad de muestras
% Tf = M*Ts => Ts = Tf/M
% => t = n*Ts = n*Tf/M
%
% nT: Cantidad de muestras entre 0 y T.
% T = nT*Ts => nT = T/Ts
%
%

function s = generar_onda_transmitida(alpha, fc, theta, k, kf, M)
    T = k/fc;
    Tf = kf/fc;
    Ts = Tf/M;
    nT = ceil(T/Ts);
    s = zeros(1, M);
    n = 0:nT;
    s(1:length(n)) = alpha*cos(2*pi*fc*n*Ts + theta);
end