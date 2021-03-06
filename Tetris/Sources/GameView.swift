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
		
		let set = SKReferenceNode(fileNamed: "Background")
		gameScene.addChild(set!)
		
		let tallPiece = BlockTools.generatePiece(.row)
		gameScene.addChild(tallPiece)
		
		showsFPS = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func keyDown(with event: NSEvent) {
		switch Keycode(rawValue: event.keyCode) {
		case .f:
			gameScene.turnCurrentPieceLeft()
			break
			
		case .g:
			gameScene.turnCurrentPieceRight()
			break
			
		case .leftArrow:
			gameScene.startMovingCurrentPieceLeft()
			break
		
		case .rightArrow:
			gameScene.startMovingCurrentPieceRight()
			break
			
		case .downArrow:
			gameScene.speedUpCurrentPiece()
			break
			
		default:
			break
		}
	}
	
	override func keyUp(with event: NSEvent) {
		switch Keycode(rawValue: event.keyCode) {
		case .leftArrow, .rightArrow:
			gameScene.stopMovingPiece()
			break
		
		case .downArrow:
			gameScene.resetSpeedForCurrentPiece()
			break
		
		default:
			break
		}
	}
	
}
