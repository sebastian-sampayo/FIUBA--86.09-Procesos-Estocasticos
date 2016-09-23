%-------------------------------------------------------------------
% Bloque reflector.
%-------------------------------------------------------------------
%
% X = generar_onda_reflejada(alpha, fc, k, kf, sigma, v, d0, M)
% size(X) = [1 M]
%
%        | A*cos(2pi*(fc+fd)*t + theta), para tau0 <= t <= tau0 + T 
% X(t) = | 
%        | 0                 , para 0 <= t < tau0, tau0 + T <= t <= Tf
%        
% k = T/Tc = T*fc  => T = k/fc
% kf = Tf/Tc = Tf*fc  => Tf = kf/fc
% 
% Ts: período de muestreo
% M: cantidad de muestras
% Tf = M*Ts => Ts = Tf/M
% => t = n*Ts = n*Tf/M
%
% nt: Cantidad de muestras entre 0 y T.
% T = nT*Ts => nT = T/Ts
%
% ntau: Cantidad de muestras entre 0 y tau.
% tau = ntau*Ts => ntau = tau/Ts

function X = generar_onda_reflejada(alpha, fc, k, kf, sigma, v, d0, M)
	c = 3e8;
    A = va_rayleigh(rand, alpha*sigma);
    theta = va_uniforme(rand, 0, 2*pi);
    fd = 2*v*fc/c;
    tau0 = 2*d0/c;
    T = k/fc;
    Tf = kf/fc;
    Ts = Tf/M;
    dmax = c*(Tf-T)/2;
    X = zeros(1, M);
    if d0<dmax
        nT = ceil(T/Ts);
        n = 0:nT;
        ntau = ceil(tau0/Ts);
        if ntau == 0
            ntau = 1;
        end;
        X(ntau:(ntau+nT)) = A*cos(2*pi*(fc+fd)*n*Ts + theta);
    end
end