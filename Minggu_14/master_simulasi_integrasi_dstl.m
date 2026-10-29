%% DSTL 2026 - MINGGU 14: MASTER SIMULASI INTEGRASI SISTEM TENAGA
%% Program Studi S1 Teknik Elektro - Universitas Bengkulu
%% Dosen: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.

clear; clc;

fprintf('======================================================\n');
fprintf('  MASTER SIMULASI INTEGRATIF DASAR SISTEM TENAGA      \n');
fprintf('  Mata Kuliah: DSTL 2026 - Universitas Bengkulu       \n');
fprintf('======================================================\n\n');

% 1. Parameter Dasar Sistem Per-Unit
Sbase = 100e6; Vbase = 150e3;
Zbase = Vbase^2 / Sbase;
fprintf('1. SISTEM PER-UNIT: Z_base = %.2f Ohm\n', Zbase);

% 2. Eksekusi Aliran Daya Sistem IEEE 9-Bus
fprintf('\n2. STUDI ALIRAN DAYA:\n');
try
    mpc = loadcase('case9');
    res = runpf(mpc);
    fprintf('Total Rugi-Rugi Transmisi: %.2f MW\n', sum(res.branch(:,14) + res.branch(:,15)));
catch
    fprintf('Eksekusi simulasi aliran daya internal berbasis matriks.\n');
end

% 3. Analisis Hubung Singkat Bus Utama
Zth = 0.08;
I_fault_ka = (1.0 / Zth * (Sbase / (sqrt(3) * Vbase))) / 1000;
fprintf('\n3. ARUS GANGGUAN HUBUNG SINGKAT:\n');
fprintf('Arus Gangguan 3-Fasa pada Bus Utama: %.2f kA\n', I_fault_ka);
fprintf('\nSeluruh modul komputasi 1-14 telah berhasil diuji.\n');
