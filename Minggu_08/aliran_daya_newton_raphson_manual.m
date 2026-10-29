%% DSTL 2026 - MINGGU 08: ALIRAN DAYA NEWTON-RAPHSON POLAR MANDIRI
% Dosen Pengampu: Ir. Novalio Daratha, S.T., M.Sc., Ph.D.
% Jurusan Teknik Elektro - Universitas Bengkulu
clear; clc;

fprintf('=========================================================\n');
fprintf('  SIMULASI ALIRAN DAYA NEWTON-RAPHSON 3-BUS (POLAR)\n');
fprintf('=========================================================\n\n');

% 1. Matriks Admitansi Ybus Sistem 3-Bus
% Bus 1: Slack (|V1|=1.05 pu, delta1=0)
% Bus 2: PV (Pg2=0.5 pu, |V2|=1.02 pu, Qmin=-0.5, Qmax=1.0)
% Bus 3: PQ (Pd3=1.2 pu, Qd3=0.6 pu)
Ybus = [
     3.1889 - 15.9445j, -1.9231 +  9.6154j, -1.2658 +  6.3291j;
    -1.9231 +  9.6154j,  3.6354 - 17.8346j, -1.7123 +  8.2192j;
    -1.2658 +  6.3291j, -1.7123 +  8.2192j,  2.9781 - 14.5483j
];
G = real(Ybus);
B = imag(Ybus);
N = 3;

% Spesifikasi Nilai Terjadwal (Scheduled / Specified)
P_spec = [NaN; 0.50; -1.20];  % Bus 1 NaN (slack)
Q_spec = [NaN; NaN;  -0.60];  % Bus 1 & 2 NaN

% Inisialisasi Tegangan (Flat Start)
V = [1.05; 1.02; 1.00];
delta = [0.0; 0.0; 0.0]; % radian

tol = 1e-5;
max_iter = 10;
converged = false;

for iter = 1:max_iter
    % A. Hitung P_calc dan Q_calc
    P_calc = zeros(N, 1);
    Q_calc = zeros(N, 1);
    for i = 1:N
        for k = 1:N
            d_ik = delta(i) - delta(k);
            P_calc(i) = P_calc(i) + V(i)*V(k)*(G(i,k)*cos(d_ik) + B(i,k)*sin(d_ik));
            Q_calc(i) = Q_calc(i) + V(i)*V(k)*(G(i,k)*sin(d_ik) - B(i,k)*cos(d_ik));
        end
    end
    
    % B. Vektor Residu Mismatch
    % Variabel tak diketahui: [delta2, delta3, V3] -> urutan mismatch: [dP2, dP3, dQ3]
    dP2 = P_spec(2) - P_calc(2);
    dP3 = P_spec(3) - P_calc(3);
    dQ3 = Q_spec(3) - Q_calc(3);
    mismatch = [dP2; dP3; dQ3];
    
    if max(abs(mismatch)) < tol
        converged = true;
        break;
    end
    
    % C. Pembentukan Matriks Jacobian 3x3 Analitis
    % Baris 1: dP2/dd2, dP2/dd3, dP2/dV3
    % Baris 2: dP3/dd2, dP3/dd3, dP3/dV3
    % Baris 3: dQ3/dd2, dQ3/dd3, dQ3/dV3
    J = zeros(3, 3);
    
    % Baris 1 (dP2)
    J(1,1) = -Q_calc(2) - (V(2)^2)*B(2,2); % dP2/dd2
    J(1,2) = V(2)*V(3)*(G(2,3)*sin(delta(2)-delta(3)) - B(2,3)*cos(delta(2)-delta(3))); % dP2/dd3
    J(1,3) = V(2)*(G(2,3)*cos(delta(2)-delta(3)) + B(2,3)*sin(delta(2)-delta(3))); % dP2/dV3
    
    % Baris 2 (dP3)
    J(2,1) = V(3)*V(2)*(G(3,2)*sin(delta(3)-delta(2)) - B(3,2)*cos(delta(3)-delta(2))); % dP3/dd2
    J(2,2) = -Q_calc(3) - (V(3)^2)*B(3,3); % dP3/dd3
    J(2,3) = (P_calc(3)/V(3)) + V(3)*G(3,3); % dP3/dV3
    
    % Baris 3 (dQ3)
    J(3,1) = -V(3)*V(2)*(G(3,2)*cos(delta(3)-delta(2)) + B(3,2)*sin(delta(3)-delta(2))); % dQ3/dd2
    J(3,2) = P_calc(3) - (V(3)^2)*G(3,3); % dQ3/dd3
    J(3,3) = (Q_calc(3)/V(3)) - V(3)*B(3,3); % dQ3/dV3
    
    % D. Pemecahan Linier: dx = J \ mismatch
    dx = J \ mismatch;
    
    % E. Pembaruan Variabel Keadaan
    delta(2) = delta(2) + dx(1);
    delta(3) = delta(3) + dx(2);
    V(3)     = V(3)     + dx(3);
    
    fprintf('Iterasi %d: Maks Residu = %.2e\n', iter, max(abs(mismatch)));
end

fprintf('\nKonvergensi Tercapai pada Iterasi ke-%d!\n', iter);
fprintf('Hasil Profil Tegangan Bus:\n');
fprintf('Bus   Magnitudo (pu)    Sudut Fasa (deg)\n');
fprintf('-----------------------------------------\n');
for b = 1:N
    fprintf('%2d       %6.4f           %6.2f\n', b, V(b), delta(b)*180/pi);
end
