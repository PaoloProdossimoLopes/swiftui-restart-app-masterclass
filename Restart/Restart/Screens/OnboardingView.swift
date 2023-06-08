import SwiftUI

struct OnboardingView: View {
    
    @AppStorage(StorageKey.onboarding.key) private var isOnboardingViewActive = true
    @State private var buttonWidth: Double = {
        let paddingPerSide = 40.0
        let paddingWidth = 2.0 * paddingPerSide
        let screenWidth = Double(UIScreen.main.bounds.width)
        return screenWidth - paddingWidth
    }()
    @State private var buttonOffset = CGFloat(0)
    @State private var isAnimation = false
    @State private var imageOffset: CGSize = .zero
    @State private var indicatorOpacity: Double = 1
    @State private var textTile = "Share."
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    enum Constant {
        static let description = """
        It's not how much we give but
        how much love we put into giving.
        """
        static let caption = "Getting Started"
    }
    
    var body: some View {
        ZStack {
            Color.cBlue.ignoresSafeArea(.all, edges: .all)
            
            VStack(spacing: 20) {
                Spacer()
                
                VStack {
                    Text(textTile)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .id(textTile)
                    
                    Text(Constant.description)
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                } //: Header
                .opacity(isAnimation ? 1 : 0)
                .offset(y: isAnimation ? 0 : -40)
                .animation(.easeOut(duration: 1), value: isAnimation)
                
                ZStack {
                    CircleGroupView(color: .white, opacity: 0.2)
                        .offset(x: -imageOffset.width)
                        .blur(radius: abs(imageOffset.width / 5))
                        .animation(.spring(dampingFraction: 0.6, blendDuration: 0.5), value: imageOffset)
                    
                    AppAsset.man.image
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimation ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: isAnimation)
                        .offset(x: imageOffset.width * 1.2, y: 0)
                        .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if abs(imageOffset.width) <= 150 {
                                        imageOffset = gesture.translation
                                        
                                        withAnimation(.linear(duration: 0.25)) {
                                            indicatorOpacity = 0
                                            textTile = "Give."
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    imageOffset = .zero
                                    
                                    withAnimation(.linear(duration: 0.25)) {
                                        indicatorOpacity = 1
                                        textTile = "Share."
                                    }
                                }
                        )
                        .animation(.spring(dampingFraction: 0.6, blendDuration: 0.5), value: imageOffset)
                } //: Center
                .overlay(
                    Image(systemName: "arrow.left.and.right.circle")
                        .font(.system(size: 44, weight: .ultraLight))
                        .foregroundColor(.white)
                        .offset(y: 20)
                        .opacity(isAnimation ? 1 : 0)
                        .animation(.easeOut(duration: 1).delay(1), value: isAnimation)
                        .opacity(indicatorOpacity)
                    , alignment: .bottom
                )
                
                Spacer()
                
                ZStack {
                    ZStack {
                        Capsule()
                            .fill(.white.opacity(0.2))
                        
                        Capsule()
                            .fill(.white.opacity(0.2))
                            .padding(8)
                    } //: ButtonFrameArea
                    
                    Text(Constant.caption)
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20)
                    
                    HStack {
                        Capsule()
                            .fill(Color.cRed)
                            .frame(width: buttonOffset + 80)
                        
                        Spacer()
                    } //: Bar
                    
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.cRed)
                            
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            
                            CatalogAsset.rightChevron.image
                                .font(.system(size: 24, weight: .bold))
                        } //: DragableButton
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80, alignment: .center)
                        .offset(x: buttonOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {
                                        buttonOffset = gesture.translation.width
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation(Animation.easeOut(duration: 1)) {
                                        if buttonWidth / 2 < buttonOffset {
                                            hapticFeedback.notificationOccurred(.success)
                                            playSound(sound: "chimeup", type: "mp3")
                                            buttonOffset = buttonWidth - 80
                                            isOnboardingViewActive = false
                                        } else {
                                            hapticFeedback.notificationOccurred(.warning)
                                            buttonOffset = 0
                                        }
                                    }
                                }
                        )//: Gesture
                        
                        Spacer()
                    }
                } //: Footer
                .frame(width: buttonWidth, height: 80, alignment: .center)
                .padding()
                .opacity(isAnimation ? 1 : 0)
                .offset(y: isAnimation ? 0 : 40)
                .animation(.easeOut(duration: 1), value: isAnimation)
            }
            .onAppear {
                isAnimation = true
            }
            .onDisappear {
                isAnimation = false
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func onButtonIsDragged() {
        isOnboardingViewActive = false
    }
}

struct OnboardingViewPreviews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
