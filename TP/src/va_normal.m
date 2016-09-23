% Función para generar variable Normal de media 'media' y desvio 'desvio'
% u1 y u2 deben ser uniformes(0, 1) independientes
% Utilización:
% x = va_normal(u1, u2, media, desvio)

function x = va_normal(u1, u2, media, desvio)
    R = va_rayleigh(u1, desvio);
    fi = va_uniforme(u2, 0, 2*pi);

    x = R.*cos(fi) + media;
end