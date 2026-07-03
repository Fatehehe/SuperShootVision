//
//  StartScreenView.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import SwiftUI

struct StartScreenView: View {
    @Environment(AppModel.self) var appModel
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "target")
                .font(.system(size: 100))
                .foregroundStyle(.red, .yellow)
                .padding(.bottom, 10)
            
            VStack(spacing: 15) {
                Text("TOWER DEFENSE")
                    .font(.system(size: 64, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .orange, .yellow],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .tracking(3)
                
                Text("Selamatkan menara dari invasi monster antar-dimensi!")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            
            Button(action: {
                withAnimation(.spring) {
                    appModel.currentGameState = .tutorial
                }
            }) {
                Label("Mulai Permainan", systemImage: "play.fill")
                    .font(.title2.weight(.bold))
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(.red)
            .padding(.top, 20)
        }
        .padding(80)
    }
}
