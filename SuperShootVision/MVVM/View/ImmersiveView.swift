//
//  ImmersiveView.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import SwiftUI
import RealityKit
import ILSHandTracking

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel
    @Environment(\.dismissWindow) var dismissWindow
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        RealityView { content, attachments in
            SystemRegistry.registerAllSystems()
            
            if let medievalWorld = await MedievalSceneSpawner.spawnMedievalWorld(named: "MedievalScene"){
                content.add(medievalWorld)
            }
            
            let hands = await GloveSpawner.spawnHandGlovesAsync()

            for hand in hands {
                content.add(hand)
            }
            
            let headAnchor = AnchorEntity(.head)
            if let hudEntity = attachments.entity(for: "gameplay_hud") {
                hudEntity.position = [0, 0.15, -0.6]
                headAnchor.addChild(hudEntity)
            }
            content.add(headAnchor)
            
            appModel.currentGameState = .playing
            appModel.playGame()
            dismissWindow(id: appModel.windowGroupID)
        } attachments: {
            Attachment(id: "gameplay_hud") {
                GameplayHUDView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .enemyDefeated)) { _ in
            appModel.enemiesDefeated += 1
            print("Musuh mati: \(appModel.enemiesDefeated) / \(appModel.totalEnemiesToWin)")
                    
            if appModel.enemiesDefeated >= appModel.totalEnemiesToWin {
                appModel.currentGameState = .won
            }
        }
                
        .onReceive(NotificationCenter.default.publisher(for: .towerDestroyed)) { _ in
            appModel.currentGameState = .lost
            print("Tower Hancur ditangkap oleh ImmersiveView!")
        }
        .onChange(of: appModel.currentGameState) { _, newState in
            if newState == .won || newState == .lost {
                appModel.stopGame()
                openWindow(id: appModel.windowGroupID)
            }
        }
        .task {
            do{
                try await HandTrackingService.shared.start()
            }catch{
                print("ada error \(error.localizedDescription)")
            }
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
