%% DSTL 2026 - MINGGU 06: KURVA KAPABILITAS GENERATOR SINKRON
% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

fprintf('=========================================================\n');
fprintf('  PROGRAM SINTESIS KURVA KAPABILITAS GENERATOR SINKRON\n');
fprintf('=========================================================\n\n');

% 1. Parameter Generator PLTA Musi
S_rated_MVA = 70.0;     % MVA
V_LL_kV = 11.0;         % kV
Xs_ohm = 1.35;          % Ohm per fasa
pf_rated = 0.85;        % lagging

% Konversi ke Basis Per-Unit (pu)
Z_base = (V_LL_kV^2) / S_rated_MVA;
Xs_pu = Xs_ohm / Z_base;
Vt_pu = 1.0;            % Bus tegangan nominal

fprintf('Basis Impedansi Mesin (Z_base) : %.4f Ohm\n', Z_base);
fprintf('Reaktansi Sinkron Mesin (Xs)   : %.4f pu\n\n', Xs_pu);

% 2. Titik Nominal Beban Penuh
P_rated_pu = pf_rated;
Q_rated_pu = sqrt(1 - pf_rated^2);
Ia_rated_pu = 1.0;

% Tegangan Eksitasi Maksimum (Ea_max pada rated over-excited)
Ea_rated_complex = Vt_pu + 1j * Xs_pu * (P_rated_pu - 1j*Q_rated_pu);
Ea_max_pu = abs(Ea_rated_complex);
fprintf('Tegangan Eksitasi Penuh (Ea_max): %.4f pu\n', Ea_max_pu);

% 3. Batas Arus Jangkar Stator (Lingkaran pusat 0, 0)
th_stator = linspace(0, pi, 150);
P_stator = S_rated_MVA * sin(th_stator);
Q_stator = S_rated_MVA * cos(th_stator);

% 4. Batas Arus Medan Rotor (Pusat di 0, -Vt^2/Xs)
center_Q_MVAR = -(Vt_pu^2 / Xs_pu) * S_rated_MVA;
radius_field_MVAR = (Ea_max_pu * Vt_pu / Xs_pu) * S_rated_MVA;

th_field = linspace(deg2rad(20), deg2rad(160), 150);
Q_field = radius_field_MVAR * cos(th_field);
P_field = center_Q_MVAR + radius_field_MVAR * sin(th_field);

% 5. Batas Stabilitas Praktis (Sudut rotor delta = 75 derajat)
delta_lim_deg = 75;
P_stab_vec = linspace(0, S_rated_MVA, 100);
Q_stab_vec = (P_stab_vec / tan(deg2rad(delta_lim_deg))) + center_Q_MVAR;

% 6. Batas Daya Turbin Penggerak Mula (Turbin Francis 60 MW)
P_turbin_MW = 60.0;

% Tampilkan Data Evaluasi ke Konsol
fprintf('--- EVALUASI BATAS KAPABILITAS OPERASI (MVAR) ---\n');
fprintf('Injeksi Reaktif Maksimum (+Q)  : %.2f MVAR\n', radius_field_MVAR + center_Q_MVAR);
fprintf('Penyerapan Reaktif Batas (-Q)  : %.2f MVAR\n', center_Q_MVAR);
fprintf('Kapasitas Turbin Penggerak     : %.2f MW\n', P_turbin_MW);
