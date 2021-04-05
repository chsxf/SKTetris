//
//  GameOverState.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 07/03/2021.
//

import GameplayKit

class GameOverState: GKState {

	override func didEnter(from previousState: GKState?) {
		let gameStateMachine = stateMachine as! GameStateMachine
		gameStateMachine.scene.gameOver()
	}
	
}
