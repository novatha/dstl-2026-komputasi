%% DSTL 2026 - MINGGU 07: ALIRAN DAYA DISTRIBUSI FORWARD-BACKWARD SWEEP
% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

fprintf('=========================================================\n');
fprintf('  ALIRAN DAYA DISTRIBUSI FORWARD-BACKWARD SWEEP (FBS)\n');
fprintf('=========================================================\n\n');

% 1. Data Jaringan Penyulang Radial 20 kV (4 Bus, 3 Cabang)
% Bus 1 = Slack (GI), Bus 2, 3, 4 = Gardu Trafo Distribusi
V_slack_LL = 20e3;              % Volt
V_slack_ph = V_slack_LL / sqrt(3);

% Cabang: [dari_bus, ke_bus, R_ohm, X_ohm]
branch_data = [
    1, 2, 0.88, 1.44;  % Seksi 1: 4 km AAAC 150
    2, 3, 0.66, 1.08;  % Seksi 2: 3 km
    3, 4, 1.10, 1.80   % Seksi 3: 5 km
];

% Beban Bus: [bus_no, P_MW, Q_MVAR]
load_data = [
    2, 1.2, 0.8;
    3, 1.5, 0.9;
    4, 1.8, 1.1
];

num_buses = 4;
num_branches = size(branch_data, 1);

% Inisialisasi Tegangan Fasa (Tegangan Flat)
V = V_slack_ph * ones(num_buses, 1);
tol = 1e-4;
max_iter = 50;
iter = 0;
converged = false;

while (~converged && iter < max_iter)
    iter = iter + 1;
    V_old = V;
    
    % A. Hitung Arus Injeksi Beban di Setiap Bus (Fasa)
    I_load = zeros(num_buses, 1);
    for b = 1:size(load_data, 1)
        b_idx = load_data(b, 1);
        S_ph = ((load_data(b, 2) + 1j * load_data(b, 3)) * 1e6) / 3;
        I_load(b_idx) = conj(S_ph / V(b_idx));
    end
    
    % B. Backward Sweep: Akumulasi Arus Cabang dari Ujung ke Pangkal
    I_branch = zeros(num_branches, 1);
    I_branch(3) = I_load(4);
    I_branch(2) = I_load(3) + I_branch(3);
    I_branch(1) = I_load(2) + I_branch(2);
    
    % C. Forward Sweep: Pembaruan Tegangan dari Pangkal ke Ujung
    V(1) = V_slack_ph;
    for br = 1:num_branches
        from_b = branch_data(br, 1);
        to_b = branch_data(br, 2);
        Z_br = branch_data(br, 3) + 1j * branch_data(br, 4);
        V(to_b) = V(from_b) - I_branch(br) * Z_br;
    end
    
    % Uji Konvergensi
    if max(abs(V - V_old)) < tol
        converged = true;
    end
end

% Tampilkan Hasil Aliran Daya
fprintf('Konvergensi Tercapai pada Iterasi ke-%d\n\n', iter);
fprintf('Bus   Tegangan (V)   Tegangan (kV LL)    Per-Unit (pu)    Sudut (deg)\n');
fprintf('--------------------------------------------------------------------\n');
for b = 1:num_buses
    V_LL_mag = abs(V(b)) * sqrt(3);
    pu_val = abs(V(b)) / V_slack_ph;
    ang_deg = angle(V(b)) * 180 / pi;
    fprintf('%2d     %8.1f          %6.2f             %6.4f         %6.2f\n', ...
            b, abs(V(b)), V_LL_mag/1e3, pu_val, ang_deg);
end

% Hitung Rugi-Rugi Teknis Daya Total
P_loss_tot_W = 0;
for br = 1:num_branches
    P_loss_tot_W = P_loss_tot_W + 3 * (abs(I_branch(br))^2) * branch_data(br, 3);
end
fprintf('\nTotal Rugi-Rugi Teknis Penyulang: %.2f kW\n', P_loss_tot_W / 1e3);
