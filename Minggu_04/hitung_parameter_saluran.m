%% =========================================================================
%% DSTL 2026 - MINGGU 04: PARAMETER TRANSMISI & MODEL NOMINAL-PI
%% Program Studi S1 Teknik Elektro - Universitas Bengkulu
%% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
%% =========================================================================
%% Topik: 1. Kalkulasi GMD, GMR Konduktor Berkas (Bundle)
%%        2. Ekstraksi Induktansi (L) & Kapasitansi (C) Fisik
%%        3. Formulasi Matriks Parameter Transmisi ABCD (Nominal-Pi & T)
%%        4. Simulasi Regulasi Tegangan vs Variasi Faktor Daya Beban
%% =========================================================================

clear; clc; close all;

fprintf('====================================================================\n');
fprintf('  KALKULATOR PARAMETER SALURAN TRANSMISI SUTT 150 kV & MATRIKS ABCD \n');
fprintf('  Mata Kuliah: Dasar-Dasar Sistem Tenaga Listrik - UNIB 2026        \n');
fprintf('====================================================================\n\n');

%% 1. Parameter Geometri Fisis Tower & Kawat (Physical Line Geometry)
L_saluran = 150;           % Panjang saluran transmisi (km)
f0 = 50;                   % Frekuensi sistem (Hz)
omega = 2 * pi * f0;

% Jarak Antar-Fasa pada Tower (Konfigurasi Horizontal / Asimetris)
D_ab = 4.0;                % Jarak fasa A ke B (meter)
D_bc = 4.0;                % Jarak fasa B ke C (meter)
D_ca = 8.0;                % Jarak fasa C ke A (meter)
GMD = (D_ab * D_bc * D_ca)^(1/3);

% Spesifikasi Kawat Konduktor ACSR (Tipe Hawk 241.6 mm2)
r_fisik = 0.0109;          % Jari-jari luar konduktor (meter)
r_prime = 0.7788 * r_fisik;% GMR kawat tunggal (meter)
r_ohm_km = 0.133;          % Resistansi AC per km (Ohm/km)

% Konfigurasi Konduktor Berkas 2-Kawat (2-Bundle)
d_bundle = 0.40;           % Jarak pemisah antar sub-konduktor (meter)
GMR_L = sqrt(r_prime * d_bundle); % GMR untuk perhitungan induktansi
GMR_C = sqrt(r_fisik * d_bundle); % GMR untuk perhitungan kapasitansi

%% 2. Perhitungan Parameter R, L, C per Satuan Panjang
% Induktansi & Kapasitansi Saluran 3-Fasa Transposed
L_per_m = 2e-7 * log(GMD / GMR_L);        % H/m
C_per_m = (2 * pi * 8.854e-12) / log(GMD / GMR_C); % F/m

L_per_km = L_per_m * 1000;                % H/km
C_per_km = C_per_m * 1000;                % F/km

z_seri_km = (r_ohm_km / 2) + 1j * omega * L_per_km; % 2-bundle paralel
y_shunt_km = 1j * omega * C_per_km;

Z_total = z_seri_km * L_saluran;          % Impedansi seri total (Ohm)
Y_total = y_shunt_km * L_saluran;         % Admitansi shunt total (Siemens)

fprintf('--- PARAMETER ELEKTRIS SALURAN ---\n');
fprintf('Geometric Mean Distance (GMD) : %.4f m\n', GMD);
fprintf('GMR Induktif Berkas (GMR_L)   : %.4f m\n', GMR_L);
fprintf('Induktansi per km (L)         : %.4f mH/km\n', L_per_km * 1e3);
fprintf('Kapasitansi per km (C)        : %.4f µF/km\n', C_per_km * 1e6);
fprintf('Impedansi Total Saluran (Z)   : %.2f + j%.2f Ω (|Z| = %.2f Ω)\n', ...
        real(Z_total), imag(Z_total), abs(Z_total));
fprintf('Admitansi Total Saluran (Y)   : %.6f + j%.6f S (|Y| = %.6f S)\n\n', ...
        real(Y_total), imag(Y_total), abs(Y_total));

%% 3. Formulasi Matriks Konstanta Transmisi ABCD (Model Nominal-Pi)
A_pi = 1 + (Z_total * Y_total) / 2;
B_pi = Z_total;
C_pi = Y_total * (1 + (Z_total * Y_total) / 4);
D_pi = A_pi;

fprintf('--- MATRIKS PARAMETER ABCD (MODEL NOMINAL-PI) ---\n');
fprintf('A = D : %.4f + j%.4f (Magnitudo: %.4f, Sudut: %.2f°)\n', ...
        real(A_pi), imag(A_pi), abs(A_pi), rad2deg(angle(A_pi)));
