import SwiftUI
import SwiftData

struct KalkulatorNilaiView: View {
    // ... (properti @Environment dan @Bindable Anda tetap sama) ...
    @Environment(\.modelContext) private var modelContext
    @Bindable var mataKuliah: MataKuliah
    
    // State yang sudah ada
    @State private var selectedGrade: String = "Pilih Grade"
    @State private var skorMinimumDiperlukan: [String: String] = [:]
    @State private var summaryText: String = "Silakan pilih target grade untuk memulai kalkulasi."
    
    // 1. TAMBAHKAN STATE BARU UNTUK POP-UP
    @State private var isInfoSheetPresented = false

    // Properti lainnya tetap sama
    static let gradeThresholds: [String: Double] = ["A": 79.5, "AB": 72, "B": 64.5, "BC": 57, "C": 49.5, "D": 34, "E": 0]
    static let gradeOptions = ["Pilih Grade", "A", "AB", "B", "BC", "C", "D", "E"]
    private var sortedKomponen: [KomponenNilai] { mataKuliah.komponen.sorted { $0.nama < $1.nama } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text(mataKuliah.nama)
                    .font(.largeTitle).fontWeight(.bold)
                
                HStack {
                    Text("Predict Grade").fontWeight(.medium)
                    Spacer()
                    Picker("Grade", selection: $selectedGrade) {
                        ForEach(Self.gradeOptions, id: \.self) { grade in
                            Text(grade)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .padding(.bottom, 10)
                
                ForEach(sortedKomponen) { komponen in
                    KalkulatorInputRow(
                        namaKomponen: komponen.nama,
                        persentase: komponen.bobot,
                        nilaiAktual: bindingFor(komponen),
                        skorMinimumTampil: skorMinimumDiperlukan[komponen.nama] ?? "-"
                    )
                    Divider()
                }
                
                if !summaryText.isEmpty {
                    Text(summaryText)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                }
            }
            .padding()
        }
        .navigationTitle("Kalkulasi Nilai")
        .navigationBarTitleDisplayMode(.inline)
        
        // 2. TAMBAHKAN TOOLBAR UNTUK TOMBOL INFO
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isInfoSheetPresented = true // Tampilkan sheet saat tombol ditekan
                }) {
                    Image(systemName: "info.circle")
                }
            }
        }
        // 3. TAMBAHKAN MODIFIER .sheet
        .sheet(isPresented: $isInfoSheetPresented) {
            InfoPopupView() // Tampilkan InfoPopupView di sini
        }
        
        .onChange(of: selectedGrade) { _ in calculateMinimumScores() }
        .onAppear { calculateMinimumScores() }
        .onDisappear { try? modelContext.save() }
    }

    // ... (semua fungsi private Anda tidak berubah) ...
    private func bindingFor(_ komponen: KomponenNilai) -> Binding<String> {
            Binding<String>(
                get: {
                    if let nilai = komponen.nilaiAktual {
                        return floor(nilai) == nilai ?
                            String(format: "%.0f", nilai) :
                            String(format: "%.1f", nilai)
                    }
                    return ""
                },
                set: { newValue in
                    let sanitized = newValue.replacingOccurrences(of: ",", with: ".")
                    if sanitized.isEmpty {
                        komponen.nilaiAktual = nil
                    } else if let doubleValue = Double(sanitized) {
                        komponen.nilaiAktual = doubleValue
                    }
                    calculateMinimumScores()
                }
            )
        }

        private func calculateMinimumScores() {
            guard selectedGrade != "Pilih Grade",
                  let targetTotalScore = Self.gradeThresholds[selectedGrade] else {
                resetCalculations()
                return
            }

            var nilaiTertimbang: Double = 0
            var totalBobotTerisi: Double = 0
            
            for komponen in mataKuliah.komponen {
                if let nilai = komponen.nilaiAktual {
                    nilaiTertimbang += (nilai * komponen.bobot) / 100.0
                    totalBobotTerisi += komponen.bobot
                }
            }
            
            let totalBobot = mataKuliah.komponen.reduce(0.0) { $0 + $1.bobot }
            let bobotKosong = totalBobot - totalBobotTerisi

            if bobotKosong == 0 {
                let nilaiAkhir = nilaiTertimbang
                var grade = "E"
                for (g, threshold) in Self.gradeThresholds.sorted(by: { $0.value > $1.value }) {
                    if nilaiAkhir >= threshold {
                        grade = g
                        break
                    }
                }
                let nilaiFormatted = String(format: "%.2f", nilaiAkhir)
                summaryText = "Nilai akhir kamu adalah \(nilaiFormatted) dengan grade \(grade)."
                resetSkorMinimumDisplay()
                return
            }

            let sisaNilai = targetTotalScore - nilaiTertimbang
            let skorMinimum = (sisaNilai / bobotKosong) * 100.0

            let displayValue: String
            if sisaNilai <= 0 {
                displayValue = "✅"
            } else if skorMinimum > 100 || skorMinimum.isNaN {
                displayValue = "❗️"
            } else {
                displayValue = String(format: "%.1f", skorMinimum)
            }

            var temp = [String: String]()
            for komponen in mataKuliah.komponen {
                temp[komponen.nama] = komponen.nilaiAktual == nil ? displayValue : "-"
            }
            skorMinimumDiperlukan = temp
            summaryText = "Untuk mencapai grade \(selectedGrade), kamu butuh nilai rata-rata \(displayValue) pada komponen sisa."
        }

        private func resetCalculations() {
            summaryText = "Silakan pilih target grade untuk memulai kalkulasi."
            resetSkorMinimumDisplay()
        }

        private func resetSkorMinimumDisplay() {
            skorMinimumDiperlukan = Dictionary(uniqueKeysWithValues:
                mataKuliah.komponen.map { ($0.nama, "-") }
            )
        }

}

// MARK: - View untuk Konten Pop-up Info
private struct InfoPopupView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Cara Penggunaan")) {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Pilih *Target Grade* yang Anda inginkan di menu drop-down.", systemImage: "1.circle.fill")
                        Label("Isi kolom *Nilai Aktual* untuk komponen yang nilainya sudah keluar.", systemImage: "2.circle.fill")
                        Label("Kolom *Skor Minimum* akan otomatis menunjukkan nilai rata-rata yang Anda butuhkan.", systemImage: "3.circle.fill")
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Keterangan Skor")) {
                    Label("Menunjukkan skor rata-rata yang Anda butuhkan.", systemImage: "numbers")
                    Label("Selamat! Target nilai sudah tercapai.", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Label("Target tidak mungkin tercapai (skor > 100).", systemImage: "xmark.circle.fill")
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle("Petunjuk Penggunaan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Tutup") {
                        dismiss()
                    }
                }
            }
        }
    }
}
