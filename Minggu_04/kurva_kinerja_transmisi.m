%% DSTL 2026 - MINGGU 04: PROFIL JATUH TEGANGAN VS PANJANG SALURAN
% Dosen: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

% Parameter per-km SUTT 150 kV
r = 0.085;     % Ohm/km
x = 0.314;     % Ohm/km
b = 3.5e-6;    % S/km
f = 50;

% Vektor Variasi Jarak Saluran (20 km s.d. 220 km)
dist_vec = 20:20:220;
VR_array = zeros(size(dist_vec));
Eff_array = zeros(size(dist_vec));

V_R_LL = 150e3;
V_R_LN = V_R_LL / sqrt(3);
P_load = 80e6; % 80 MW pada pf = 0.90 lagging
pf = 0.90;
S_load = P_load / pf;
I_R_mag = S_load / (sqrt(3) * V_R_LL);
th_R = -acos(pf);
I_R = I_R_mag * (cos(th_R) + 1j * sin(th_R));

fprintf('Jarak(km)   Vs(kV)    Is(A)    %%VR(%%)    Eff(%%)   Model Dipakai\n');
fprintf('--------------------------------------------------------------\n');

for k = 1:length(dist_vec)
    L_cur = dist_vec(k);
    Z_cur = (r + 1j * x) * L_cur;
    Y_cur = (1j * b) * L_cur;
    
    if L_cur < 80
        % Model Saluran Pendek
        A = 1; B = Z_cur; C = 0; D = 1;
        tipe_model = 'Pendek';
    else
        % Model Nominal-PI
        A = 1 + (Z_cur * Y_cur)/2;
        B = Z_cur;
        C = Y_cur * (1 + (Z_cur * Y_cur)/4);
        D = A;
        tipe_model = 'Nominal-PI';
    end
    
    Vs_ln = A * V_R_LN + B * I_R;
    Is = C * V_R_LN + D * I_R;
    
    VR = ((abs(Vs_ln)/abs(A) - V_R_LN) / V_R_LN) * 100;
    Ps = 3 * real(Vs_ln * conj(Is));
    eff = (P_load / Ps) * 100;
    
    VR_array(k) = VR;
    Eff_array(k) = eff;
    
    fprintf('%5.0f      %6.2f    %5.1f    %6.2f    %5.2f    %s\n', ...
            L_cur, (abs(Vs_ln)*sqrt(3))/1e3, abs(Is), VR, eff, tipe_model);
end
