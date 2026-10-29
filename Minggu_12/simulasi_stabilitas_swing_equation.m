%% DSTL 2026 - MINGGU 12: PERSAMAAN AYUNAN & STABILITAS TRANSIEN
%% Program Studi S1 Teknik Elektro - Universitas Bengkulu
%% Dosen: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.

clear; clc; close all;

fprintf('=== SIMULASI DINAMIKA SUDUT ROTOR PERSAMAAN AYUNAN ===\n');
H = 5.0;            % Inersia 5 detik
f0 = 50;            % Frekuensi 50 Hz
Pm = 0.8;           % Daya mekanis 0.8 pu
Pmax = 1.25;        % Transfer daya maksimum 1.25 pu
t_clear = 0.18;     % Waktu pemutusan gangguan (s)
t_end = 1.5;        % Durasi simulasi 1.5 s
dt = 0.002;

t = 0:dt:t_end;
delta = zeros(size(t));
omega = zeros(size(t));

delta(1) = asin(Pm / Pmax); % Sudut stabil awal

for i = 1:length(t)-1
    if t(i) < t_clear
        Pe = 0; % Gangguan hubung singkat di bus generator
    else
        Pe = Pmax * sin(delta(i));
    end
    
    Pa = Pm - Pe;
    omega(i+1) = omega(i) + (pi * f0 / H * Pa) * dt;
    delta(i+1) = delta(i) + omega(i+1) * dt;
end

figure('Name', 'Dinamika Sudut Rotor', 'NumberTitle', 'off');
plot(t, delta * 180 / pi, 'r-', 'LineWidth', 2); grid on;
xlabel('Waktu (detik)'); ylabel('Sudut Rotor \delta (derajat)');
title(sprintf('Respons Transien Generator Sinkron (t_{clear} = %.2f s)', t_clear));
