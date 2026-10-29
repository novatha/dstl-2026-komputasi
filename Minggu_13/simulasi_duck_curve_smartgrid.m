%% DSTL 2026 - MINGGU 13: SMART GRID, PENETRASI PLTS & DUCK CURVE
%% Program Studi S1 Teknik Elektro - Universitas Bengkulu
%% Dosen: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.

clear; clc; close all;

fprintf('=== SIMULASI DUCK CURVE DAN PEAK SHAVING BESS ===\n');
jam = 0:23;
beban_kotor_MW = [22, 19, 17, 16, 17, 21, 32, 42, 47, 50, 52, 54, ...
                  55, 54, 52, 50, 48, 52, 58, 56, 50, 42, 32, 26];

% Profil Radiasi PLTS (Puncak di jam 12:00)
plts_gen_MW = [0, 0, 0, 0, 0, 1, 6, 16, 26, 33, 37, 38, ...
               37, 34, 27, 16, 6, 1, 0, 0, 0, 0, 0, 0];

beban_bersih_MW = beban_kotor_MW - plts_gen_MW;

figure('Name', 'Duck Curve & Penetrasi EBT', 'NumberTitle', 'off');
plot(jam, beban_kotor_MW, 'k--', 'LineWidth', 2); hold on;
plot(jam, plts_gen_MW, 'y-o', 'LineWidth', 2);
plot(jam, beban_bersih_MW, 'b-', 'LineWidth', 2.5); grid on;
xlabel('Waktu (Jam)'); ylabel('Daya (MW)');
legend({'Beban Bruto (Gross Load)', 'Injeksi PLTS Solar PV', 'Beban Bersih (Duck Curve)'}, 'Location', 'northwest');
title('Fenomena Duck Curve Akibat Integrasi EBT Skala Besar');
