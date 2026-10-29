%% DSTL 2026 - MINGGU 05: SIMULASI TRANSIEN KISI BEWLEY
% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

% Parameter Saluran
L_km = 300;              % km
v_km_s = 300000;         % Kecepatan cahaya di udara (km/s)
tau_s = L_km / v_km_s;   % Waktu tempuh satu arah (detik)
tau_us = tau_s * 1e6;    % Waktu tempuh dalam mikrodetik

% Tegangan Sumber Surja DC Ekivalen
V0 = 1.0; % 1.0 pu

% Koefisien Refleksi
Gamma_R = +1.0;  % Ujung beban terbuka (ZL -> Inf)
Gamma_S = -1.0;  % Sumber ideal tegangan konstan (Zs -> 0)

fprintf('Waktu Tempuh Saluran Satu Arah (tau): %.2f us\n', tau_us);
fprintf('Koefisien Refleksi Pengirim (Gamma_S): %.2f\n', Gamma_S);
fprintf('Koefisien Refleksi Penerima (Gamma_R): %.2f\n\n', Gamma_R);

% Simulasi Kisi Langkah Waktu
time_steps = 0:tau_us:(7*tau_us);
V_R_arr = zeros(size(time_steps));

% Kalkulasi tegangan kumulatif di ujung beban
fprintf('Waktu (us)    Kelipatan tau    Tegangan Datang    Tegangan Total Vr(t)\n');
fprintf('--------------------------------------------------------------------\n');

V_total = 0;
wave_forward = V0;

for n = 1:length(time_steps)
    t_cur = time_steps(n);
    k = n - 1; % indeks kelipatan tau
    
    if k == 0
        V_total = 0;
    elseif mod(k, 2) == 1
        % Gelombang tiba di ujung penerima (k = 1, 3, 5, 7 ...)
        delta_V = (1 + Gamma_R) * wave_forward;
        V_total = V_total + delta_V;
        % Gelombang pantul yang berbalik menuju pengirim
        wave_reflected = Gamma_R * wave_forward;
        % Gelombang datang berikutnya setelah dipantulkan dari pengirim
        wave_forward = Gamma_S * wave_reflected;
    end
    
    V_R_arr(n) = V_total;
    fprintf('%8.1f          %d tau              -               %.2f pu\n', ...
            t_cur, k, V_total);
end
