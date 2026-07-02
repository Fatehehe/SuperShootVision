//
//  GloveSpawner.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import RealityKit
import ILSHandTracking
import RealityKitContent
import Foundation
import ARKit

public struct GloveSpawner {
    public static func spawnHandGlovesAsync() async -> [Entity] {
        let rightHand = Entity()
        rightHand.name = "RightHandAnchor"
        rightHand.components.set(ILHandTrackingComponent())
        
        let leftHand = Entity()
        leftHand.name = "LeftHandAnchor"
        leftHand.components.set(ILHandTrackingComponent())
            
        if let rightModel = await spawnGlove(named: "RightGlove") {
            rightHand.components.set(HandVisualizationComponent(chirality: .right))
            rightHand.addChild(rightModel)
        }
        
        if let leftModel = await spawnGlove(named: "LeftGlove") {
            leftHand.components.set(HandVisualizationComponent(chirality: .left))
            leftHand.addChild(leftModel)
        }
        return [rightHand, leftHand]
    }
    
    public static func spawnGlove(named name: String) async -> Entity? {
        if let url = Bundle.main.url(forResource: name, withExtension: "usdz") {
            do {
                let glove = try await Entity(contentsOf: url)
                print("Successfully to load \(name)")
                return glove
            } catch {
                print("Failed to load \(name): \(error.localizedDescription).")
            }
        } else {
            print("Glove model not found in bundle: \(name).")
        }
        return nil
    }
}
