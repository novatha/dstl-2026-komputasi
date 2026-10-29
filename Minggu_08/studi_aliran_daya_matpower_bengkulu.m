%% DSTL 2026 - MINGGU 08: ALIRAN DAYA SUBSISTEM 150 kV BENGKULU DENGAN MATPOWER
% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

fprintf('=================================================================\n');
fprintf('  STUDI ALIRAN DAYA TRANSMISI 150 kV BENGKULU (MATPOWER)\n');
fprintf('=================================================================\n\n');

mpc.version = '2';
mpc.baseMVA = 100;

% 1. Data Bus: [bus_i, type, Pd, Qd, Gs, Bs, area, Vm, Va, baseKV, zone, Vmax, Vmin]
% Tipe Bus: 1 = PQ, 2 = PV, 3 = Slack
mpc.bus = [
    1   3    0.0   0.0   0   0   1   1.03   0.0   150   1   1.05  0.95; % Bus 1: PLTA Musi (Slack)
    2   2    5.0   2.0   0   0   1   1.02   0.0   150   1   1.05  0.95; % Bus 2: PLTU Teluk Sepang (PV)
    3   1   45.0  20.0   0   0   1   1.00   0.0   150   1   1.05  0.95; % Bus 3: GI Pulau Baai (PQ)
    4   1   60.0  25.0   0   0   1   1.00   0.0   150   1   1.05  0.95; % Bus 4: GI Sukamerindu (PQ)
    5   1   35.0  15.0   0   0   1   1.00   0.0   150   1   1.05  0.95; % Bus 5: GI Pekik Nyaring (PQ)
];

% 2. Data Generator: [bus, Pg, Qg, Qmax, Qmin, Vg, mBase, status, Pmax, Pmin]
mpc.gen = [
    1   80.0    0.0   120.0  -40.0   1.03   100   1   210.0   0.0; % PLTA Musi 3x70 MW
    2  120.0    0.0   100.0  -30.0   1.02   100   1   200.0   0.0; % PLTU Teluk Sepang 2x100 MW
];

% 3. Data Cabang Transmisi: [fbus, tbus, r, x, b, rateA, rateB, rateC, ratio, angle, status]
mpc.branch = [
    1   4   0.025  0.120  0.030   150   150   150   0   0   1; % Musi - Sukamerindu
    1   5   0.030  0.150  0.035   150   150   150   0   0   1; % Musi - Pekik Nyaring
    2   3   0.010  0.045  0.015   200   200   200   0   0   1; % Teluk Sepang - Pulau Baai
    3   4   0.015  0.070  0.020   150   150   150   0   0   1; % Pulau Baai - Sukamerindu
    4   5   0.020  0.090  0.025   150   150   150   0   0   1  % Sukamerindu - Pekik Nyaring
];

% Jalankan Aliran Daya Newton-Raphson MATPOWER
opt = mpoption('verbose', 0, 'out.all', 0);
results = runpf(mpc, opt);

if results.success
    fprintf('Konvergensi Tercapai dalam %d Iterasi!\n\n', results.iterations);
    fprintf('Ringkasan Kondisi Tegangan Bus:\n');
    fprintf('Bus   Nama Gardu Induk       V (pu)    V (kV)    Sudut (deg)\n');
    fprintf('------------------------------------------------------------\n');
    bus_names = {'PLTA Musi (Slack)    ', ...
                 'PLTU Teluk Sepang (PV)', ...
                 'GI Pulau Baai (PQ)   ', ...
                 'GI Sukamerindu (PQ)  ', ...
                 'GI Pekik Nyaring (PQ)'};
    for b = 1:5
        fprintf('%2d    %s  %6.4f    %6.2f      %6.2f\n', ...
                b, bus_names{b}, results.bus(b, 8), results.bus(b, 8)*150, results.bus(b, 9));
    end
    
    P_loss_MW = sum(results.branch(:, 14) + results.branch(:, 16));
    fprintf('\nTotal Beban Sistem       : %.2f MW\n', sum(mpc.bus(:, 3)));
    fprintf('Total Pembangkitan Aktif : %.2f MW\n', sum(results.gen(:, 2)));
    fprintf('Total Rugi Transmisi     : %.2f MW\n', P_loss_MW);
else
    fprintf('Aliran daya divergen!\n');
end
