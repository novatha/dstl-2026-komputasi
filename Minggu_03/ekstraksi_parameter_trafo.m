%% DSTL 2026 - MINGGU 03: EKSTRAKSI PARAMETER TRANSFORMATOR
% Dosen: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

fprintf('=====================================================\n');
fprintf('  PROGRAM EKSTRAKSI PARAMETER TRANSFORMATOR DAYA     \n');
fprintf('=====================================================\n\n');

% 1. Parameter Pelat Nama (Nameplate Rating)
S_nom = 100e3;        % 100 kVA
V1_nom = 20000;       % 20 kV (Sisi HV / Primer)
V2_nom = 400;         % 400 V (Sisi LV / Sekunder)
f = 50;               % 50 Hz
a = V1_nom / V2_nom;  % Rasio lilitan (50)

% 2. Data Uji Beban Nol (Open-Circuit Test) di sisi LV pada T1 = 25 C
Voc = 400;   Ioc = 5.5;   Poc = 260;

% 3. Data Uji Hubung Singkat (Short-Circuit Test) di sisi HV pada T1 = 25 C
Vsc = 800;   Isc = 5.0;   Psc = 1750;
T1 = 25;     T2 = 75;     % Suhu uji dan suhu standar industri

% Perhitungan Cabang Paralel (Sisi LV)
Rc_lv = (Voc^2) / Poc;
cos_th0 = Poc / (Voc * Ioc);
th0 = acos(cos_th0);
Im_lv = Ioc * sin(th0);
Xm_lv = Voc / Im_lv;

% Refleksi Cabang Paralel ke Sisi HV
Rc_hv = (a^2) * Rc_lv;
Xm_hv = (a^2) * Xm_lv;

% Perhitungan Cabang Seri (Sisi HV pada T1)
Zeq_hv_T1 = Vsc / Isc;
Req_hv_T1 = Psc / (Isc^2);
Xeq_hv = sqrt(Zeq_hv_T1^2 - Req_hv_T1^2);

% Koreksi Temperatur Tahanan ke 75 C (Standar IEEE/SPLN)
Req_hv_T2 = Req_hv_T1 * ((234.5 + T2) / (234.5 + T1));
Zeq_hv_T2 = sqrt(Req_hv_T2^2 + Xeq_hv^2);

% Parameter Per-Unit pada Basis Trafo Sendiri
Z_base_hv = (V1_nom^2) / S_nom;
Req_pu = Req_hv_T2 / Z_base_hv;
Xeq_pu = Xeq_hv / Z_base_hv;
Zeq_pu = Zeq_hv_T2 / Z_base_hv;

% Tampilkan Hasil Cetak Konsol
fprintf('Rasio Transformasi (a)             : %.2f\n', a);
fprintf('--- Cabang Eksitasi Paralel (Acuan HV) ---\n');
fprintf('Resistansi Inti (Rc)               : %.2f kOhm\n', Rc_hv / 1e3);
fprintf('Reaktansi Pemagnetan (Xm)          : %.2f kOhm\n', Xm_hv / 1e3);
fprintf('Faktor Daya Tanpa Beban (cos th0)  : %.4f (lagging)\n\n', cos_th0);

fprintf('--- Cabang Seri Ekivalen (Acuan HV) ---\n');
fprintf('Resistansi Seri T=25 C (Req)       : %.3f Ohm\n', Req_hv_T1);
fprintf('Resistansi Seri T=75 C (Req_75)    : %.3f Ohm\n', Req_hv_T2);
fprintf('Reaktansi Bocor Seri (Xeq)         : %.3f Ohm\n', Xeq_hv);
fprintf('Tegangan Impedansi Seri (%%Zsc)    : %.2f %%\n\n', Zeq_pu * 100);
