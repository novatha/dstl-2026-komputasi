%% DSTL 2026 - MINGGU 06: KARAKTERISTIK DAYA-SUDUT SALIENT VS SILINDER
% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

% Parameter Saluran Mesin (Per-Unit)
Vt = 1.0;
Ea = 1.25;
Xd = 1.05;
Xq = 0.65;
Xs = Xd; % generator silinder pembanding

% Sudut Rotor delta dari 0 hingga 180 derajat
delta_deg = 0:1:180;
delta_rad = deg2rad(delta_deg);

% 1. Generator Kutub Silinder
P_cylindrical = (Ea * Vt / Xs) * sin(delta_rad);

% 2. Generator Kutub Sepatu (Salient-Pole)
P_excitation = (Ea * Vt / Xd) * sin(delta_rad);
P_reluctance = (Vt^2 / 2) * (1/Xq - 1/Xd) * sin(2 * delta_rad);
P_salient = P_excitation + P_reluctance;

% Cari Daya Puncak Maksimum
[P_max_cyl, idx_cyl] = max(P_cylindrical);
[P_max_sal, idx_sal] = max(P_salient);

fprintf('=========================================================\n');
fprintf('  ANALISIS KARAKTERISTIK DAYA-SUDUT ROTOR GENERATOR\n');
fprintf('=========================================================\n\n');
fprintf('GENERATOR KUTUB SILINDER:\n');
fprintf('  Daya Maksimum P_max  : %.4f pu\n', P_max_cyl);
fprintf('  Sudut Stabilitas     : %.1f derajat\n\n', delta_deg(idx_cyl));

fprintf('GENERATOR KUTUB SEPATU (SALIENT):\n');
fprintf('  Daya Maksimum P_max  : %.4f pu (+%.2f%%)\n', ...
        P_max_sal, ((P_max_sal - P_max_cyl)/P_max_cyl)*100);
fprintf('  Sudut Stabilitas     : %.1f derajat\n', delta_deg(idx_sal));
fprintf('  Puncak Daya Reluktansi: %.4f pu (pada delta = 45 deg)\n', max(P_reluctance));
