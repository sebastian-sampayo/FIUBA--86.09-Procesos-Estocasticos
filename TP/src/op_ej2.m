% Ejercicio Opcional 2.

N0 = 1;
fc = 100e6;
M = 1e4;
Fs = 100e7;
Tf = M/Fs;
Ts = 1/Fs;
% k = 10;
% Tf = k/fc;
% Ts = Tf/M;
% Fs = M/Tf;
NFFT = 2^20;
t = linspace(0, Tf, M);
freq = linspace(0, 1/Ts, NFFT);

N = generar_ruido_blanco_gaussiano(N0, M);
V = N.*cos(2*pi*fc*t);

% acorrN = xcorr(N,'unbiased');
% acorrV = xcorr(V,'unbiased');
% acorrN = acorrN(M-floor(M/2):M+floor(M/2));
% acorrV = acorrV(M-floor(M/2):M+floor(M/2));
% len = length(acorrN);
len = M;
% len = NFFT;
% window = [ones(1,ceil(len/2)) zeros(1,len-ceil(len/2))];
window = ones(1,len);
% window = hamming(len)';
N_fft = fft(N.*window, NFFT);
V_fft = fft(V.*window, NFFT);

figure(1)
clf;
hold all;
plot(freq, abs(N_fft));
plot(freq, abs(V_fft));

legend('F\{N\}(\omega)','F\{V\}(\omega)');
xlabel('Frecuencia [Hz]')

% print('-dpng','../Graficos/op_ej2.png');
% figure(1)
% spectrogram(N, window, floor(len*.75), NFFT, Fs,'yaxis');
% figure(2)
% spectrogram(V, window, floor(len*.75), NFFT, Fs,'yaxis');