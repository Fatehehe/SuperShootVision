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
        VStack(spacing: 30) {
            Text("Tower Defense")
                .font(.extraLargeTitle)
                .bold()
            
            Text("Selamatkan menara dari serangan monster!")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Button(action: {
                appModel.currentGameState = .tutorial
            }) {
                Text("Start Game")
                    .font(.title2)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .padding(50)
    }
}
