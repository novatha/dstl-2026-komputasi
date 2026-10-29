%% DSTL 2026 - MINGGU 03: KURVA REGULASI TEGANGAN & EFISIENSI
clear; clc;

S_rated = 100e3;      % 100 kVA
V2_nom = 400;         % 400 V
P_core = 260;         % Watt
P_cu_fl = 2087;       % Watt pada 75 C
Req2 = 0.03340;       % Ohm (sisi LV)
Xeq2 = 0.05755;       % Ohm (sisi LV)
I2_fl = S_rated / V2_nom; % 250 A

% Vektor Fraksi Pembebanan (10% hingga 150%)
x = linspace(0.1, 1.5, 150);

% 1. Simulasi Kurva Efisiensi pada Berbagai Faktor Daya
pf_list = [1.0, 0.85, 0.70];
eff_matrix = zeros(length(pf_list), length(x));

for k = 1:length(pf_list)
    pf = pf_list(k);
    P_out = x * S_rated * pf;
    P_losses = P_core + (x.^2) * P_cu_fl;
    eff_matrix(k, :) = (P_out ./ (P_out + P_losses)) * 100;
end

% Fraksi Efisiensi Puncak Analitis
x_opt = sqrt(P_core / P_cu_fl);
S_opt = x_opt * (S_rated / 1e3);

fprintf('=== TITIK KERJA OPTIMAL TRANSFORMATOR ===\n');
fprintf('Efisiensi Puncak terjadi pada pembebanan : %.2f %%\n', x_opt * 100);
fprintf('Kapasitas Pembebanan Optimum             : %.2f kVA\n', S_opt);

% 2. Simulasi Regulasi Tegangan vs Sudut Faktor Daya
theta_deg = -60:1:60; % Negatif = leading, Positif = lagging
theta_rad = theta_deg * (pi / 180);
VR_curve = zeros(size(theta_rad));

for i = 1:length(theta_rad)
    th = theta_rad(i);
    % Formula Eksak
    V1_a = sqrt((V2_nom*cos(th) + I2_fl*Req2)^2 + (V2_nom*sin(th) + I2_fl*Xeq2)^2);
    VR_curve(i) = ((V1_a - V2_nom) / V2_nom) * 100;
end

% Cari Titik Regulasi Nol (Zero Regulation Point)
[~, idx_zero] = min(abs(VR_curve));
fprintf('Regulasi Nol (VR = 0%%) pada pf leading  : %.2f (sudut %.1f deg)\n', ...
        cos(theta_rad(idx_zero)), theta_deg(idx_zero));
