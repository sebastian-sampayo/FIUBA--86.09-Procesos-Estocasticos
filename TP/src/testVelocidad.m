 c = 3e8;
    M = length(R);
    T = k/fc;
    Tf = kf/fc;
    Ts = Tf/M;
    nT = ceil(T/Ts);
    t = linspace(0, Tf, M);
    % Filtros Adaptados
    h1 = (2/T) * cos(2*pi*fc*t); % Modifiqué la constante
    h2 = (2/T) * sin(2*pi*fc*t); % del filtro. Era sqrt(2/T)
    % Potencia de ruido y señal+ruido
    s0 = N0/2;
%     s1 = (T/2)*(alpha*sigma)^2 + s0;
    s1 = (alpha*sigma)^2 + s0;

    gama = (1-p)/p;
    
    uT = [ones(1, nT) zeros(1, M-nT)]; % Escalón de largo T.
    Rcos = R .* h1 * Ts;
    Rsin = R .* h2 * Ts;
    r1 = conv(uT, Rcos);
    r1 = r1(nT:end-nT);
    r2 = conv(uT, Rsin);
    r2 = r2(nT:end-nT);
    
    r_abs = r1.^2 + r2.^2;
    u = find(r_abs==max(r_abs)); % muestra.
    tau = u*Ts; % tiempo
    
    % Estimación de Velocidad
    R = R(u:u+nT);
    t = t(1:nT+1);
    maxlag = ceil(nT/2);
    [corrR lag] = xcorr(R.*cos(2*pi*fc*t), maxlag, 'unbiased');
%     t2 = lag*Ts;
%     w = linspace(-2*pi*30000, 2*pi*30000,1000);
%     Sw_R = fourierTransform(corrR, t2, w);
%     plot(w/2/pi, abs(Sw_R));
%     u1 = @(t,W) ((t>(-W)) & (t<W));
%     W = 1e5;
%     corrR = conv(W/pi*sinc(W*t/pi), R.*cos(2*pi*fc*t));
%     D = 1e3;
%     corrR = decimate(corrR, D);
%     Ts = Ts*D;
%     N = length(corrR);
%     corrR = corrR(ceil(N/2)-100:ceil(N/2)+100);
%     plot(lag, corrR)
    NFFT = 2^20;
%     D = 1e2;
%     n = 1:100;
%     corrR = corrR(n*D);
%     Ts = Ts*D;
    N = length(corrR);
%     offset = ceil(N/200);
%     offset = 0;
%     window = [zeros(1,offset) ones(1, N-2*offset) zeros(1,offset)];
    window = hamming(N)';
%     window = ones(1,N);
    Sw_R = fft(corrR .* window, NFFT);
    % Tomo solo la parte que contiene información
    offset = ceil(3*fc*Ts*NFFT);
    Sw_R = Sw_R(1:offset);
    freq = linspace(0, 3*fc, offset);
    plot(freq, (abs(Sw_R)))