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
    
    private var trackingArea: NSTrackingArea?
	
	override init(frame frameRect: NSRect) {
		gameScene = GameScene(size: frameRect.size)
		
		super.init(frame: frameRect)
		
		presentScene(gameScene)
		
		showsFPS = true
		showsDrawCount = true
		showsNodeCount = true
		
		gameScene.stateMachine!.enter(GameMainTitleState.self)
        
        SoundManager.play(.backgroundMusic01)
        FocusManager.onInputModeChanged.on(onFocusManagerInputModeChanged)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    private func onFocusManagerInputModeChanged(inputMode: InputMode) {
        if inputMode != .pointer {
            trackingArea = NSTrackingArea(rect: frame, options: [.activeWhenFirstResponder, .mouseMoved], owner: self, userInfo: nil)
            addTrackingArea(trackingArea!)
        }
        else if trackingArea != nil {
            removeTrackingArea(trackingArea!)
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
        FocusManager.inputMode = .pointer
    }
    
	override func keyDown(with event: NSEvent) {
        if event.isARepeat || gameScene.isInMenu {
            return;
        }
        
        let pieceComponent = gameScene.currentPiece?.component(ofType: PieceComponent.self)
        
        let keycode = Keycode(rawValue: event.keyCode)
        switch keycode {
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
        let keycode = Keycode(rawValue: event.keyCode)!
        
        if gameScene.isInMenu {
            switch keycode {
            case .leftArrow, .rightArrow, .downArrow, .upArrow:
                if FocusManager.inputMode != .keyboard {
                    FocusManager.inputMode = .keyboard
                }
                else {
                    do {
                        try FocusManager.moveTowards(direction: FocusDirection.from(key: keycode))
                    }
                    catch {
                        print("\(keycode) is not a valid direction key")
                    }
                }
                break
            case .space:
                FocusManager.doTrigger()
                break
            default:
                break
            }
        }
        else {
            let pieceComponent = gameScene.currentPiece?.component(ofType: PieceComponent.self)
            
            switch keycode {
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
        
        switch keycode {
        case .p:
            gameScene.togglePause(fromController: true)
            break
        
        case .escape:
            gameScene.toggleOptions()
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
