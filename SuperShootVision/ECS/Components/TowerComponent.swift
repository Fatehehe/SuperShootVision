//
//  TowerComponent.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import RealityKit

public struct TowerComponent: Component {
    public var hp: Int = 100
    public var maxHp: Int = 100
    public var isDestroyed: Bool = false
    
    public init() {}
}
