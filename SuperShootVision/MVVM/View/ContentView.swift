//
//  ContentView.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(AppModel.self) var appModel
    var body: some View {
        Group {
            switch appModel.currentGameState {
            case .startScreen:
                StartScreenView()
            case .tutorial:
                TutorialView()
            case .loading:
                LoadingView()
            case .playing:
                EmptyView()
            case .won:
                GameResultView(isWin: true)
            case .lost:
                GameResultView(isWin: false)
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
