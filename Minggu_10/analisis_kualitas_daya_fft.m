%% DSTL 2026 - MINGGU 10: KUALITAS DAYA & ANALISIS SPEKTRUM FFT
%% Program Studi S1 Teknik Elektro - Universitas Bengkulu
%% Dosen: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.

clear; clc; close all;

fprintf('=== ANALISIS TOTAL HARMONIC DISTORTION (THD) ARUS ===\n');
f0 = 50;                     % Frekuensi fundamental 50 Hz
Fs = 5000;                   % Frekuensi sampling 5 kHz
t = 0:(1/Fs):(0.06 - 1/Fs);  % 3 Siklus gelombang (60 ms)

% Gelombang arus terdistorsi (Non-linear Inverter Load)
i_fundamental = 100 * sin(2*pi*f0*t);
i_h3 = 20 * sin(2*pi*3*f0*t);
i_h5 = 15 * sin(2*pi*5*f0*t);
i_h7 = 10 * sin(2*pi*7*f0*t);

i_total = i_fundamental + i_h3 + i_h5 + i_h7;

% Analisis FFT
N = length(i_total);
I_fft = abs(fft(i_total)) / (N/2);
f_axis = (0:(N/2)-1) * (Fs/N);
I_spectrum = I_fft(1:N/2);

% Ekstraksi Komponen Utama
I1 = 100;
I_harm = sqrt(20^2 + 15^2 + 10^2);
THD_i = (I_harm / I1) * 100;

fprintf('Arus Fundamental (50 Hz) : %.2f A (Peak)\n', I1);
fprintf('Arus Harmonisa Total     : %.2f A\n', I_harm);
fprintf('Total Harmonic Distortion: %.2f%% (Batas IEEE 519: <= 5%%)\n', THD_i);

figure('Name', 'Analisis Harmonisa', 'NumberTitle', 'off');
subplot(2,1,1);
plot(t*1000, i_total, 'r-', 'LineWidth', 1.8); grid on;
xlabel('Waktu (ms)'); ylabel('Arus (A)'); title('Bentuk Gelombang Arus Terdistorsi');

subplot(2,1,2);
stem(f_axis(1:30), I_spectrum(1:30), 'b', 'LineWidth', 2); grid on;
xlabel('Frekuensi (Hz)'); ylabel('Magnitudo Arus (A)'); title('Spektrum Harmonisa (FFT)');
