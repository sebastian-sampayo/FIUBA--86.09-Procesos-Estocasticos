% # Función para calcular transformada de fourier por definición.
% # -- F = fourierTransform(data, t1, t2, w1, w2, puntos)
% # 	data es la señal de entrada
% # 	t1 y t2 son los tiempos inicial y final respectivamente a los que corresponde la señal
% # 	w1 y w2 son los límites inferior y superior del espectro que se quiere conocer
% #	puntos es las cantidad de puntos del espectro a calcular entre w1 y w2.
% # -Implementación: o bien se pueden pedir los tiempos inicial y final o pedir directamente el vector tiempo asociado a la señal data. Lo mismo sucede con w.
% #  En caso de pedir los vectores Tiempo(t) y Velocidad A.(w), estos deben ser vectores fila.

function F = fourierTransform(data, t, w)
% #	t = linspace(t1, t2, length(data));
	dt = t(2) - t(1);
% #	w = linspace(w1, w2, puntos);
	
	F = data * exp(-j * t' * w) * dt;
end
