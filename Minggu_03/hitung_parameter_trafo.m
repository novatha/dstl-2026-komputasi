% =========================================================================
% SKRIP OCTAVE: KALKULASI PARAMETER TEST TRAFO (OC & SC)
% Mata Kuliah: Dasar-Dasar Sistem Tenaga Listrik
% =========================================================================
clear; clc;

% DATA OPEN CIRCUIT TEST (Sisi Low Voltage 240V)
Voc = 240; Ioc = 4.0; Poc = 200;
% DATA SHORT CIRCUIT TEST (Sisi High Voltage 2400V)
Vsc = 120; Isc = 41.67; Psc = 1200;

% 1. PARAMETER INTI (Rc & Xm) dari OC Test
S_oc = Voc * Ioc;
pf_oc = Poc / S_oc;
Ic = Ioc * pf_oc;
Im = Ioc * sin(acos(pf_oc));
Rc = Voc / Ic;
Xm = Voc / Im;

% 2. PARAMETER LILITAN (Req & Xeq) dari SC Test
Req_hv = Psc / (Isc^2);
Zeq_hv = Vsc / Isc;
Xeq_hv = sqrt(Zeq_hv^2 - Req_hv^2);

fprintf('=== PARAMETER RANGKAIAN EKIVALEN TRAFO ===\n');
fprintf('Rc (Sisi LV)  = %.2f Ohm\n', Rc);
fprintf('Xm (Sisi LV)  = %.2f Ohm\n', Xm);
fprintf('Req (Sisi HV) = %.3f Ohm\n', Req_hv);
fprintf('Xeq (Sisi HV) = %.3f Ohm\n', Xeq_hv);
