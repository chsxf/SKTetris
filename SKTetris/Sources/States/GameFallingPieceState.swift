//
//  GameFallingPieceState.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 07/03/2021.
//

import GameplayKit

class GameFallingPieceState: GKState {

	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		return stateClass == GameResolutionState.self
	}
	
	override func didEnter(from previousState: GKState?) {
		let gameStateMachine = stateMachine! as! GameStateMachine
		if let piece = gameStateMachine.scene.currentPiece {
			let pieceComponent = piece.component(ofType: PieceComponent.self)!
			pieceComponent.pieceHasLanded.once {
                SoundManager.play(.brickLand)
				gameStateMachine.enter(GameResolutionState.self)
			}
		}
	}
	
	override func update(deltaTime seconds: TimeInterval) {
		super.update(deltaTime: seconds)
		
		let gameStateMachine = stateMachine! as! GameStateMachine
		if let piece = gameStateMachine.scene.currentPiece {
			piece.update(deltaTime: seconds)
		}
	}
	
}
