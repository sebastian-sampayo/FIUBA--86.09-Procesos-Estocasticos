% Funcion para generar variable uniforme entre a y b
% u debe ser uniforme(0, 1)
% Utilización:
% x = va_uniforme(u, a, b)

function x = va_uniforme(u, a, b)
    x = (b - a)*u + a;
end