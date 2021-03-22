//
//  GameIdleState.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 07/03/2021.
//

import GameplayKit

class GameIdleState: GKState {

	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		return stateClass == GameFallingPieceState.self
	}
	
	override func didEnter(from previousState: GKState?) {
		let gameStateMachine = stateMachine! as! GameStateMachine
		
		if previousState == nil {
			gameStateMachine.scene.spawnNextPiece()
		}
		
		gameStateMachine.scene.dropCurrentPiece()
		gameStateMachine.scene.spawnNextPiece()
		
		gameStateMachine.enter(GameFallingPieceState.self)
	}
	
}
