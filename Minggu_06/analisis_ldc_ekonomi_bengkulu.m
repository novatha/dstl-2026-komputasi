%% DSTL 2026 - MINGGU 06: KURVA DURASI BEBAN & ECONOMIC DISPATCH
% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

% Data Profil Beban Kronologis 24 Jam Subsistem Bengkulu (MW)
jam = 1:24;
beban_MW = [95,  90,  88,  85,  92, 100, 115, 135, 150, 165, 170, 165, ...
            160, 155, 150, 145, 155, 195, 210, 205, 190, 160, 130, 110];

% 1. Metrik Beban
P_peak = max(beban_MW);
P_min = min(beban_MW);
E_total_MWh = sum(beban_MW);
P_avg = mean(beban_MW);
LF_pct = (P_avg / P_peak) * 100;

% 2. Sortir untuk Membentuk Kurva Durasi Beban (LDC)
LDC_beban = sort(beban_MW, 'descend');

fprintf('=========================================================\n');
fprintf('  ANALISIS BEBAN & KURVA DURASI BEBAN (LDC) BENGKULU\n');
fprintf('=========================================================\n\n');
fprintf('Beban Puncak Sistem (P_peak)   : %.2f MW\n', P_peak);
fprintf('Beban Minimum / Dasar (P_base) : %.2f MW\n', P_min);
fprintf('Total Energi Harian Diserap    : %.2f MWh\n', E_total_MWh);
fprintf('Daya Rata-rata (P_avg)         : %.2f MW\n', P_avg);
fprintf('Faktor Beban Sistem (LF)       : %.2f %%\n\n', LF_pct);

% 3. Alokasi Pembangkitan (Dispatch Skenario)
% PLTA Tes: 10 MW flat run-of-river
P_tes = 10 * ones(size(beban_MW));
% PLTU Teluk Sepang: Base load 95 MW
P_pltu = 95 * ones(size(beban_MW));
% PLTA Musi: Peaker memikul sisa beban
P_musi = max(0, beban_MW - P_tes - P_pltu);

E_tes = sum(P_tes);
E_pltu = sum(P_pltu);
E_musi = sum(P_musi);

fprintf('--- HASIL ALOKASI ENERGI HARIAN PEMBANGKIT ---\n');
fprintf('PLTA Tes (Run-of-River)        : %6.1f MWh (%5.2f%%)\n', E_tes, (E_tes/E_total_MWh)*100);
fprintf('PLTU Teluk Sepang (Base Load)  : %6.1f MWh (%5.2f%%)\n', E_pltu, (E_pltu/E_total_MWh)*100);
fprintf('PLTA Musi (Peaker Dinamis)     : %6.1f MWh (%5.2f%%)\n', E_musi, (E_musi/E_total_MWh)*100);

% Faktor Kapasitas Pembangkit (CF)
CF_pltu = (E_pltu / (100 * 24)) * 100;
CF_musi = (E_musi / (140 * 24)) * 100;

fprintf('Capacity Factor PLTU Sepang    : %.2f %%\n', CF_pltu);
fprintf('Capacity Factor PLTA Musi      : %.2f %%\n', CF_musi);
