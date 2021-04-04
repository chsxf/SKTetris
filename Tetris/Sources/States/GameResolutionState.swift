//
//  GameResolutionState.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 07/03/2021.
//

import GameplayKit

class GameResolutionState: GKState {

	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		return stateClass == GameIdleState.self || stateClass == GameOverState.self
	}
	
	override func didEnter(from previousState: GKState?) {
		let gameStateMachine = stateMachine! as! GameStateMachine
		gameStateMachine.scene.landCurrentPiece()
		
		gameStateMachine.enter(GameIdleState.self)
	}
	
}
