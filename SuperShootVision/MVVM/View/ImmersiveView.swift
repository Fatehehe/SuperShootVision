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
    
    var body: some View {
        RealityView { content, attachments in
            SystemRegistry.registerAllSystems()
            
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
            dismissWindow(id: appModel.windowGroupID)
        } attachments: {
            Attachment(id: "gameplay_hud") {
                GameplayHUDView()
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
