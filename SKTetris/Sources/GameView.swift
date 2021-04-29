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
		showsDrawCount = true
		showsNodeCount = true
		
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
            
        case .escape:
            gameScene.togglePause(fromController: true)
            break
		
		default:
			break
		}
	}
    
    func addTrackingArea(fromNode node: SKNode) -> NSTrackingArea {
        let nodeFrame = node.calculateAccumulatedFrame()
        
        let bottomLeftInView = convert(CGPoint(x: nodeFrame.minX, y: nodeFrame.minY), from: gameScene)
        let topRightInView = convert(CGPoint(x: nodeFrame.maxX, y: nodeFrame.maxY), from: gameScene)
        
        let width = abs(topRightInView.x - bottomLeftInView.x)
        let height = abs(topRightInView.y - bottomLeftInView.y)
        let viewRect = NSRect(x: bottomLeftInView.x, y: bottomLeftInView.y, width: width, height: height)
		let trackingArea = NSTrackingArea(rect: viewRect, options: [ .mouseEnteredAndExited, .activeWhenFirstResponder, .enabledDuringMouseDrag ], owner: node, userInfo: nil)
        addTrackingArea(trackingArea)
        return trackingArea
    }
	
}
