%% DSTL 2026 - MINGGU 04: SINTESIS MATRIKS ABCD TRANSMISI
% Dosen: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

% Parameter Saluran SUTT 150 kV
Length_km = 150;     % Panjang bentangan (km)
R_km = 0.12;         % Ohm/km
XL_km = 0.40;        % Ohm/km
BC_km = 3.0e-6;      % S/km

% Total Impedansi Seri dan Admitansi Shunt
Z = (R_km + 1j * XL_km) * Length_km;
Y = (1j * BC_km) * Length_km;

% Matriks ABCD Model Nominal-PI
A_pi = 1 + (Z * Y) / 2;
B_pi = Z;
C_pi = Y * (1 + (Z * Y) / 4);
D_pi = A_pi;

% Matriks ABCD Model Nominal-T
A_t = 1 + (Z * Y) / 2;
B_t = Z * (1 + (Z * Y) / 4);
C_t = Y;
D_t = A_t;

% Verifikasi Sifat Resiprositas (det = 1)
det_pi = A_pi * D_pi - B_pi * C_pi;
det_t = A_t * D_t - B_t * C_t;

fprintf('=== MATRIKS PARAMETER ABCD NOMINAL-PI ===\n');
fprintf('A = %.5f + j%.5f  (|A| = %.5f)\n', real(A_pi), imag(A_pi), abs(A_pi));
fprintf('B = %.3f + j%.3f Ohm\n', real(B_pi), imag(B_pi));
fprintf('C = %.7f + j%.7f S\n', real(C_pi), imag(C_pi));
fprintf('D = %.5f + j%.5f\n', real(D_pi), imag(D_pi));
fprintf('Uji Resiprositas (AD - BC) : %.6f + j%.6f (Eksak = 1.0)\n\n', real(det_pi), imag(det_pi));

% Kondisi Beban Operasi
V_R_LL = 150e3;                        % 150 kV
V_R_LN = V_R_LL / sqrt(3);             % Tegangan fasa
S_load_MVA = 100;                      % 100 MVA
pf = 0.85;                             % lagging
I_R_mag = (S_load_MVA * 1e6) / (sqrt(3) * V_R_LL);
th_R = -acos(pf);
I_R = I_R_mag * (cos(th_R) + 1j * sin(th_R));

% Hitung Tegangan dan Arus Pengirim
V_S_LN = A_pi * V_R_LN + B_pi * I_R;
I_S = C_pi * V_R_LN + D_pi * I_R;
V_S_LL = abs(V_S_LN) * sqrt(3);

% Regulasi Tegangan dan Efisiensi
VR_pct = ((abs(V_S_LN) / abs(A_pi) - V_R_LN) / V_R_LN) * 100;
P_R = S_load_MVA * 1e6 * pf;
P_S = 3 * real(V_S_LN * conj(I_S));
Eff_pct = (P_R / P_S) * 100;

fprintf('=== UNJUK KERJA OPERASI SALURAN ===\n');
fprintf('Tegangan Pengirim (Vs,LL)  : %.2f kV\n', V_S_LL / 1e3);
fprintf('Arus Pengirim (Is)         : %.2f A\n', abs(I_S));
fprintf('Regulasi Tegangan (%%VR)    : %.2f %%\n', VR_pct);
fprintf('Efisiensi Penyaluran (eta) : %.2f %%\n', Eff_pct);
