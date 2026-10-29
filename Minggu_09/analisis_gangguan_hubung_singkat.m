%% DSTL 2026 - MINGGU 09: ANALISIS GANGGUAN HUBUNG SINGKAT 012
%% Program Studi S1 Teknik Elektro - Universitas Bengkulu
%% Dosen: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.

clear; clc;

fprintf('=== KALKULASI GANGGUAN HUBUNG SINGKAT SIMETRIS & ASIMETRIS ===\n');
S_base = 100e6;    % 100 MVA
V_base = 150e3;    % 150 kV
I_base = S_base / (sqrt(3) * V_base);

% Impedansi Urutan Jaringan
Z1 = 1j * 0.20;
Z2 = 1j * 0.20;
Z0 = 1j * 0.10;
Vf = 1.0;          % Tegangan pra-gangguan 1.0 pu

% 1. Gangguan 3-Fasa Simetris (LLL)
If_3ph_pu = Vf / abs(Z1);
If_3ph_A  = If_3ph_pu * I_base;

% 2. Gangguan Fasa-ke-Tanah (SLG)
Ia0 = Vf / (Z1 + Z2 + Z0);
If_slg_pu = abs(3 * Ia0);
If_slg_A  = If_slg_pu * I_base;

% 3. Gangguan Fasa-ke-Fasa (LL)
If_ll_pu  = sqrt(3) * Vf / abs(Z1 + Z2);
If_ll_A   = If_ll_pu * I_base;

fprintf('Arus Dasar Sistem (I_base) : %.2f A\n', I_base);
fprintf('Arus Gangguan 3-Fasa (LLL) : %.2f pu  (%.2f A / %.2f kA)\n', If_3ph_pu, If_3ph_A, If_3ph_A/1e3);
fprintf('Arus Gangguan SLG (Fasa-T) : %.2f pu  (%.2f A / %.2f kA)\n', If_slg_pu, If_slg_A, If_slg_A/1e3);
fprintf('Arus Gangguan LL (Fasa-Fasa): %.2f pu  (%.2f A / %.2f kA)\n', If_ll_pu, If_ll_A, If_ll_A/1e3);
