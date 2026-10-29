%% DSTL 2026 - MINGGU 08: PEMBENTUKAN MATRIKS YBUS SISTEM TENAGA
% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

fprintf('=====================================================\n');
fprintf('  PEMBENTUKAN MATRIKS ADMITANSI BUS (YBUS) SISTEM\n');
fprintf('=====================================================\n\n');

% Data Saluran: [dari_bus, ke_bus, R_pu, X_pu, B_sh_pu, tap_a]
% Jika tap_a = 0 atau 1, berarti saluran transmisi biasa tanpa tap off-nominal
branch_data = [
    1, 2, 0.02, 0.10, 0.04, 1.0;
    1, 3, 0.05, 0.25, 0.06, 1.0;
    2, 3, 0.04, 0.20, 0.05, 1.0;
    2, 4, 0.01, 0.08, 0.00, 0.98; % Transformator tap a=0.98
    3, 4, 0.03, 0.15, 0.02, 1.0
];

% Data Elemen Shunt Mandiri di Bus: [bus_no, G_sh_pu, B_sh_pu]
bus_shunt = [
    3, 0.0, 0.10;  % Kapasitor bank shunt 0.10 pu di Bus 3
];

num_buses = 4;
Ybus = zeros(num_buses, num_buses);

% 1. Akumulasi Admitansi Cabang
for br = 1:size(branch_data, 1)
    fb = branch_data(br, 1);
    tb = branch_data(br, 2);
    r  = branch_data(br, 3);
    x  = branch_data(br, 4);
    b_sh = branch_data(br, 5);
    a  = branch_data(br, 6);
    if a == 0, a = 1.0; end
    
    z_seri = r + 1j * x;
    y_seri = 1 / z_seri;
    
    % Elemen off-diagonal
    Ybus(fb, tb) = Ybus(fb, tb) - (y_seri / a);
    Ybus(tb, fb) = Ybus(tb, fb) - (y_seri / a);
    
    % Elemen diagonal
    Ybus(fb, fb) = Ybus(fb, fb) + (y_seri / (a^2)) + 1j * (b_sh / 2);
    Ybus(tb, tb) = Ybus(tb, tb) + y_seri + 1j * (b_sh / 2);
end

% 2. Akumulasi Shunt Lokal Bus
for s = 1:size(bus_shunt, 1)
    b_idx = bus_shunt(s, 1);
    Ybus(b_idx, b_idx) = Ybus(b_idx, b_idx) + bus_shunt(s, 2) + 1j * bus_shunt(s, 3);
end

% Tampilkan Hasil
disp('Matriks Ybus (Bagian Riil - Konduktansi G):');
disp(real(Ybus));
disp('Matriks Ybus (Bagian Imajiner - Suseptansi B):');
disp(imag(Ybus));
