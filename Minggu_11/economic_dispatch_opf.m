%% DSTL 2026 - MINGGU 11: ECONOMIC DISPATCH & OPTIMAL POWER FLOW
%% Program Studi S1 Teknik Elektro - Universitas Bengkulu
%% Dosen: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.

clear; clc;

fprintf('=== PEMBAGIAN BEBAN OPTIMAL (ECONOMIC DISPATCH) ===\n');
% Biaya Unit 1: C1 = 500 + 10*P1 + 0.008*P1^2
% Biaya Unit 2: C2 = 400 +  8*P2 + 0.010*P2^2
% Total Beban: PD = 400 MW

PD = 400;

% Lambda = (PD + beta1/(2*gamma1) + beta2/(2*gamma2)) / (1/(2*gamma1) + 1/(2*gamma2))
g1 = 0.008; b1 = 10;
g2 = 0.010; b2 = 8;

num = PD + (b1/(2*g1)) + (b2/(2*g2));
den = (1/(2*g1)) + (1/(2*g2));
lambda = num / den;

P1 = (lambda - b1) / (2*g1);
P2 = (lambda - b2) / (2*g2);

C1 = 500 + b1*P1 + g1*P1^2;
C2 = 400 + b2*P2 + g2*P2^2;
C_total_opt = C1 + C2;

% Kasus Beban Rata (200 MW + 200 MW)
C1_equal = 500 + b1*200 + g1*200^2;
C2_equal = 400 + b2*200 + g2*200^2;
C_total_equal = C1_equal + C2_equal;

hemat_jam = C_total_equal - C_total_opt;
hemat_tahun = hemat_jam * 8760;

fprintf('Incremental Cost (Lambda) : %.4f $/MWh\n', lambda);
fprintf('Daya Unit 1 (P1)           : %.2f MW\n', P1);
fprintf('Daya Unit 2 (P2)           : %.2f MW\n', P2);
fprintf('Biaya Total Operasi Optimal: %.2f $/jam\n', C_total_opt);
fprintf('Biaya Kasus Beban Rata     : %.2f $/jam\n', C_total_equal);
fprintf('Penghematan Tahunan        : $%.2f / tahun\n', hemat_tahun);
