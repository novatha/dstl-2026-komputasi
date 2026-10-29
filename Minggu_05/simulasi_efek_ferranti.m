%% DSTL 2026 - MINGGU 05: SALURAN PANJANG & EFEK FERRANTI
%% Program Studi S1 Teknik Elektro - Universitas Bengkulu
%% Dosen: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.

clear; clc; close all;

fprintf('=== SIMULASI EFEK FERRANTI PADA SALURAN SUTET 500 kV ===\n');
L_total = 400;             % Panjang 400 km
z = 0.03 + 1j*0.35;        % Ohm/km
y = 1j * 4.2e-6;           % Siemens/km

gamma = sqrt(z * y);
Zc = sqrt(z / y);
beta = imag(gamma);

VS_LL = 500e3;             % 500 kV
VS_LN = VS_LL / sqrt(3);

% Profil Tegangan Tanpa Beban
x = 0:10:L_total;
Vx = zeros(size(x));

for i = 1:length(x)
    dist = L_total - x(i);
    Vx(i) = abs(VS_LN * (cosh(gamma * dist) / cosh(gamma * L_total))) * sqrt(3) / 1e3;
end

fprintf('Tegangan Pangkal (x = 0 km)   : %.2f kV\n', Vx(1));
fprintf('Tegangan Ujung   (x = 400 km) : %.2f kV (Kenaikan Ferranti)\n', Vx(end));

% Kompensasi Reaktor Shunt
VR_LN = (Vx(end)*1e3) / sqrt(3);
C_param = abs(imag(sinh(gamma * L_total) / Zc));
I_charging = C_param * VR_LN;
Q_reactor = sqrt(3) * (Vx(end)*1e3) * I_charging / 1e6;
fprintf('Kapasitas Reaktor Shunt Dibutuhkan: %.2f MVAR\n', Q_reactor);

figure('Name', 'Profil Efek Ferranti', 'NumberTitle', 'off');
plot(x, Vx, 'b-o', 'LineWidth', 2); grid on;
xlabel('Jarak Saluran (km)'); ylabel('Tegangan (kV)');
title('Profil Tegangan Sepanjang Saluran 500 kV Tanpa Beban');
