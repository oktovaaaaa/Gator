import SwiftUI
import SwiftData

// Enum untuk melacak langkah onboarding (tidak berubah)
enum OnboardingStep: Int {
    case welcome = 0
    case nameInput = 1
    case initialSetup = 2
    case completed = 3
}

struct OnboardingView: View {
    @AppStorage("onboardingStep") var currentStep: OnboardingStep = .welcome
    
    var body: some View {
        // Logika switch tetap sama, hanya isi NameStepView yang berubah
        switch currentStep {
        case .welcome:
            WelcomeStepView(currentStep: $currentStep)
        case .nameInput:
            NameStepView(currentStep: $currentStep) // View ini sekarang menggunakan desain Anda
        case .initialSetup:
            InitialSetupStepView(currentStep: $currentStep)
        case .completed:
            EmptyView()
        }
    }
}


// MARK: - Langkah 1: Layar Selamat Datang (Tidak Berubah)
private struct WelcomeStepView: View {
    @Binding var currentStep: OnboardingStep
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            VStack {
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
                Text("Selamat Datang di Gator").font(.largeTitle).fontWeight(.bold).multilineTextAlignment(.center)
            }
            VStack(alignment: .leading, spacing: 20) {
                FeatureRow(iconName: "apps.iphone.badge.plus", title: "Kurikulum Terintegrasi", subtitle: "Lihat semua mata kuliah yang telah disiapkan untuk setiap jurusan dan semester.")
                FeatureRow(iconName: "slider.horizontal.3", title: "Kelola Komponen Nilai", subtitle: "Sesuaikan bobot tugas, kuis, UTS, dan UAS untuk setiap mata kuliah.")
                FeatureRow(iconName: "chart.bar.xaxis", title: "Prediksi Grade Akurat", subtitle: "Hitung nilai minimum yang Anda butuhkan untuk mencapai target grade impian Anda.")
            }
            Spacer()
            Button(action: {
                withAnimation { currentStep = .nameInput }
            }) {
                Text("Lanjutkan").fontWeight(.semibold).foregroundColor(.white).frame(maxWidth: .infinity).padding().background(Color.blue).cornerRadius(12)
            }
        }
        .padding()
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
}

// Komponen kecil untuk baris fitur (tidak berubah)
private struct FeatureRow: View {
    let iconName: String, title: String, subtitle: String
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: iconName).font(.title).foregroundColor(.green).frame(width: 40)
            VStack(alignment: .leading) {
                Text(title).font(.headline).fontWeight(.semibold)
                Text(subtitle).font(.subheadline).foregroundColor(.secondary)
            }
        }
    }
}


// MARK: - Langkah 2: Layar Input Nama (Menggunakan Desain Anda)
private struct NameStepView: View {
    @Binding var currentStep: OnboardingStep
    @AppStorage("userName") private var userName: String = ""
    @State private var inputName: String = ""
    @State private var hasAttemptedToContinue = false
    
    // Warna hijau dari desain Anda
    let primaryGreen = Color.green
    
    var body: some View {
        ZStack {
            // Latar belakang gradien dari desain Anda
            (LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "person.crop.circle.badge.questionmark")
                    .font(.system(size: 80))
                    .foregroundColor(primaryGreen)
                
                Text("Siapa Nama Anda?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Nama ini akan digunakan untuk menyapa Anda di halaman utama.")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack {
                    TextField("Masukkan nama panggilan Anda", text: $inputName)
                        .padding()
                        .background(Color("Whitee"))
                        .cornerRadius(12)
                        .foregroundStyle(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(hasAttemptedToContinue && inputName.isEmpty ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    if hasAttemptedToContinue && inputName.isEmpty {
                        Text("Nama tidak boleh kosong")
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 4)
                    }
                }
                
                Spacer()
                
                Button(action: saveUserName) {
                    Text("Simpan & Lanjutkan")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("GreenGator"))
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
    
    func saveUserName() {
        hasAttemptedToContinue = true
        if !inputName.trimmingCharacters(in: .whitespaces).isEmpty {
            // Simpan nama
            self.userName = inputName
            // Lanjutkan ke langkah berikutnya
            withAnimation {
                currentStep = .initialSetup
            }
        }
    }
}


// MARK: - Langkah 3: Layar Pemilihan Jurusan & Semester (Tidak Berubah)
private struct InitialSetupStepView: View {
    // ... (kode untuk langkah ini tidak berubah sama sekali) ...
    @Binding var currentStep: OnboardingStep
    @Query(sort: \Jurusan.nama) private var allJurusans: [Jurusan]
    @AppStorage("selectedMajorName_v2") private var selectedMajorName: String?
    @AppStorage("selectedSemesterNumber_v2") private var selectedSemesterNumber: Int?
    @State private var localMajorName: String
    @State private var localSemesterNumber: Int = 1
    
    private var semesterOptions: [Int] {
        allJurusans.first { $0.nama == localMajorName }?.semesters.map { $0.nomor }.sorted() ?? []
    }
    
    init(currentStep: Binding<OnboardingStep>) {
        self._currentStep = currentStep
        self._localMajorName = State(initialValue: "")
    }

    var body: some View {
        VStack(spacing: 30) {
            Text("Terakhir, Pilih Jurusan & Semester Anda")
                .font(.largeTitle).fontWeight(.bold).multilineTextAlignment(.center)
            
            Picker("Program Studi", selection: $localMajorName) {
                ForEach(allJurusans) { jurusan in
                    Text(jurusan.nama).tag(jurusan.nama)
                }
            }
            .pickerStyle(.wheel)
            
            Picker("Semester", selection: $localSemesterNumber) {
                ForEach(semesterOptions, id: \.self) { number in
                    Text("Semester \(number)").tag(number)
                }
            }
            .pickerStyle(.wheel)
            .id(localMajorName)
            
            Button("Selesai & Masuk Aplikasi") {
                selectedMajorName = localMajorName
                selectedSemesterNumber = localSemesterNumber
                withAnimation {
                    currentStep = .completed
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        .padding()
        .onAppear {
            if let firstMajor = allJurusans.first {
                localMajorName = firstMajor.nama
            }
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
}
