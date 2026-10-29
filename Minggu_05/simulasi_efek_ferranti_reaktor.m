%% DSTL 2026 - MINGGU 05: KALKULASI REAKTOR SHUNT PENETRAL FERRANTI
% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

% Parameter Saluran Tol Sumatera 275 kV
V_nom_LL = 275;          % kV
L_km = 200;              % Panjang transmisi (km)
f = 50; omega = 2*pi*f;

r_km = 0.045;            % Ohm/km
x_km = 0.310;            % Ohm/km
b_km = 3.65e-6;          % S/km

z = r_km + 1j*x_km;
y = 1j*b_km;
gamma = sqrt(z * y);
Zc = sqrt(z / y);

% Matriks ABCD Eksak
A = cosh(gamma * L_km);
B = Zc * sinh(gamma * L_km);
C = (1/Zc) * sinh(gamma * L_km);
D = A;

% 1. Analisis Efek Ferranti Tanpa Kompensasi
Vs_ph = (V_nom_LL * 1e3) / sqrt(3);
Vr_NL_ph = Vs_ph / A;
Vr_NL_LL = (abs(Vr_NL_ph) * sqrt(3)) / 1e3;
delta_V_pct = ((Vr_NL_LL - V_nom_LL) / V_nom_LL) * 100;

fprintf('=====================================================\n');
fprintf('  ANALISIS EFEK FERRANTI & REAKTOR SHUNT SUTET 275 kV\n');
fprintf('=====================================================\n\n');
fprintf('Tegangan Pangkal Pengirim      : %.2f kV\n', V_nom_LL);
fprintf('Tegangan Ujung Beban Terbuka   : %.2f kV\n', Vr_NL_LL);
fprintf('Kenaikan Tegangan (Ferranti)   : +%.2f kV (+%.2f%%)\n', ...
        Vr_NL_LL - V_nom_LL, delta_V_pct);

if delta_V_pct > 5.0
    fprintf('STATUS: MELEBIHI BATAS GRID CODE (+5%%)! Reaktor Shunt Wajib Dipasang.\n\n');
else
    fprintf('STATUS: Memenuhi batasan Grid Code.\n\n');
end

% 2. Hitung Suseptansi dan Daya Reaktif Reaktor Shunt untuk Vr = Vs
% Formula Eksak: B_L = (1 - cos(beta*l)) / (Zc * sin(beta*l))
beta_l = imag(gamma) * L_km;
B_L_fasa = (1 - cos(beta_l)) / (real(Zc) * sin(beta_l));
Q_sh_3ph_MVAR = (V_nom_LL^2) * B_L_fasa;

fprintf('--- PERANCANGAN REAKTOR SHUNT GI PENERIMA ---\n');
fprintf('Suseptansi Reaktor per Fasa (BL) : %.5e Siemens\n', B_L_fasa);
fprintf('Kapasitas Total 3-Fasa Reaktor   : %.2f MVAR\n', Q_sh_3ph_MVAR);

% Verifikasi Tegangan Pasca Pemasangan Reaktor Shunt
I_R_reactor = -1j * B_L_fasa * (Vs_ph); % saat Vr = Vs
Vs_check = A * Vs_ph + B * I_R_reactor;
Vs_check_LL = (abs(Vs_check) * sqrt(3)) / 1e3;
fprintf('Verifikasi Tegangan Ujung        : %.2f kV (Target Ideal = %.2f kV)\n', ...
        Vs_check_LL, V_nom_LL);
