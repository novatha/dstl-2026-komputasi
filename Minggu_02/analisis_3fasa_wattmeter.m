%% DSTL 2026 - BAB 2: ANALISIS 3-FASA & METODE DUA WATTMETER
% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro, Fakultas Teknik, Universitas Bengkulu
clear; clc;

fprintf('========================================================\n');
fprintf('  DSTL 2026: KALKULATOR RANGKAIAN TIGA FASA & WATTMETER\n');
fprintf('========================================================\n');

% 1. Parameter Masukan Rangkaian
V_L = 380;                   % Tegangan saluran Line-to-Line (V)
Z_delta = 15 + 1j*20;        % Impedansi cabang Delta (Ohm)

% 2. Konversi Ekivalen Bintang (Y)
Z_y = Z_delta / 3;
V_ph = V_L / sqrt(3);

% 3. Arus dan Faktor Daya
I_line = abs(V_ph / Z_y);
theta = angle(Z_y);
pf = cos(theta);

% 4. Daya Tiga Fasa
P_total = sqrt(3) * V_L * I_line * pf;
Q_total = sqrt(3) * V_L * I_line * sin(theta);
S_total = sqrt(3) * V_L * I_line;

% 5. Simulasi Pembacaan Dua Wattmeter
W1 = V_L * I_line * cos(pi/6 + theta);
W2 = V_L * I_line * cos(pi/6 - theta);

% Rekonstruksi Daya dari Hasil Ukur
P_rek = W1 + W2;
tan_th = sqrt(3) * (W2 - W1) / (W1 + W2);
pf_rek = cos(atan(tan_th));

fprintf('HASIL PERHITUNGAN:\n');
fprintf('  - Arus Saluran (IL)       : %8.2f A\n', I_line);
fprintf('  - Faktor Daya (PF)        : %8.4f lagging\n', pf);
fprintf('  - Daya Aktif (P)          : %8.2f kW\n', P_total/1e3);
fprintf('  - Daya Reaktif (Q)        : %8.2f kVAR\n', Q_total/1e3);
fprintf('  - Pembacaan Wattmeter 1   : %8.2f kW\n', W1/1e3);
fprintf('  - Pembacaan Wattmeter 2   : %8.2f kW\n', W2/1e3);
fprintf('  - Verifikasi Rekonstruksi : %8.2f kW (Cocok!)\n', P_rek/1e3);
fprintf('  - Rekonstruksi PF         : %8.4f\n', pf_rek);
fprintf('========================================================\n');
