function plot_kurva_efisiensi(S_rating_VA, P_core, P_cu_full_load, PF)
    % PLOT KURVA EFISIENSI TRANSFORMATOR (Solusi Soal C6 - Minggu 3)
    % Input:
    % S_rating_VA      : Rating daya transformator dalam VA
    % P_core           : Rugi inti (histeresis + eddy current) konstan dalam Watt
    % P_cu_full_load   : Rugi tembaga pada beban penuh (100%) dalam Watt
    % PF               : Faktor Daya beban (contoh: 0.8)
    
    % Vektor beban dari 0% hingga 125% (0 sampai 1.25)
    beban = 0:0.05:1.25; 
    
    % Perhitungan Efisiensi
    % P_out = beban * S_rating * PF
    P_out = beban * S_rating_VA * PF;
    % Rugi tembaga bervariasi dengan kuadrat beban: P_cu = beban^2 * P_cu_full_load
    P_cu_actual = (beban.^2) * P_cu_full_load;
    
    % Total rugi-rugi
    P_loss_total = P_core + P_cu_actual;
    
    % Efisiensi dalam persen
    % Jika beban = 0, P_out = 0, efisiensi = 0 (dihandle agar tidak NaN/Inf)
    efisiensi = zeros(1, length(beban));
    for i = 1:length(beban)
        if beban(i) == 0
            efisiensi(i) = 0;
        else
            efisiensi(i) = (P_out(i) / (P_out(i) + P_loss_total(i))) * 100;
        end
    end
    
    % Mencari efisiensi maksimum
    [max_eff, max_idx] = max(efisiensi);
    beban_max_eff = beban(max_idx);
    
    % Menampilkan hasil analitik
    fprintf('=== HASIL ANALISIS EFISIENSI ===\n');
    fprintf('Efisiensi Maksimum : %.2f %%\n', max_eff);
    fprintf('Tercapai pada beban: %.0f %%\n', beban_max_eff * 100);
    
    % Secara teoritis, efisiensi maksimum terjadi saat P_core = P_cu_actual
    % x_opt = sqrt(P_core / P_cu_full_load)
    x_opt = sqrt(P_core / P_cu_full_load);
    fprintf('Beban max eff (Teoritis): %.2f %%\n', x_opt * 100);
    
    % Plot Kurva
    figure;
    plot(beban * 100, efisiensi, 'b-', 'LineWidth', 2);
    hold on;
    plot(beban_max_eff * 100, max_eff, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    grid on;
    title('Kurva Efisiensi Transformator');
    xlabel('Persentase Beban (%)');
    ylabel('Efisiensi (%)');
    legend('Kurva Efisiensi', 'Efisiensi Maksimum', 'Location', 'SouthEast');
end

% Contoh eksekusi (data dari Soal 3.3):
% S = 100 kVA, Pcore = 800 W, Pcu_fl = 1200 W, PF = 0.8
% Hapus komentar di bawah ini untuk menguji secara mandiri
% plot_kurva_efisiensi(100e3, 800, 1200, 0.8);
