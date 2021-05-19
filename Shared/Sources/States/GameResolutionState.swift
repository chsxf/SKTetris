//
//  GameResolutionState.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 07/03/2021.
//

import GameplayKit

class GameResolutionState: GKState {

	private let BLINKING_DURATION = 1.0
	
	private var fullRows: [GridRow]?
	
	private var blinkingTimeBuffer: TimeInterval = 0
	
	private(set) var onLinesCompleted = EventEmitter<Int>()
	
	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		return stateClass == GameIdleState.self
	}
	
	override func didEnter(from previousState: GKState?) {
		blinkingTimeBuffer = 0
		
		let gameStateMachine = stateMachine as! GameStateMachine
		gameStateMachine.scene.landCurrentPiece()
		
		let gridBlockContainerComponent = GameScene.grid.component(ofType: GridBlockContainerComponent.self)!
		fullRows = gridBlockContainerComponent.getFullRows()
		if fullRows != nil {
            SoundManager.play(.linesRemoved)
			blinkDisappearingRows()
		}
		else {
			gameStateMachine.enter(GameIdleState.self)
		}
	}
	
	private func blinkDisappearingRows() -> Void {
		for row in fullRows! {
			for block in row.blocks {
				let geometryComponent = block.component(ofType: GeometryComponent.self)!
				geometryComponent.blinking = true
			}
		}
	}
	
	override func update(deltaTime seconds: TimeInterval) {
		blinkingTimeBuffer += seconds
		if (blinkingTimeBuffer > BLINKING_DURATION) {
			let gameStateMachine = stateMachine as! GameStateMachine
			var topIndex = 0
			for row in fullRows! {
				for block in row.blocks {
					gameStateMachine.scene.removeBlock(block)
				}
				topIndex = max(topIndex, row.index)
			}
			
			let gridBlockContainerComponent = GameScene.grid.component(ofType: GridBlockContainerComponent.self)!
			gridBlockContainerComponent.fallBlocks(aboveIndex: topIndex, ofRows: fullRows!.count)
			
			onLinesCompleted.notify(fullRows!.count)
			
			gameStateMachine.enter(GameIdleState.self)
		}
	}
	
	override func willExit(to nextState: GKState) {
		fullRows = nil
	}
	
}
