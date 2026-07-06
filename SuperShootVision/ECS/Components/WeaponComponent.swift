//
//  WeaponComponent.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import RealityKit
import ARKit

public struct WeaponComponent: Component {
    public var chirality: HandAnchor.Chirality
    
    // --- TAMBAHAN UNTUK LOGIKA TEMBAK ---
    public var lastFireTime: TimeInterval = 0.0
    public var fireCooldown: TimeInterval = 0.5 // Jeda 0.5 detik antar tembakan
    public var wasTriggerPose: Bool = false     // Menyimpan status pose di frame sebelumnya
    
    public init(chirality: HandAnchor.Chirality) {
        self.chirality = chirality
    }
}
