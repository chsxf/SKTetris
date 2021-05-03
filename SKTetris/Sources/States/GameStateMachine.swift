//
//  GameStateMachine.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 22/03/2021.
//

import GameplayKit

class GameStateMachine: GKStateMachine {

	let scene: GameScene
	
	init(withScene scene: GameScene) {
		self.scene = scene
		
		let states = [
            GameMainTitleState(),
			GameFallingPieceState(),
			GameIdleState(),
			GameOverState(),
			GameResolutionState()
		]
		super.init(states: states)
	}
	
}
