//
//  PortalComponent.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import RealityKit

public struct PortalComponent: Component {
    public var spawnInterval: TimeInterval = 3.0
    public var lastSpawnTime: TimeInterval = 0.0
    
    public var spawnedCount: Int = 0
    public var maxEnemies: Int = 3
    public init() {}
}
