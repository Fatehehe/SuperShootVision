//
//  BulletComponent.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import RealityKit

struct BulletComponent: Component {
    var velocity: SIMD3<Float>

    var initialPosition: SIMD3<Float>

    var startTime: Double

    var lifetime: Double = 3.0
    public var damage: Int = 10
}