fprintf('B     : %.2f + j%.2f Ω (Magnitudo: %.2f Ω)\n', ...
        real(B_pi), imag(B_pi), abs(B_pi));
fprintf('C     : %.6f + j%.6f S (Magnitudo: %.6f S)\n', ...
        real(C_pi), imag(C_pi), abs(C_pi));
fprintf('Uji Sifat Resiprositas (AD-BC): %.4f + j%.4f (Tepat = 1.0000)\n\n', ...
        real(A_pi*D_pi - B_pi*C_pi), imag(A_pi*D_pi - B_pi*C_pi));

%% 4. Perhitungan Kondisi Operasi Beban Penuh (Full Load Operation)
VR_LL = 150e3;             % Tegangan nominal penerima 150 kV
VR_LN = VR_LL / sqrt(3);   % Tegangan fasa-ke-netral (Volt)
PR_total = 100e6;          % Daya aktif beban 100 MW
pf_nominal = 0.90;         % Faktor daya beban 0.90 lagging

% Arus Beban Fasor
IR_mag = PR_total / (sqrt(3) * VR_LL * pf_nominal);
theta_R = -acos(pf_nominal);
IR_phasor = IR_mag * exp(1j * theta_R);

% Perhitungan Tegangan & Arus Sisi Pengirim (Sending-End)
VS_LN = A_pi * VR_LN + B_pi * IR_phasor;
VS_LL = abs(VS_LN) * sqrt(3);
IS_phasor = C_pi * VR_LN + D_pi * IR_phasor;

% Regulasi Tegangan & Efisiensi
V_no_load_LN = abs(VS_LN) / abs(A_pi);
VR_percent = ((V_no_load_LN - VR_LN) / VR_LN) * 100;

PS_total = 3 * real(VS_LN * conj(IS_phasor));
Ploss_total = PS_total - PR_total;
efisiensi = (PR_total / PS_total) * 100;

fprintf('--- EVALUASI KINERJA OPERASI (BEBAN 100 MW, pf 0.90 LAGGING) ---\n');
fprintf('Tegangan Pengirim (VS)        : %.2f kV (Line-to-Line, Sudut: %.2f°)\n', ...
        VS_LL/1e3, rad2deg(angle(VS_LN)));
fprintf('Arus Pengirim (IS)            : %.2f A (Sudut: %.2f°)\n', ...
        abs(IS_phasor), rad2deg(angle(IS_phasor)));
fprintf('Regulasi Tegangan (%%VR)       : %.2f%%\n', VR_percent);
fprintf('Rugi-Rugi Transmisi (Ploss)   : %.2f MW\n', Ploss_total/1e6);
fprintf('Efisiensi Transmisi (η)       : %.2f%%\n\n', efisiensi);

%% 5. Plotting Kurva Regulasi Tegangan terhadap Variasi Faktor Daya
pf_range = 0.70:0.02:1.00;
vr_lag = zeros(size(pf_range));
vr_lead = zeros(size(pf_range));

for k = 1:length(pf_range)
    pf_k = pf_range(k);
    
    % Kasus Lagging
    I_lag = (PR_total / (sqrt(3) * VR_LL * pf_k)) * exp(-1j * acos(pf_k));
    Vs_lag = A_pi * VR_LN + B_pi * I_lag;
    vr_lag(k) = ((abs(Vs_lag)/abs(A_pi) - VR_LN) / VR_LN) * 100;
    
    % Kasus Leading
    I_lead = (PR_total / (sqrt(3) * VR_LL * pf_k)) * exp(1j * acos(pf_k));
    Vs_lead = A_pi * VR_LN + B_pi * I_lead;
    vr_lead(k) = ((abs(Vs_lead)/abs(A_pi) - VR_LN) / VR_LN) * 100;
end

figure('Name', 'Karakteristik Regulasi Tegangan', 'NumberTitle', 'off');
plot(pf_range, vr_lag, 'r-o', 'LineWidth', 2); hold on;
plot(pf_range, vr_lead, 'b-s', 'LineWidth', 2); grid on;
xlabel('Faktor Daya Beban (\cos\theta)', 'FontSize', 11);
ylabel('Regulasi Tegangan (%VR)', 'FontSize', 11);
title('Pengaruh Faktor Daya Terhadap Regulasi Tegangan Saluran 150 kV 150 km', 'FontSize', 12);
legend({'Beban Induktif (Lagging)', 'Beban Kapasitif (Leading)'}, 'Location', 'northwest');
hold off;

fprintf('Simulasi selesai dan kurva regulasi tegangan berhasil ditampilkan.\n');
