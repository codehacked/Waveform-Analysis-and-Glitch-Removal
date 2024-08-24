clc;
clear all;
close all;
% 1. Reading Original Audio Signal
[y, Fs] = audioread('U:\SEMESTER-6\DSP\PROJECT\CODE\Noisy Signal.wav');
y = y(:,1);
info = audioinfo('U:\SEMESTER-6\DSP\PROJECT\CODE\Noisy Signal.wav');
t = 0:(1/Fs):(info.Duration-1/Fs);
figure;
plot(t, y)
title('Audio Signal in Time Domain')
xlabel('t (secs)')
ylabel('y(t)')

% 2. Fourier Transform (DFT) and Single-Sided Spectrum
Y = fft(y);
N = length(y);
P2 = abs(Y/N);
P1 = P2(1:(N/2)+1);
P1(2:end) = 2*P1(2:end);
f = Fs*(0:(N/2))/N;  
[max_amp, idx] = max(P1); 

% Plot the single-sided amplitude spectrum
figure;
plot(f, P1) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('freq (Hz)')
ylabel('Amplitude')

% 3a. Glitch detection
[hours, minutes, seconds, glitchtime] = glitchdetection(Fs, y, t);
figure;
A= (hours * 3600) + (minutes * 60) + seconds;
yg = y((A-50):(A+50), 1);
tg=t(1:length(yg));
plot(tg, yg);
title('Glitched Signal');
xlabel('Time (s)');
ylabel('Amplitude');


% 3b. Noise detection
yn = y(1:1800, 1);
tn = t(1:length(yn));
figure;
plot(tn, yn)
title('Noise detection')
xlabel('t (secs)')
ylabel('y(t)')

% 4. Masking
mask = zeros(size(Y));
mask(idx) = 1;
ynew = Y .* mask;
% Plot the mask
figure;
plot(mask)
title('Mask for Frequency Components')
xlabel('freq (Hz)')
ylabel('Mask')

% 5. Plot the filtered signal in the frequency domain
P2_new = abs(ynew/N);
P1_new = P2_new(1:(N/2)+1);
P1_new(2:end) = 2*P1_new(2:end);

figure;
plot(f, P1_new)
title('Filtered Single-Sided Amplitude Spectrum')
xlabel('freq (Hz)')
ylabel('Amplitude')

% 6. IFFT
ynewtime = ifft(ynew, 'symmetric');
figure;
plot(t, ynewtime)
title('Filtered Signal in Time Domain')
xlabel('Time (s)')
ylabel('Amplitude')
% 7a. Glitch detection after filtering
figure;
A= (hours * 3600) + (minutes * 60) + seconds;
yg1 = ynewtime((A-50):(A+50), 1);
tg1=t(1:length(yg));
plot(tg1, yg1);
title('Glitched Removed Signal');
xlabel('Time (s)');
ylabel('Amplitude');
% 7b. Noise detection after filtering
ynew2 = ynewtime(1:1800, 1);
tnew2 = t(1:length(ynew2));
figure;
plot(tnew2, ynew2)
title('Noise detection after filtering')
xlabel('t (secs)')
ylabel('y(t)')

% 8. Audio write
audiowrite('U:\SEMESTER-6\DSP\PROJECT\CODE\Filtered Signal.wav', ynewtime, Fs);
