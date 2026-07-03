//
//  AppModel.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import SwiftUI
import RealityKit

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
    
    var enemiesDefeated: Int = 0
    var totalEnemiesToWin: Int = 5
    
    var towerHp: Int = 100
    var towerMaxHp: Int = 100
    
    var towerEntity: Entity?
    
    func resetGame() {
        enemiesDefeated = 0
        currentGameState = .playing
            
        towerHp = 100
        
        if let entity = towerEntity, var towerComp = entity.components[TowerComponent.self] {
            towerComp.hp = 100
            entity.components.set(towerComp)
        }
        
        playGame()
    }
    
    func playGame() {
        GameStateTracker.isPlaying = true
    }
    
    func stopGame() {
        GameStateTracker.isPlaying = false
    }
}
