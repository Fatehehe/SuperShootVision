//
//  ImmersiveView.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import SwiftUI
import RealityKit
import RealityKitContent
import ILSHandTracking

struct ImmersiveView: View {

    var body: some View {
        RealityView { content in
            ILFeatureHandTrackingSetup.registerSystems()
            
            //aman
            HandVisualizationComponent.registerComponent()
            HandVisualizationSystem.registerSystem()
            
            let hands = await GloveSpawner.spawnHandGlovesAsync()

            for hand in hands {
                content.add(hand)
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
