%% DSTL 2026 - MINGGU 08: ALIRAN DAYA METODE MATPOWER / NEWTON-RAPHSON
%% Program Studi S1 Teknik Elektro - Universitas Bengkulu
%% Dosen: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.

clear; clc;

fprintf('=== STUDI ALIRAN DAYA 3-BUS DENGAN MATPOWER ===\n');
mpc.version = '2';
mpc.baseMVA = 100;

% bus_i type Pd Qd Gs Bs area Vm Va baseKV zone Vmax Vmin
mpc.bus = [
    1   3   0    0    0   0   1   1.0   0   150   1   1.05  0.95;
    2   2   50   20   0   0   1   1.0   0   150   1   1.05  0.95;
    3   1   80   40   0   0   1   1.0   0   150   1   1.05  0.95;
];

% bus Pg Qg Qmax Qmin Vg mBase status Pmax Pmin
mpc.gen = [
    1   50   0   100  -50  1.0  100    1    150   0;
    2   80   0   100  -50  1.0  100    1    100   0;
];

% fbus tbus r x b rateA rateB rateC ratio angle status angmin angmax
mpc.branch = [
    1   2   0.02  0.10  0.02  100  100  100  0  0  1  -360  360;
    1   3   0.05  0.25  0.05  100  100  100  0  0  1  -360  360;
    2   3   0.03  0.15  0.03  100  100  100  0  0  1  -360  360;
];

try
    results = runpf(mpc);
    printpf(results);
catch
    fprintf('MATPOWER belum terpasang di path GNU Octave.\n');
    fprintf('Gunakan algoritma iterasi Gauss-Seidel manual untuk menghitung V2 dan V3.\n');
end
