//
//  SceneSpawner.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import RealityKit
import RealityKitContent

public struct MedievalSceneSpawner {
    public static func spawnMedievalWorld(named sceneName: String = "MedievalScene") async -> Entity? {
        do {
            let rootWorld = try await Entity(named: sceneName, in: realityKitContentBundle)
            rootWorld.position = SIMD3<Float>(12, 0, -2)
            
            print("[MedievalSceneSpawner] Sukses memuat dunia: \(sceneName)")
            
            if let targetBullsEye = rootWorld.findEntity(named: "Tower") {
                print("ada tower")
//                var towerData = TowerComponent()
//                towerData.hp = 100
//                targetBullsEye.components.set(towerData)
            }else{
                print("no tower")
            }
            
            if let targetBullsEye = rootWorld.findEntity(named: "BlackHole") {
                print("ada blackhole")
//                var towerData = TowerComponent()
//                towerData.hp = 100
//                targetBullsEye.components.set(towerData)
            }else{
                print("no blackhole")
            }
            
            return rootWorld
            
        } catch {
            print("[MedievalSceneSpawner] Gagal memuat scene '\(sceneName)': \(error)")
            return nil
        }
    }
}
