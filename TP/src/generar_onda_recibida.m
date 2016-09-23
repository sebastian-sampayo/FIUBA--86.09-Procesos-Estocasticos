%-------------------------------------------------------------------
% Bloque receptor. Generador de onda recibida
%-------------------------------------------------------------------
% Utilización:
% R = generar_onda_recibida(X, N0, p)
% Devuelve X + ruido con probabilidad p,
% y solo ruido con probabilidad q = 1-p
% 

function [R, varargout] = generar_onda_recibida(X, N0, p)
    if rand<p
        R = X + generar_ruido_blanco_gaussiano(N0, length(X));
        varargout{1} = 1;
    else
        R = generar_ruido_blanco_gaussiano(N0, length(X));
        varargout{1} = 0;
    end
end