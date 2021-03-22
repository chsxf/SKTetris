//
//  GameView.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 04/03/2021.
//

import Foundation
import Cocoa
import SpriteKit

class GameView: SKView {

	private let gameScene: GameScene
	
	override init(frame frameRect: NSRect) {
		gameScene = GameScene(size: frameRect.size)
		
		super.init(frame: frameRect)
		
		presentScene(gameScene)
		
		showsFPS = true
		
		gameScene.stateMachine!.enter(GameIdleState.self)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func keyDown(with event: NSEvent) {
		switch Keycode(rawValue: event.keyCode) {
		case .f:
			gameScene.currentPiece?.component(ofType: PieceComponent.self)!.turnLeft()
			break
			
		case .g:
			gameScene.currentPiece?.component(ofType: PieceComponent.self)!.turnRight()
			break
			
		case .leftArrow:
			break
		
		case .rightArrow:
			break
			
		case .downArrow:
			break
			
		default:
			break
		}
	}
	
	override func keyUp(with event: NSEvent) {
		switch Keycode(rawValue: event.keyCode) {
		case .leftArrow, .rightArrow:
			break
		
		case .downArrow:
			break
		
		default:
			break
		}
	}
	
}
