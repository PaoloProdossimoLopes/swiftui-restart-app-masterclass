//
//  CircleGroupView.swift
//  Restart
//
//  Created by Paolo Prodossimo Lopes on 05/06/23.
//

import SwiftUI

struct CircleGroupView: View {
    let color: Color
    let opacity: Double
    
    @State private var isAnimation = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(opacity), lineWidth: 40)
                .frame(width: 260, height: 260, alignment: .center)
            
            Circle()
                .stroke(color.opacity(opacity), lineWidth: 80)
                .frame(width: 260, height: 260, alignment: .center)
        }
        .blur(radius: isAnimation ? 0 : 10)
        .opacity(isAnimation ? 1 : 0)
        .scaleEffect(isAnimation ? 1 : 0.5)
        .animation(.easeOut(duration: 0.5), value: isAnimation)
        .onAppear { isAnimation = true }
        .onDisappear { isAnimation = false }
    }
}

struct CircleGroupView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.cBlue.ignoresSafeArea(.all, edges: .all)
            
            CircleGroupView(color: .white, opacity: 0.2)
        }
    }
}
