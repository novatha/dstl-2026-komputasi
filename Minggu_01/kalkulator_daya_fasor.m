%% =========================================================================
%% DSTL 2026 - MINGGU 01: PENGANTAR SISTEM TENAGA & KOMPUTASI FASOR
%% Program Studi S1 Teknik Elektro - Universitas Bengkulu
%% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
%% =========================================================================
%% Topik: Perhitungan Fasor Tegangan-Arus, Daya Kompleks S = P + jQ,
%%        Faktor Daya (pf), dan Visualisasi Segitiga Daya
%% =========================================================================

clear; clc; close all;

fprintf('====================================================\n');
fprintf('  KALKULATOR DAYA KOMPLEKS & FASOR SISTEM TENAGA    \n');
fprintf('  Mata Kuliah: Dasar-Dasar Sistem Tenaga Listrik    \n');
fprintf('====================================================\n\n');

%% 1. Parameter Masukan (Input Parameters)
V_rms = 220;               % Tegangan rms (Volt)
theta_v = 0;               % Sudut fasa tegangan (derajat)
Z_R = 15;                  % Resistansi beban (Ohm)
Z_L = 10;                  % Reaktansi induktif beban (Ohm)
Z_load = Z_R + 1j*Z_L;     % Impedansi kompleks (Ohm)

%% 2. Perhitungan Fasor Arus & Daya Kompleks
V_phasor = V_rms * exp(1j * deg2rad(theta_v));
I_phasor = V_phasor / Z_load;

I_mag = abs(I_phasor);
I_ang_deg = rad2deg(angle(I_phasor));

% Daya Kompleks S = V * conj(I)
S = V_phasor * conj(I_phasor);
P = real(S);               % Daya Aktif (Watt)
Q = imag(S);               % Daya Reaktif (VAR)
S_mag = abs(S);            % Daya Semu (VA)
pf = cos(angle(S));        % Faktor Daya (Power Factor)

%% 3. Menampilkan Hasil Kalkulasi ke Layar
fprintf('--- HASIL PERHITUNGAN SISTEM ---\n');
fprintf('Tegangan Sumber (V)   : %.2f ∠ %.2f° V\n', V_rms, theta_v);
fprintf('Impedansi Beban (Z)   : %.2f + j%.2f Ω (Mag: %.2f Ω)\n', real(Z_load), imag(Z_load), abs(Z_load));
fprintf('Arus Saluran (I)      : %.2f ∠ %.2f° A\n', I_mag, I_ang_deg);
fprintf('Daya Aktif (P)        : %.2f Watt (%.3f kW)\n', P, P/1e3);
fprintf('Daya Reaktif (Q)      : %.2f VAR (%.3f kVAR)\n', Q, Q/1e3);
fprintf('Daya Semu (|S|)       : %.2f VA (%.3f kVA)\n', S_mag, S_mag/1e3);
fprintf('Faktor Daya (pf)      : %.4f (Lagging)\n\n', pf);

%% 4. Perbaikan Faktor Daya (Pemasangan Kapasitor Shunt)
pf_target = 0.95;
theta_target = acos(pf_target);
Q_target = P * tan(theta_target);
Q_cap = Q - Q_target;      % Daya reaktif kapasitor yang dibutuhkan
C_val = Q_cap / (2 * pi * 50 * V_rms^2); % Kapasitansi (Farad) pada f=50Hz

fprintf('--- PERBAIKAN FAKTOR DAYA (TARGET pf = %.2f) ---\n', pf_target);
fprintf('Kompensasi Q_cap      : %.2f VAR (%.3f kVAR)\n', Q_cap, Q_cap/1e3);
fprintf('Kapasitor Diperlukan  : %.2f µF (pada f = 50 Hz)\n', C_val * 1e6);
fprintf('Daya Semu Baru (|S|)  : %.2f VA (Pengurangan %.2f%%)\n\n', ...
        P/pf_target, (1 - (P/pf_target)/S_mag)*100);

%% 5. Plotting Segitiga Daya
figure('Name', 'Visualisasi Segitiga Daya', 'NumberTitle', 'off');
hold on; grid on;

% Segitiga Daya Awal
plot([0, P], [0, 0], 'b-', 'LineWidth', 2.5);           % Vektor P
plot([P, P], [0, Q], 'r-', 'LineWidth', 2.5);           % Vektor Q awal
plot([0, P], [0, Q], 'k--', 'LineWidth', 2);            % Vektor S awal

% Segitiga Daya Setelah Kompensasi
plot([P, P], [0, Q_target], 'g-', 'LineWidth', 2.5);    % Vektor Q baru
plot([0, P], [0, Q_target], 'm-.', 'LineWidth', 2);     % Vektor S baru

title(sprintf('Segitiga Daya Beban AC 1-Fasa (P = %.1f W)', P), 'FontSize', 12);
xlabel('Daya Aktif P (Watt)', 'FontSize', 11);
ylabel('Daya Reaktif Q (VAR)', 'FontSize', 11);
legend({'Daya Aktif P', 'Q Awal (Induktif)', 'Daya Semu S Awal', ...
        'Q Baru (Setelah Kompensasi)', 'Daya Semu S Baru'}, 'Location', 'northwest');
axis([0, P*1.2, 0, Q*1.2]);
hold off;

fprintf('Skrip selesai dijalankan dengan sukses.\n');
