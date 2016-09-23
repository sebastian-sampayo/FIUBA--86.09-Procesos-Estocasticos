% Función para graficar histogramas normalizados

function hbar = hist_norm(data)
    [fabs xcentr] = hist(data,100);
    p = fabs/length(data);
    L = xcentr(2) - xcentr(1);
    hbar = bar(xcentr, p/L, 1, 'b');
end