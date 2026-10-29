% =========================================================================
% CONTOH KODE DARI SLIDE MINGGU 2: Analisis Rangkaian AC Tiga Fasa
% =========================================================================

% 1. Perhitungan Daya Tiga Fasa dengan Bilangan Kompleks
V_magnitude = 230; % Volt (line voltage)
theta = [0, -120, 120] * pi/180; % rad

% Tegangan fasa (Y connection)
Vf = V_magnitude / sqrt(3);
Va = Vf * exp(1j * theta(1));
Vb = Vf * exp(1j * theta(2));
Vc = Vf * exp(1j * theta(3));

% Arus dengan impedansi beban
Z_load = 10 + 5j; % ohm
Ia = Va / Z_load;
Ib = Vb / Z_load;
Ic = Vc / Z_load;

% Daya per fasa
S_phase = [Va * conj(Ia), Vb * conj(Ib), Vc * conj(Ic)];

% Total daya tiga fasa
S_total = sum(S_phase);
P_total = real(S_total); % Daya aktif (W)
Q_total = imag(S_total); % Daya reaktif (VAR)
S_magnitude = abs(S_total); % Daya semu (VA)

% Faktor daya
PF = P_total / S_magnitude;
fprintf('=== Hasil Perhitungan Daya ===\n');
fprintf('Daya Aktif Total   : %.2f W\n', P_total);
fprintf('Daya Reaktif Total : %.2f VAR\n', Q_total);
fprintf('Daya Semu Total    : %.2f VA\n', S_magnitude);
fprintf('Faktor Daya        : %.4f\n\n', PF);

% 2. Implementasi Contoh Soal (Slide 19)
P_motor = 50e3;     % 50 kW
V_motor = 380;      % 380 V
PF_motor = 0.8;     % lagging

S_base = 100e3;     % 100 kVA
V_base = 380;       % 380 V

% Perhitungan Daya Motor
S_motor_VA = P_motor / PF_motor;
Q_motor_VAR = S_motor_VA * sin(acos(PF_motor));
I_motor_A = S_motor_VA / (sqrt(3) * V_motor);

% Konversi ke pu
S_pu = (P_motor + 1j*Q_motor_VAR) / S_base;
fprintf('=== Konversi Per-Unit Motor ===\n');
fprintf('S_motor (pu) : %.3f + j%.3f pu\n', real(S_pu), imag(S_pu));
fprintf('|S_motor| (pu): %.3f pu\n', abs(S_pu));
