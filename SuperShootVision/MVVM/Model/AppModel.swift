//
//  AppModel.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    
    let windowGroupID = "MainWindow"
    enum GameState {
        case startScreen
        case loading
        case tutorial
        case playing
        case won
        case lost
    }
    
    var currentGameState = GameState.startScreen
    
    func playGame() {
        GameStateTracker.isPlaying = true
    }
    
    func stopGame() {
        GameStateTracker.isPlaying = false
    }
}
