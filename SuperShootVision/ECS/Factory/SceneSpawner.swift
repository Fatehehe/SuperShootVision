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
            
            if let tower = rootWorld.findEntity(named: "Tower") {
                var towerData = TowerComponent()
                towerData.hp = 100
                tower.components.set(towerData)
                rootWorld.addChild(tower)
            }
            
            if let portalEnemy = rootWorld.findEntity(named: "BlackHole") {
                if let portalEnemy = await spawnEnemyPortal() {
                    var portalData = PortalComponent()
                    portalData.enemy = portalEnemy
                    portalEnemy.components.set(portalData)
                    rootWorld.addChild(portalEnemy)
                }
            }
            return rootWorld
        } catch {
            print("[MedievalSceneSpawner] Gagal memuat scene '\(sceneName)': \(error)")
            return nil
        }
    }
    
    public static func spawnEnemyPortal() async -> Entity? {
        do {
            let enemy = try await Entity(named: "Goblin", in: realityKitContentBundle)
            print("[MedievalSceneSpawner] Sukses memuat enemy: \(enemy.name)")
            return enemy
        }catch{
            print("[PortalSpawner] Gagal memuat Portal dari RCP: \(error)")
            return nil
        }
    }
}
