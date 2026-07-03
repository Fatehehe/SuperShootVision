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
            
        if let rightModel = await loadAsset(named: "RightGlove") {
            rightHand.components.set(HandVisualizationComponent(chirality: .right))
            rightHand.addChild(rightModel)
        }
        
        if let gunModel = await loadAsset(named: "Gun") {
            gunModel.name = "RightGun"
            gunModel.components.set(WeaponComponent(chirality: .right))
            let angleX: Float = .pi / 2
            let angleZ: Float = .pi
      
            let rotationX = simd_quatf(angle: angleX, axis: SIMD3<Float>(1, 0, 0))
            let rotationZ = simd_quatf(angle: angleZ, axis: SIMD3<Float>(0, 0, 1))

            let gunOffsetX: Float = -0.07
            let gunOffsetY: Float = -0.03
            let gunOffsetZ: Float = 0.035
            gunModel.transform.translation = SIMD3<Float>(gunOffsetX, gunOffsetY, gunOffsetZ)
    
            gunModel.transform.rotation = rotationZ * rotationX
            if let nozzlePoint = gunModel.findEntity(named: "SpawnerPoint") {
                let nozzleComp = NozzleComponent()
                nozzlePoint.components.set(nozzleComp)
//                gunModel.addChild(nozzlePoint)
            }
            
            rightHand.addChild(gunModel)
        }
        
        if let leftModel = await loadAsset(named: "LeftGlove") {
            leftHand.components.set(HandVisualizationComponent(chirality: .left))
            leftHand.addChild(leftModel)
        }
        
        return [rightHand, leftHand]
    }
    
    public static func loadAsset(named name: String) async -> Entity? {
        do {
            let asset = try await Entity(named: name, in: realityKitContentBundle)
            return asset
        } catch {
            print("[GloveSpawner] Failed to load asset \(name): \(error)")
        }
        return nil
    }
}
