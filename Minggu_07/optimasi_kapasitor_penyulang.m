%% DSTL 2026 - MINGGU 07: OPTIMASI PENEMPATAN KAPASITOR SHUNT
% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

% Parameter Saluran Penyulang 20 kV
V_nom = 20e3;              % V LL
L_km = 12;                 % km
r = 0.22;                  % Ohm/km
x = 0.35;                  % Ohm/km
P_load = 4.5e6;            % 4.5 MW
Q_load = 3.0e6;            % 3.0 MVAR (pf = 0.83)

% Variasi Lokasi Penempatan Kapasitor (0 s.d. L)
loc_vec = 2:2:12;          % km dari GI
Q_cap_tested = [1.0, 1.5, 2.0, 2.5] * 1e6; % MVAR

fprintf('=====================================================\n');
fprintf('  ANALISIS REDUKSI RUGI DAYA TERHADAP LOKASI KAPASITOR\n');
fprintf('=====================================================\n\n');
fprintf('Lokasi(km)   Qc=1.0MVAR   Qc=1.5MVAR   Qc=2.0MVAR   Qc=2.5MVAR\n');
fprintf('-----------------------------------------------------------------\n');

% Rugi tanpa kapasitor
R_tot = r * L_km;
Ploss_base_kW = (3 * ((sqrt(P_load^2 + Q_load^2)/(sqrt(3)*V_nom))^2) * R_tot) / 1e3;

for k = 1:length(loc_vec)
    d = loc_vec(k);
    fprintf('%5.1f km    ', d);
    
    for c = 1:length(Q_cap_tested)
        Qc = Q_cap_tested(c);
        
        % Rugi pada seksi sebelum kapasitor (0 s.d. d)
        R_d = r * d;
        S_sec1 = sqrt(P_load^2 + (Q_load - Qc)^2);
        I_sec1 = S_sec1 / (sqrt(3) * V_nom);
        Ploss_sec1 = 3 * I_sec1^2 * R_d;
        
        % Rugi pada seksi setelah kapasitor (d s.d. L)
        R_rem = r * (L_km - d);
        S_sec2 = sqrt(P_load^2 + Q_load^2);
        I_sec2 = S_sec2 / (sqrt(3) * V_nom);
        Ploss_sec2 = 3 * I_sec2^2 * R_rem;
        
        Ploss_tot_kW = (Ploss_sec1 + Ploss_sec2) / 1e3;
        delta_loss_pct = ((Ploss_base_kW - Ploss_tot_kW) / Ploss_base_kW) * 100;
        
        fprintf('   %5.1f kW(%.1f%%)', Ploss_tot_kW, delta_loss_pct);
    end
    fprintf('\n');
end
