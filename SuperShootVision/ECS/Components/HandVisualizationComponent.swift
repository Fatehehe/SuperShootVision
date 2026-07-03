//
//  HandVisualizationComponent.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import RealityKit
import ARKit

public struct HandVisualizationComponent: Component {
    public let chirality: HandAnchor.Chirality
    
    public init(chirality: HandAnchor.Chirality) {
        self.chirality = chirality
    }
}
