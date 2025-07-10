import SwiftUI

struct LoadingScreen: View {
    @AppStorage("userName") private var userName: String = ""
    @State private var showSplash = true
    @State private var size: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    
    @State private var showReveal = false
    @State private var circleScale: CGFloat = 0.01
    
    var onFinish: () -> Void
    
    var body: some View {
        ZStack {
            if showReveal {
                ZStack {
                    if userName.isEmpty {
                        OnboardingView()
                    } else {
                        HomeView(userName: userName)
                    }
                }
                .mask(
                    Circle()
                        .frame(width: 100, height: 100)
                        .scaleEffect(circleScale)
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                )
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        circleScale = 12.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        onFinish()
                    }
                }
            }

            if showSplash {
                ZStack(alignment: .bottom) {
                    Color.green.ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                        
                        VStack {
                            Image("gator")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 120)
                            
                            Text("Welcome to Gator")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        .scaleEffect(size)
                        .opacity(opacity)
                        
                        Spacer()
                        
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 60)
                    }
                    
                    Text("Made by Kelompok MIC")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.bottom, 16)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        size = 0.9
                        opacity = 1.0
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation(.easeOut(duration: 0.5)) {
                            showSplash = false
                            showReveal = true
                        }
                    }
                }
            }
        }
    }
}
