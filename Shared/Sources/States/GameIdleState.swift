//
//  GameIdleState.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 07/03/2021.
//

import GameplayKit

class GameIdleState: GKState {

	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		return stateClass == GameFallingPieceState.self || stateClass == GameOverState.self
	}
	
	override func didEnter(from previousState: GKState?) {
		let gameStateMachine = stateMachine! as! GameStateMachine
		
		if previousState is GameMainTitleState || previousState is GameOverState {
			gameStateMachine.scene.spawnNextPiece()
		}
		
		gameStateMachine.scene.dropCurrentPiece()
		gameStateMachine.scene.spawnNextPiece()
		
		let piece = gameStateMachine.scene.currentPiece!
		let pieceComponent = piece.component(ofType: PieceComponent.self)!
		
		var blockCoordinates = [GridCoordinates]()
		for block in pieceComponent.blocks {
			let transform = block.component(ofType: BlockTransformComponent.self)!
			blockCoordinates.append(transform.coordinates)
		}
		
		let gridBlockContainerComponent = GameScene.grid.component(ofType: GridBlockContainerComponent.self)!
		if (gridBlockContainerComponent.validateCoordinates(coordinatesList: blockCoordinates)) {
			gameStateMachine.enter(GameFallingPieceState.self)
		}
		else {
			gameStateMachine.enter(GameOverState.self)
		}
	}
	
}
