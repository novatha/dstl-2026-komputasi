%% DSTL 2026 - MINGGU 04: PARAMETER GMD, GMR, L, C SUTT/SUTET
% Dosen: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

fprintf('=====================================================\n');
fprintf('  PROGRAM KALKULASI PARAMETER FISIK SALURAN TRANSMISI\n');
fprintf('=====================================================\n\n');

% 1. Input Geometri Menara (Jarak Antar-Fasa dalam Meter)
D_ab = 8.0;   % Jarak fasa a ke b (meter)
D_bc = 8.0;   % Jarak fasa b ke c (meter)
D_ca = 16.0;  % Jarak fasa c ke a (meter)

% 2. Data Fisik Konduktor (ACSR Drake)
d_out_mm = 28.10;              % Diameter luar (mm)
r_phys = (d_out_mm / 2) / 1e3; % Jari-jari fisik (meter)
Ds_single = 0.01140;           % GMR kawat tunggal (meter)
R_ac_km = 0.085;               % Resistansi AC (Ohm/km)
freq = 50;                     % Frekuensi sistem (Hz)
eps0 = 8.854e-12;              % Permitivitas ruang hampa (F/m)

% 3. Parameter Konduktor Berkas (2-Bundle, Spacer = 40 cm)
n_bundle = 2;
d_space = 0.40; % Jarak pemisah kawat berkas (meter)

% Hitung GMD
GMD = (D_ab * D_bc * D_ca)^(1/3);

% Hitung GMR Induktansi Berkas dan GMR Kapasitansi Berkas
Ds_bundle = sqrt(Ds_single * d_space);
r_bundle = sqrt(r_phys * d_space);

% Hitung Induktansi dan Reaktansi Seri per km
L_H_m = 2e-7 * log(GMD / Ds_bundle);
L_mH_km = L_H_m * 1e6;
XL_km = 2 * pi * freq * L_H_m * 1e3;

% Hitung Kapasitansi dan Suseptansi Shunt per km
C_F_m = (2 * pi * eps0) / log(GMD / r_bundle);
C_uF_km = C_F_m * 1e9;
BC_uS_km = 2 * pi * freq * C_F_m * 1e9;

% Resistansi Ekivalen Berkas (Dua kawat paralel)
R_bundle_km = R_ac_km / n_bundle;

% Cetak Hasil Konsol
fprintf('Jarak Ekuivalen Fasa (GMD)         : %.4f meter\n', GMD);
fprintf('GMR Induktansi Berkas (Ds_b)       : %.5f meter (%.2f mm)\n', Ds_bundle, Ds_bundle*1e3);
fprintf('GMR Kapasitansi Berkas (r_b)       : %.5f meter (%.2f mm)\n\n', r_bundle, r_bundle*1e3);

fprintf('--- PARAMETER SERI PER FASA PER KM ---\n');
fprintf('Resistansi Saluran (R)             : %.4f Ohm/km\n', R_bundle_km);
fprintf('Induktansi Saluran (L)             : %.4f mH/km\n', L_mH_km);
fprintf('Reaktansi Induktif (XL)            : %.4f Ohm/km\n\n', XL_km);

fprintf('--- PARAMETER SHUNT PER FASA PER KM ---\n');
fprintf('Kapasitansi Saluran (Cn)           : %.5f uF/km\n', C_uF_km);
fprintf('Suseptansi Kapasitif (BC)          : %.4f uS/km\n', BC_uS_km);
