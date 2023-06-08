import SwiftUI

struct HomeView: View {
    
    @AppStorage(StorageKey.onboarding.key) var isOnBoardingViewActive = false
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                CircleGroupView(color: .gray, opacity: 0.1)
                    .padding(50)
                
                AppAsset.woman.image
                    .resizable()
                    .scaledToFit()
                    .offset(y: isAnimating ? 15 : -15)
                    .animation(
                        .easeOut(duration: 2)
                        .repeatForever(),
                        value: isAnimating)
                
            }//: Header
            .padding()
            
            ZStack {
                Text("The time that leads to maestry is dependent onthe intensity of our focus")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray.opacity(0.8))
                    .font(.system(size: 22))
            }//: Center
            .padding()
            
            Spacer()
            
            ZStack {
                Button(action: {
                    withAnimation {
                        playSound(sound: "success", type: "m4a")
                        isOnBoardingViewActive = true
                    }
                }) {
                    Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                        .imageScale(.large)
                    
                    Text("Restart")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
                
            }//: Footer
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isAnimating = true
            }
        }
        .onDisappear {
            isAnimating = false
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
