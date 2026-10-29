%% DSTL 2026 - MINGGU 06: KURVA DURASI BEBAN & ANALISIS PEMBANGKITAN
%% Program Studi S1 Teknik Elektro - Universitas Bengkulu
%% Dosen: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.

clear; clc; close all;

fprintf('=== ANALISIS KURVA DURASI BEBAN (LDC) SISTEM BENGKULU ===\n');
% Data Beban 24 Jam
jam = 1:24;
beban_MW = [110, 105, 100, 95, 98, 115, 140, 160, 175, 180, 185, 180, ...
            175, 170, 165, 160, 170, 195, 230, 245, 240, 210, 160, 130];

% Sorting beban untuk LDC
ldc_beban = sort(beban_MW, 'descend');
durasi_persen = (1:24) / 24 * 100;

% Energi Harian dan Capacity Factor
energi_harian_MWh = sum(beban_MW);
P_peak = max(beban_MW);
P_base = min(beban_MW);
P_terpasang = 2 * 100; % PLTU Teluk Sepang 200 MW

LF = (energi_harian_MWh / (P_peak * 24)) * 100;
CF = (energi_harian_MWh / (P_terpasang * 24)) * 100;

fprintf('Beban Puncak (Peak) : %.2f MW\n', P_peak);
fprintf('Beban Dasar (Base)  : %.2f MW\n', P_base);
fprintf('Load Factor (LF)    : %.2f%%\n', LF);
fprintf('Capacity Factor (CF): %.2f%%\n', CF);

figure('Name', 'Kurva LDC', 'NumberTitle', 'off');
subplot(2,1,1);
plot(jam, beban_MW, 'r-s', 'LineWidth', 1.8); grid on;
xlabel('Waktu (Jam)'); ylabel('Beban (MW)'); title('Profil Beban Harian Sistem Bengkulu');

subplot(2,1,2);
plot(durasi_persen, ldc_beban, 'b-d', 'LineWidth', 1.8); grid on;
xlabel('Persentase Waktu (%)'); ylabel('Beban (MW)'); title('Load Duration Curve (LDC)');
