//
//  EnemySystem.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 03/07/26.
//

import RealityKit
import Foundation
import simd

public struct EnemySystem: System {
    static let query = EntityQuery(where: .has(EnemyComponent.self))
    static let towerQuery = EntityQuery(where: .has(TowerComponent.self))
    
    static var lastEnemyCount: Int = -1
    
    public init(scene: RealityKit.Scene) {}
    
    public func update(context: SceneUpdateContext) {
        guard GameStateTracker.isPlaying else {
            let enemies = context.scene.performQuery(Self.query)
            if Self.lastEnemyCount != 0 {
                enemies.forEach { $0.removeFromParent() }
                Self.lastEnemyCount = 0
            }
            return
        }
        
        let currentTime = ProcessInfo.processInfo.systemUptime
        let enemies = context.scene.performQuery(Self.query)
        
        let currentEnemyCount = enemies.reduce(0) { count, _ in count + 1 }
        Self.lastEnemyCount = currentEnemyCount
        
        var activeTower: Entity? = nil
        for tower in context.scene.performQuery(Self.towerQuery) {
            activeTower = tower
            break
        }
        
        for entity in enemies {
            guard var enemyComp = entity.components[EnemyComponent.self] else { continue }
            
            let currentPos = entity.visualBounds(relativeTo: nil).center
            let distanceToTower = simd_distance(currentPos, enemyComp.targetTowerPosition)
//            print("distance: \(distanceToTower)")
            
            if distanceToTower <= 2 {
                if currentTime - enemyComp.lastDamageTime >= enemyComp.damageInterval {
                    
                    if let tower = activeTower, var towerComp = tower.components[TowerComponent.self] {
                        towerComp.hp -= enemyComp.damageAmount
                        print("Menara diserang! Sisa HP: \(towerComp.hp)")
                        
                        tower.components.set(towerComp)
                        let currentHp = towerComp.hp
                        Task { @MainActor in
                            
                            NotificationCenter.default.post(name: .towerGetHit, object: currentHp)
                        }
                        
                        if towerComp.hp <= 0 {
                            print("tower hancur!")
                            Task { @MainActor in
                                NotificationCenter.default.post(name: .towerDestroyed, object: nil)
                            }
                            context.scene.performQuery(Self.query).forEach { $0.removeFromParent() }
                            return
                        }
                    }
                    
                    enemyComp.lastDamageTime = currentTime
                    entity.components.set(enemyComp)
                }
            }
        }
    }
}
