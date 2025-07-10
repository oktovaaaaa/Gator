import SwiftUI

struct EditNameView: View {
    @AppStorage("userName") private var userName: String = ""
    @State private var inputName: String = ""

    var body: some View {
        Form {
            Section(header: Text("Ubah Nama")) {
                TextField("Nama Baru", text: $inputName)
            }

            Section {
                Button("Simpan") {
                    let trimmed = inputName.trimmingCharacters(in: .whitespaces)
                    if !trimmed.isEmpty {
                        userName = trimmed
                    }
                }
                .disabled(inputName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .navigationTitle("Edit Nama")
        .onAppear {
            inputName = userName
        }
    }
}
