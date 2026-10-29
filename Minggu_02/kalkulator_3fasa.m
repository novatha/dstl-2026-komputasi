function kalkulator_3fasa(V_line, Z_phase_R, Z_phase_X, connection_type)
    % KALKULATOR SISTEM TIGA FASA (Solusi Soal 10 - Minggu 2)
    % Input:
    % V_line          : Tegangan saluran (Volt)
    % Z_phase_R       : Resistansi per fasa (Ohm)
    % Z_phase_X       : Reaktansi per fasa (Ohm)
    % connection_type : 'Y' atau 'Delta'
    
    Z_phase = Z_phase_R + 1j * Z_phase_X;
    
    if strcmpi(connection_type, 'Y')
        V_phase = V_line / sqrt(3);
        I_phase = V_phase / Z_phase;
        I_line = I_phase;
    elseif strcmpi(connection_type, 'Delta') || strcmpi(connection_type, 'D')
        V_phase = V_line;
        I_phase = V_phase / Z_phase;
        I_line = I_phase * sqrt(3) * exp(-1j*pi/6); % Besarannya sqrt(3) kalinya
    else
        error('Tipe koneksi tidak valid. Gunakan ''Y'' atau ''Delta''.');
    end
    
    % Perhitungan daya (menggunakan besaran fasa)
    S_phase = V_phase * conj(I_phase);
    S_total = 3 * S_phase;
    
    P_total = real(S_total);
    Q_total = imag(S_total);
    S_mag = abs(S_total);
    PF = P_total / S_mag;
    
    % Menampilkan output
    fprintf('\n--- HASIL KALKULATOR SISTEM 3 FASA (%s) ---\n', upper(connection_type));
    fprintf('Impedansi Fasa : %.2f + j%.2f Ohm (%.2f < %.2f deg)\n', ...
        Z_phase_R, Z_phase_X, abs(Z_phase), angle(Z_phase)*180/pi);
    fprintf('Arus Fasa      : %.2f A\n', abs(I_phase));
    fprintf('Arus Saluran   : %.2f A\n', abs(I_line));
    fprintf('Daya Aktif (P) : %.2f W\n', P_total);
    fprintf('Daya Reaktif(Q): %.2f VAR\n', Q_total);
    fprintf('Daya Semu (S)  : %.2f VA\n', S_mag);
    fprintf('Faktor Daya    : %.4f\n', PF);
    fprintf('-------------------------------------------\n');
end

% Contoh penggunaan dengan data dari Soal 5:
% Motor terhubung Delta, 400 V, Z = 15 + j10 ohm.
% kalkulator_3fasa(400, 15, 10, 'Delta');
