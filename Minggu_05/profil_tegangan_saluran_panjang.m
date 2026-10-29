%% DSTL 2026 - MINGGU 05: DISTRIBUSI TEGANGAN & ARUS SPASIAL
% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

fprintf('=========================================================\n');
fprintf('  SIMULASI DISTRIBUSI SPASIAL SALURAN TRANSMISI PANJANG\n');
fprintf('=========================================================\n\n');

% 1. Parameter Saluran Transmisi 500 kV
L_total_km = 350;        % Panjang total bentangan (km)
f = 50; omega = 2*pi*f;  % Frekuensi sistem (Hz)
V_R_LL = 500e3;          % Tegangan beban line-to-line (V)
V_R_ph = V_R_LL / sqrt(3); % Tegangan fasa-netral referensi

% Data kawat per km
r_km = 0.028;            % Ohm/km
l_km = 0.95e-3;          % H/km
c_km = 0.0118e-6;        % F/km
g_km = 0;                % S/km

% 2. Parameter Propagasi Gelombang
z = r_km + 1j * omega * l_km;
y = g_km + 1j * omega * c_km;
gamma = sqrt(z * y);
alpha = real(gamma);
beta = imag(gamma);
Zc = sqrt(z / y);
SIL_MW = (V_R_LL / 1e3)^2 / real(Zc);

fprintf('Impedansi Karakteristik (|Zc|) : %.2f Ohm (Sudut: %.2f deg)\n', abs(Zc), angle(Zc)*180/pi);
fprintf('Konstanta Atenuasi (alpha)     : %.5e Np/km\n', alpha);
fprintf('Konstanta Fasa (beta)          : %.5e rad/km\n', beta);
fprintf('Panjang Gelombang (lambda)     : %.1f km\n', (2*pi/beta));
fprintf('Surge Impedance Loading (SIL)  : %.2f MW\n\n', SIL_MW);

% 3. Vektor Jarak Spasial dari Beban (x = 0 di beban s.d. x = L di pengirim)
x_vec = linspace(0, L_total_km, 100);

% Tiga Kasus Beban di Ujung Penerima:
% Kasus 1: Tanpa Beban (P = 0)
I_R_case1 = 0;

% Kasus 2: Beban Alami SIL (P = SIL, pf = 1.0)
P_case2 = SIL_MW * 1e6;
I_R_mag_case2 = P_case2 / (sqrt(3) * V_R_LL);
I_R_case2 = I_R_mag_case2 * (1.0 + 0j);

% Kasus 3: Beban Berat (P = 1.6 * SIL, pf = 0.85 lagging)
P_case3 = 1.6 * SIL_MW * 1e6;
pf_case3 = 0.85;
S_case3 = P_case3 / pf_case3;
I_R_mag_case3 = S_case3 / (sqrt(3) * V_R_LL);
I_R_case3 = I_R_mag_case3 * (pf_case3 - 1j*sin(acos(pf_case3)));

% Alokasi Matriks
V_dist_case1 = zeros(size(x_vec));
V_dist_case2 = zeros(size(x_vec));
V_dist_case3 = zeros(size(x_vec));

for k = 1:length(x_vec)
    xk = x_vec(k);
    cosh_val = cosh(gamma * xk);
    sinh_val = sinh(gamma * xk);
    
    % Tegangan di setiap titik x (dalam kV LL)
    Vx1 = cosh_val * V_R_ph + Zc * sinh_val * I_R_case1;
    Vx2 = cosh_val * V_R_ph + Zc * sinh_val * I_R_case2;
    Vx3 = cosh_val * V_R_ph + Zc * sinh_val * I_R_case3;
    
    V_dist_case1(k) = (abs(Vx1) * sqrt(3)) / 1e3;
    V_dist_case2(k) = (abs(Vx2) * sqrt(3)) / 1e3;
    V_dist_case3(k) = (abs(Vx3) * sqrt(3)) / 1e3;
end

% Cetak Hasil Terminal
fprintf('--- EVALUASI TEGANGAN PADA UJUNG PENGIRIM (x = %d km) ---\n', L_total_km);
fprintf('Kasus 1 (Tanpa Beban)  : Vs = %.2f kV (Efek Ferranti: +%.2f%%)\n', ...
        V_dist_case1(end), ((V_dist_case1(end) - 500)/500)*100);
fprintf('Kasus 2 (Beban SIL)    : Vs = %.2f kV (Profil Mendekati Datar)\n', V_dist_case2(end));
fprintf('Kasus 3 (Beban Berat)  : Vs = %.2f kV (Drop Tegangan Besar)\n', V_dist_case3(end));
