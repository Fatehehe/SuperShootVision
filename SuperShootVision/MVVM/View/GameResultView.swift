//
//  GameResultView.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import SwiftUI

struct GameResultView: View {
    @Environment(AppModel.self) var appModel
    @Environment(\.dismissWindow) var dismissWindow
    
    var isWin: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Text(isWin ? "VICTORY!" : "GAME OVER")
                .font(.system(size: 60, weight: .black, design: .rounded))
                .foregroundColor(isWin ? .green : .red)
            
            Text(isWin ? "You successfully defended the tower from every monster!"
                 : "The tower has fallen... The kingdom is lost.")
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Button(action: {
                Task {
                    appModel.resetGame()
                    dismissWindow(id: appModel.windowGroupID)
                }
            }) {
                Text("Play Again")
                    .font(.title2)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .padding(50)
        .frame(width: 500)
    }
}
