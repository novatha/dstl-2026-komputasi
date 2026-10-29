%% DSTL 2026 - MINGGU 07: JATUH TEGANGAN FEEDER DISTRIBUSI 20 kV
%% Program Studi S1 Teknik Elektro - Universitas Bengkulu
%% Dosen: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.

clear; clc; close all;

fprintf('=== SIMULASI DROP TEGANGAN FEEDER RADIAL 20 kV DENGAN PLTS ===\n');
V_base = 20000 / sqrt(3); % Tegangan Fasa-Netral

% 4 Segmen Saluran (Bus 1 ke Bus 5)
R = [0.5, 0.4, 0.6, 0.3]; % Ohm
X = [0.6, 0.5, 0.7, 0.4]; % Ohm

% Beban di Bus 2, 3, 4, 5
P_load = [200e3, 150e3, 300e3, 100e3]; % Watt
Q_load = [100e3, 80e3,  150e3, 50e3];  % VAR

% Kasus 1: Tanpa PLTS
V1 = zeros(1, 5); V1(1) = V_base;
for i = 1:4
    I_P = sum(P_load(i:end)) / (sqrt(3)*20e3);
    I_Q = sum(Q_load(i:end)) / (sqrt(3)*20e3);
    dV = I_P*R(i) + I_Q*X(i);
    V1(i+1) = V1(i) - dV;
end

% Kasus 2: Dengan Injeksi PLTS 400 kW di Bus 4
P_load_plts = P_load;
P_load_plts(3) = P_load_plts(3) - 400e3; % Net daya di Bus 4 negatif (injeksi)

V2 = zeros(1, 5); V2(1) = V_base;
for i = 1:4
    I_P = sum(P_load_plts(i:end)) / (sqrt(3)*20e3);
    I_Q = sum(Q_load(i:end)) / (sqrt(3)*20e3);
    dV = I_P*R(i) + I_Q*X(i);
    V2(i+1) = V2(i) - dV;
end

figure('Name', 'Profil Tegangan Feeder 20 kV', 'NumberTitle', 'off');
plot(1:5, V1*sqrt(3)/1e3, 'r-o', 'LineWidth', 2); hold on;
plot(1:5, V2*sqrt(3)/1e3, 'g-s', 'LineWidth', 2); grid on;
xlabel('Nomor Bus'); ylabel('Tegangan Saluran (kV)');
legend({'Tanpa PLTS (Drop Murni)', 'Dengan PLTS 400 kW di Bus 4'}, 'Location', 'southwest');
title('Perbaikan Profil Tegangan Distribusi dengan Distributed Generation');
