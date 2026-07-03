import RealityKit
import ILSHandTracking
import ARKit
import UIKit

public struct GunSlingerSystem: System {
    static let query = EntityQuery(where: .has(WeaponComponent.self))
    static let bulletQuery = EntityQuery(where: .has(BulletComponent.self))
    
    nonisolated(unsafe) static var sphereTemplate: Entity?
    
    public init(scene: Scene) {}
    
    public func update(context: SceneUpdateContext) {
        gunUpdate(context: context)
        updateProjectiles(context: context)
    }
    
    public func gunUpdate(context: SceneUpdateContext) {
            let currentTime = CACurrentMediaTime()
            
            for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
                // 1. Ubah 'let' menjadi 'var' agar kita bisa memodifikasi propertinya
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
            
            projectile.components.set(BulletComponent(
                velocity: velocity,
                initialPosition: position,
                startTime: CACurrentMediaTime()
            ))
        }
        
        private func updateProjectiles(context: SceneUpdateContext) {
            let projectiles = context.entities(matching: Self.bulletQuery, updatingSystemWhen: .rendering)
            let currentTime = CACurrentMediaTime()

            for entity in projectiles {
                guard let comp = entity.components[BulletComponent.self] else { continue }
                let elapsed = Float(currentTime - comp.startTime)

                let lifetime: Float = 3.0
                
                if elapsed > lifetime {
                    entity.removeFromParent()
                    continue
                }

                let gravity = SIMD3<Float>(0, -4.0, 0)
                let newPosition = comp.initialPosition
                    + comp.velocity * elapsed
                    + 0.5 * gravity * elapsed * elapsed
                
                entity.setPosition(newPosition, relativeTo: nil)

                let lifeFraction = elapsed / lifetime
                let scale = max(0.1, 1.0 - lifeFraction * 0.8)
                
                entity.scale = SIMD3<Float>(repeating: 0.5 * scale)
            }
        }
}
