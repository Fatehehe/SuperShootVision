//
//  EnemyComponent.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 03/07/26.
//

import RealityKit
import Foundation

public struct EnemyComponent: Component {
    public var hp: Int = 30
    
    public var targetTowerPosition: SIMD3<Float> = .zero
    
    public var lastDamageTime: TimeInterval = 0.0
    public var damageInterval: TimeInterval = 1.0
    public var damageAmount: Int = 10
    
    public init() {}
}
