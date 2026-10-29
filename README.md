# dstl-2026-komputasi
## Repositori Laboratorium Komputasi Dasar-Dasar Sistem Tenaga Listrik (DSTL)
**Program Studi S1 Teknik Elektro — Universitas Bengkulu (UNIB)**  
**Dosen Pengampu:** Ir. Novalio Daratha, S.T., M.Sc., Ph.D.  
**Semester:** Genap 2026 | **Kode MK:** TEE-214 / TTL-305

---

### 📚 Daftar Modul Komputasi Mingguan

| Minggu | Topik Praktikum Komputasi | Berkas Skrip GNU Octave (`.m`) |
| :--- | :--- | :--- |
| **Minggu 01** | Kalkulator Fasor, Daya Kompleks & Segitiga Daya | [`Minggu_01/kalkulator_daya_fasor.m`](Minggu_01/kalkulator_daya_fasor.m) |
| **Minggu 02** | Rangkaian 3-Fasa Seimbang & Sistem Per-Unit | [`Minggu_02/kalkulator_3fasa.m`](Minggu_02/kalkulator_3fasa.m) |
| **Minggu 03** | Rangkaian Ekivalen Trafo & Kurva Efisiensi | [`Minggu_03/hitung_parameter_trafo.m`](Minggu_03/hitung_parameter_trafo.m), [`plot_kurva_efisiensi.m`](Minggu_03/plot_kurva_efisiensi.m) |
| **Minggu 04** | Parameter Saluran Transmisi & Model Nominal-$\pi$ | [`Minggu_04/hitung_parameter_saluran.m`](Minggu_04/hitung_parameter_saluran.m) |
| **Minggu 05** | Simulasi Saluran Panjang & Efek Ferranti | [`Minggu_05/simulasi_efek_ferranti.m`](Minggu_05/simulasi_efek_ferranti.m) |
| **Minggu 06** | Load Duration Curve (LDC) & Analisis Pembangkit | [`Minggu_06/analisis_ldc_pembangkit.m`](Minggu_06/analisis_ldc_pembangkit.m) |
| **Minggu 07** | Drop Tegangan Feeder 20 kV & PLTS Atap | [`Minggu_07/simulasi_drop_tegangan_20kv.m`](Minggu_07/simulasi_drop_tegangan_20kv.m) |
| **Minggu 08** | Studi Aliran Daya Newton-Raphson / MATPOWER | [`Minggu_08/aliran_daya_matpower_3bus.m`](Minggu_08/aliran_daya_matpower_3bus.m) |
| **Minggu 09** | Analisis Gangguan Hubung Singkat 012 | [`Minggu_09/analisis_gangguan_hubung_singkat.m`](Minggu_09/analisis_gangguan_hubung_singkat.m) |
| **Minggu 10** | Analisis Harmonisa FFT & Standar IEEE 519 | [`Minggu_10/analisis_kualitas_daya_fft.m`](Minggu_10/analisis_kualitas_daya_fft.m) |
| **Minggu 11** | Economic Dispatch & Optimal Power Flow (OPF) | [`Minggu_11/economic_dispatch_opf.m`](Minggu_11/economic_dispatch_opf.m) |
| **Minggu 12** | Dinamika Sudut Rotor Persamaan Ayunan (Swing) | [`Minggu_12/simulasi_stabilitas_swing_equation.m`](Minggu_12/simulasi_stabilitas_swing_equation.m) |
| **Minggu 13** | Penetrasi EBT Surya, Duck Curve & Sizing BESS | [`Minggu_13/simulasi_duck_curve_smartgrid.m`](Minggu_13/simulasi_duck_curve_smartgrid.m) |
| **Minggu 14** | Master Integrasi Simulasi Sistem Tenaga Listrik | [`Minggu_14/master_simulasi_integrasi_dstl.m`](Minggu_14/master_simulasi_integrasi_dstl.m) |

---

### 💻 Petunjuk Penggunaan untuk Mahasiswa

1. **Persyaratan Perangkat Lunak:**
   * Instalasi **GNU Octave** (Versi 7.0 atau lebih baru) dapat diunduh gratis di [https://octave.org](https://octave.org).
   * (Opsional) Paket **MATPOWER** untuk analisis aliran daya skala besar: [https://matpower.org](https://matpower.org).

2. **Menjalankan Skrip:**
   * Buka aplikasi GNU Octave.
   * Arahkan *Current Directory* ke folder minggu praktikum yang dituju (misal: `Minggu_01`).
   * Ketikkan nama skrip pada *Command Window* (contoh: `kalkulator_daya_fasor`) lalu tekan `Enter`.
