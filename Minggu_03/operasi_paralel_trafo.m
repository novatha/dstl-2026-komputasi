%% DSTL 2026 - MINGGU 03: SIMULASI OPERASI PARALEL TRAFO
clear; clc;

% Data Dua Transformator di GI
S_rated_A = 60;  % MVA
Z_pu_own_A = 0.10;

S_rated_B = 40;  % MVA
Z_pu_own_B = 0.08;

S_base = 100;    % MVA basis sistem bersama

% Konversi ke Basis Sistem Bersama
Z_sys_A = Z_pu_own_A * (S_base / S_rated_A);
Z_sys_B = Z_pu_own_B * (S_base / S_rated_B);

% Rentang Pembebanan Gardu Induk (20 MVA s.d. 100 MVA)
S_load = 20:5:100;
S_A = S_load .* (Z_sys_B / (Z_sys_A + Z_sys_B));
S_B = S_load .* (Z_sys_A / (Z_sys_A + Z_sys_B));

% Persentase Pembebanan Masing-Masing Trafo
pct_A = (S_A / S_rated_A) * 100;
pct_B = (S_B / S_rated_B) * 100;

% Batas Aman Pembebanan
S_max_safe = min(S_rated_A * (1 + Z_sys_A/Z_sys_B), S_rated_B * (1 + Z_sys_B/Z_sys_A));

fprintf('=== EVALUASI PARALEL TRAFO GI ===\n');
fprintf('Impedansi Trafo A (Basis Sistem) : %.4f pu\n', Z_sys_A);
fprintf('Impedansi Trafo B (Basis Sistem) : %.4f pu\n', Z_sys_B);
fprintf('Kapasitas Total Aman Gardu       : %.2f MVA (dari nominal 100 MVA)\n\n', S_max_safe);

fprintf('S_Load(MVA)   S_A(MVA) [%%Load]    S_B(MVA) [%%Load]    Status\n');
for i = 1:length(S_load)
    status_str = 'NORMAL';
    if pct_A(i) > 100 || pct_B(i) > 100
        status_str = 'OVERLOAD!';
    end
    fprintf('%8.1f     %7.2f [%5.1f%%]     %7.2f [%5.1f%%]    %s\n', ...
            S_load(i), S_A(i), pct_A(i), S_B(i), pct_B(i), status_str);
end
