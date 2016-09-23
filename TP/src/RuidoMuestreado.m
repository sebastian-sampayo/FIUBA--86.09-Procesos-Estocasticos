% Ruido muestreado

maxK = 1000;
NFFT = 2*maxK;
B = 100;
w0 = 300;
% WS = 800;
% FS = WS/(2*pi);
% TS = 1/FS;
TS = 2*pi/B;
FS = 1/TS;
WS = 2*pi*FS;
N0 = 1;

k = -maxK+1:maxK;
w = linspace(0, WS, NFFT);

R = N0*B*TS/(2*pi)*sinc(k*B*TS/(2*pi)).*cos(w0*k*TS);

% figure(1)
% plot(k, R)

figure(2)
clf
subplot(3,1,1)
S = abs(fft(R.*hamming(length(R))',NFFT));
plot(w-WS/2, fftshift(S))
grid on;
title('S_W(w)');
xlabel('w');

% subplot(3,1,2)
k = -5:5;
t = linspace(-6*TS, 6*TS, 1000);
Rm = N0*B*TS/(2*pi)*sinc(k*B*TS/(2*pi)).*cos(w0*k*TS);
R = N0*B/(2*pi)*sinc(B*t/(2*pi)).*cos(w0*t);
% % hold on;
% plot(t, R);
% % stem(k*TS, Rm,'r');
% grid on;
% title('R_W(tau)');
% xlabel('tau');

subplot(3,1,2)
hold on;
plot(t, R);
stem(k*TS, Rm,'r');
grid on;
title('R_{Wd}');
xlabel('tau');
hold off;

subplot(3,1,3)

% print('-dpng', 'ejercicio2.2.png');
