//
//  PortalSystem.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 03/07/26.
//

import RealityKit
import Foundation

public struct PortalSystem: System {
    static let portalQuery = EntityQuery(where: .has(PortalComponent.self))
    static let towerQuery = EntityQuery(where: .has(TowerComponent.self))
    
    public init(scene: RealityKit.Scene) {}
    
    public func update(context: SceneUpdateContext) {
        let currentTime = ProcessInfo.processInfo.systemUptime
        
        guard GameStateTracker.isPlaying else {
            for entity in context.scene.performQuery(Self.portalQuery) {
                if var portalComp = entity.components[PortalComponent.self] {
                    portalComp.lastSpawnTime = currentTime
                    portalComp.spawnedCount = 0
                    entity.components.set(portalComp)
                }
            }
            return
        }
        
        var activeTower: Entity? = nil
        for tower in context.scene.performQuery(Self.towerQuery) {
            activeTower = tower
            break
        }

        for entity in context.scene.performQuery(Self.portalQuery) {
            guard var portalComp = entity.components[PortalComponent.self] else { continue }
            
            if currentTime - portalComp.lastSpawnTime >= portalComp.spawnInterval {
                print("[PortalSystem] Spawn Musuh ke-\(portalComp.spawnedCount + 1) via Timeline!")
                
                if let enemyTemplate = portalComp.enemy {
                    let spawnedEnemy = enemyTemplate.clone(recursive: true)
                    spawnedEnemy.name = "GoblinEnemy"
                                    
                    let centerPosition = entity.position(relativeTo: nil)
                                                        
                    if let parent = entity.parent {
                        parent.addChild(spawnedEnemy)
                    }
                                    
                    spawnedEnemy.setPosition(centerPosition, relativeTo: nil)
                                    
                    let rotationAngle: Float = .pi / 2
                    let rotationAxis = SIMD3<Float>(0, 1, 0)
                    let rotation = simd_quatf(angle: rotationAngle, axis: rotationAxis)
                    spawnedEnemy.transform.rotation = spawnedEnemy.transform.rotation * rotation

                    if let towerEntity = activeTower {
                        var enemyComp = EnemyComponent()
                        enemyComp.targetTowerPosition = towerEntity.position(relativeTo: nil)
                        spawnedEnemy.components.set(enemyComp)
                    }
                    
                    if let parent = entity.parent {
                        parent.addChild(spawnedEnemy)
                    }
                }
                
                portalComp.spawnedCount += 1
                portalComp.lastSpawnTime = currentTime
                
                portalComp.spawnInterval = TimeInterval.random(in: 5.0...10.0)
                entity.components.set(portalComp)
            }
        }
    }
}
