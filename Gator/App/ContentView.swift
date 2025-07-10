import SwiftUI

struct ContentView: View {
    @AppStorage("userName") private var userName: String = ""
    @State private var showLoading = true
    
    var body: some View {
        Group {
            if showLoading {
                LoadingScreen {
                    withAnimation {
                        showLoading = false
                    }
                }
            } else {
                if userName.isEmpty {
                    OnboardingView()
                } else {
                    HomeView(userName: userName)
                }
            }
        }
    }
}
