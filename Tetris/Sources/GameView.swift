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
        if event.isARepeat {
            return;
        }
        
        let pieceComponent = gameScene.currentPiece?.component(ofType: PieceComponent.self)
        
		switch Keycode(rawValue: event.keyCode) {
		case .f:
			pieceComponent?.turnLeft()
			break
			
		case .g:
			pieceComponent?.turnRight()
			break
			
		case .leftArrow:
            pieceComponent?.startMovingLeft()
			break
		
		case .rightArrow:
            pieceComponent?.startMovingRight()
			break
			
		case .downArrow:
            pieceComponent?.speedUp()
			break
			
		default:
			break
		}
	}
	
	override func keyUp(with event: NSEvent) {
        let pieceComponent = gameScene.currentPiece?.component(ofType: PieceComponent.self)
        
        switch Keycode(rawValue: event.keyCode) {
        case .leftArrow:
            pieceComponent?.stopMovingLeft()
            break
            
        case .rightArrow:
            pieceComponent?.stopMovingRight()
			break
		
		case .downArrow:
            pieceComponent?.resetSpeed()
			break
		
		default:
			break
		}
	}
	
}
