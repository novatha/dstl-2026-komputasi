%% DSTL 2026 - MINGGU 07: VOLTAGE RISE & VOLT-VAR CONTROL PLTS ATAP
% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

% Parameter Penyulang 20 kV
V_gi = 20e3;               % V (1.0 pu)
R = 1.8;                   % Ohm
X = 2.8;                   % Ohm

% Beban Siang Hari
P_load = 2.0e6;            % 2.0 MW
Q_load = 1.0e6;            % 1.0 MVAR

% Variasi Kapasitas Penetrasi PLTS Atap (0 s.d. 8 MW)
P_pv_vec = (0:1:8) * 1e6;
V_tanpa_control = zeros(size(P_pv_vec));
V_dengan_control = zeros(size(P_pv_vec));

fprintf('=========================================================\n');
fprintf('  SIMULASI VOLTAGE RISE & VOLT-VAR SMART INVERTER\n');
fprintf('=========================================================\n\n');
fprintf('PLTS (MW)    P_net (MW)    Tegangan Biasa (pu)   Dengan Volt-VAR (pu)\n');
fprintf('--------------------------------------------------------------------\n');

for i = 1:length(P_pv_vec)
    P_pv = P_pv_vec(i);
    P_net = P_load - P_pv;
    Q_net = Q_load;
    
    % Kasus 1: Inverter pf = 1.0 (Tanpa Kendali VAR)
    DV = (P_net * R + Q_net * X) / V_gi;
    Vr = V_gi - DV;
    V_tanpa_control(i) = Vr / V_gi;
    
    % Kasus 2: Smart Inverter dengan Volt-VAR Control
    % Jika Vr > 1.02 pu, inverter menyerap Q_inj = -0.35 * P_pv
    if V_tanpa_control(i) > 1.02
        Q_pv = -0.35 * P_pv; % menyerap VAR
    else
        Q_pv = 0;
    end
    Q_net_ctrl = Q_load - Q_pv;
    DV_ctrl = (P_net * R + Q_net_ctrl * X) / V_gi;
    Vr_ctrl = V_gi - DV_ctrl;
    V_dengan_control(i) = Vr_ctrl / V_gi;
    
    fprintf('%5.1f         %6.1f              %6.4f                %6.4f\n', ...
            P_pv/1e6, P_net/1e6, V_tanpa_control(i), V_dengan_control(i));
end
