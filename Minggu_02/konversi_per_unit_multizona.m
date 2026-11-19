%% DSTL 2026 - BAB 2: OTOMASI SISTEM PER-UNIT TRANSMISI MULTI-ZONA
% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro, Fakultas Teknik, Universitas Bengkulu
% Kasus Riil: Evakuasi PLTU Teluk Sepang menuju GI Curup 150 kV
clear; clc;

% 1. Basis Global Sistem
S_base = 100;                % 100 MVA sistem
V_b1 = 13.8;                 % 13.8 kV pada Zona Pembangkit

% 2. Perambatan Tegangan Basis Melintasi Trafo
V_b2 = V_b1 * (150 / 13.8);  % 150 kV (Zona Transmisi SUTT)
V_b3 = V_b2 * (20 / 150);    % 20 kV (Zona Distribusi Curup)

% 3. Impedansi Basis Tiap Zona (Ohm)
Z_b1 = (V_b1^2) / S_base;
Z_b2 = (V_b2^2) / S_base;
Z_b3 = (V_b3^2) / S_base;

% 4. Konversi Reaktansi Peralatan ke Basis Baru
X_g_pu  = 0.15 * (13.8/V_b1)^2 * (S_base/100);
X_t1_pu = 0.10 * (150/V_b2)^2 * (S_base/120);
Z_line_pu = (7.5 + 1j*28.5) / Z_b2;
X_t2_pu = 0.08 * (150/V_b2)^2 * (S_base/60);

Z_total_pu = 1j*X_g_pu + 1j*X_t1_pu + Z_line_pu + 1j*X_t2_pu;

fprintf('========================================================\n');
fprintf('  HASIL SISTEM PER-UNIT SUBSISTEM BENGKULU (100 MVA)\n');
fprintf('========================================================\n');
fprintf('Zona 1 (Gen) : Vb = %6.2f kV | Zb = %8.4f Ohm\n', V_b1, Z_b1);
fprintf('Zona 2 (Line): Vb = %6.2f kV | Zb = %8.4f Ohm\n', V_b2, Z_b2);
fprintf('Zona 3 (Load): Vb = %6.2f kV | Zb = %8.4f Ohm\n\n', V_b3, Z_b3);
fprintf('Reaktansi Per-Unit Komponen:\n');
fprintf('  - Gen Teluk Sepang : j%.4f pu\n', X_g_pu);
fprintf('  - Trafo T1         : j%.4f pu\n', X_t1_pu);
fprintf('  - Saluran 150 kV   : %.4f + j%.4f pu\n', real(Z_line_pu), imag(Z_line_pu));
fprintf('  - Trafo T2         : j%.4f pu\n', X_t2_pu);
fprintf('  - Impedansi Total  : %.4f + j%.4f pu\n', real(Z_total_pu), imag(Z_total_pu));
fprintf('========================================================\n');
