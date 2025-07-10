import SwiftUI

struct WelcomeCardView: View {
    let nama: String

    var body: some View {
        NavigationLink(destination: EditNameView()) {
            HStack(spacing: 16) {
                Image(systemName: "person.fill").font(.title).foregroundColor(.green)
                VStack(alignment: .leading) {
                    (Text("Hi, ") + Text(nama).fontWeight(.bold))
                    Text("Selamat datang di IT Del Grade Calculator")
                        .font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color("GreenCard"))
            .cornerRadius(12)
        }
        .buttonStyle(.plain) 
    }
}
