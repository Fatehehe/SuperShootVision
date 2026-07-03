//
//  SystemRegistry.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import Foundation
import RealityKit
import ILSHandTracking

public struct SystemRegistry {
    public static func registerAllSystems() {
        ILFeatureHandTrackingSetup.registerSystems()
        
        HandVisualizationComponent.registerComponent()
        HandVisualizationSystem.registerSystem()
        
        WeaponComponent.registerComponent()
        
        PortalComponent.registerComponent()
        PortalSystem.registerSystem()
        
        EnemyComponent.registerComponent()
        EnemySystem.registerSystem()
        
        GunSlingerSystem.registerSystem()
    }
}

