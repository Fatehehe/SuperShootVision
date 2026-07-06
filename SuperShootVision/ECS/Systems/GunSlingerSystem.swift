import RealityKit
import ILSHandTracking
import ARKit
import UIKit

public struct GunSlingerSystem: System {
    static let query = EntityQuery(where: .has(WeaponComponent.self))
    static let bulletQuery = EntityQuery(where: .has(BulletComponent.self))
    static let enemyQuery = EntityQuery(where: .has(EnemyComponent.self))
    
    nonisolated(unsafe) static var sphereTemplate: Entity?
    
    public init(scene: Scene) {}
    
    public func update(context: SceneUpdateContext) {
        gunUpdate(context: context)
        updateProjectiles(context: context)
    }
    
    public func gunUpdate(context: SceneUpdateContext) {
        let currentTime = CACurrentMediaTime()
            
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            guard var gun = entity.components[WeaponComponent.self] else { continue }
                
            let handAnchor = (gun.chirality == .right) ? HandTrackingService.shared.latestRightHand : HandTrackingService.shared.latestLeftHand
                
            guard let trackedHand = handAnchor, trackedHand.isTracked, let skeleton = trackedHand.handSkeleton else {
                continue
            }
                
            let isTriggerPose = HandPoseDetector.detect(handSkeleton: skeleton, thumb: true, index: true, mid: true, ring: true, little: true)
                
            let isNewPress = isTriggerPose && !gun.wasTriggerPose
            let isCooldownReady = (currentTime - gun.lastFireTime) >= gun.fireCooldown
                
            if isNewPress && isCooldownReady {
                if let nozzleEntity = entity.findEntity(named: "SpawnerPoint") {
                    let spawnPosition = nozzleEntity.position(relativeTo: nil)
                    let worldOrientation = nozzleEntity.orientation(relativeTo: nil)
                        
                    let localForward = SIMD3<Float>(1, 0, 0)
                    let forwardDirection = worldOrientation.act(localForward)
                        
                    let bulletSpeed: Float = 10.0
                    let velocity = forwardDirection * bulletSpeed
                        
                    launchProjectile(
                        from: spawnPosition,
                        in: nozzleEntity,
                        named: "Bullet",
                        velocity: velocity,
                        color: .red
                    )
                        
                    gun.lastFireTime = currentTime
                }
            }
            gun.wasTriggerPose = isTriggerPose
            entity.components.set(gun)
        }
    }
    
    private func launchProjectile(
        from position: SIMD3<Float>,
        in entity: Entity,
        named name: String,
        velocity: SIMD3<Float>,
        color: UIColor
    ) {
        let projectile: Entity
        if let template = Self.sphereTemplate {
            projectile = template.clone(recursive: true)
            projectile.scale = SIMD3<Float>(repeating: 0.5)
        } else {
            projectile = ModelEntity(
                mesh: .generateSphere(radius: 0.03),
                materials: [SimpleMaterial(color: color, isMetallic: true)]
            )
        }
        var rootEntity = entity
        while let parent = rootEntity.parent {
            rootEntity = parent
        }
        rootEntity.addChild(projectile)
            
        projectile.setPosition(position, relativeTo: nil)
            
        // Masukkan damage di sini
        projectile.components.set(BulletComponent(
            velocity: velocity,
            initialPosition: position,
            startTime: CACurrentMediaTime(),
            lifetime: 3.0,
            damage: 10
        ))
    }
        
    private func updateProjectiles(context: SceneUpdateContext) {
            let projectiles = context.entities(matching: Self.bulletQuery, updatingSystemWhen: .rendering)
            let enemies = context.entities(matching: Self.enemyQuery, updatingSystemWhen: .rendering)
            let currentTime = CACurrentMediaTime()

            for entity in projectiles {
                guard let comp = entity.components[BulletComponent.self] else { continue }
                let elapsed = Float(currentTime - comp.startTime)

                let lifetime = comp.lifetime
                    
                if elapsed > Float(lifetime) {
                    entity.removeFromParent()
                    continue
                }

                let gravity = SIMD3<Float>(0, -4.0, 0)
                let newPosition = comp.initialPosition
                    + comp.velocity * elapsed
                    + 0.5 * gravity * elapsed * elapsed
                    
                entity.setPosition(newPosition, relativeTo: nil)
                var hasHitEnemy = false
                let bulletRadius: Float = 0.05
                
                for enemy in enemies {
                    let bounds = enemy.visualBounds(relativeTo: nil)
                    
                    let minBound = bounds.min - SIMD3<Float>(repeating: bulletRadius)
                    let maxBound = bounds.max + SIMD3<Float>(repeating: bulletRadius)
                    
                    let isInsideBox = (newPosition.x >= minBound.x && newPosition.x <= maxBound.x) &&
                                      (newPosition.y >= minBound.y && newPosition.y <= maxBound.y) &&
                                      (newPosition.z >= minBound.z && newPosition.z <= maxBound.z)
                    
                    if isInsideBox {
                        if var enemyComp = enemy.components[EnemyComponent.self] {
                            
                            enemyComp.hp -= comp.damage
                            
                            if enemyComp.hp <= 0 {
                                enemy.removeFromParent()
                                Task { @MainActor in
                                    NotificationCenter.default.post(name: .enemyDefeated, object: nil)
                                }
                            } else {
                                enemy.components.set(enemyComp)
                            }
                        }
                        
                        hasHitEnemy = true
                        break
                    }
                }
                
                if hasHitEnemy {
                    entity.removeFromParent()
                    continue
                }

                let lifeFraction = elapsed / Float(lifetime)
                let scale = max(0.1, 1.0 - lifeFraction * 0.8)
                    
                entity.scale = SIMD3<Float>(repeating: 0.5 * scale)
            }
        }
}
