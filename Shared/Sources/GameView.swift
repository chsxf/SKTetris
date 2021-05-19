//
//  GameView.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 04/03/2021.
//

import Foundation
import SpriteKit
import GameController

class GameView: SKView {

	private let gameScene: GameScene
    
    private var currentController: GCController?

    #if os(macOS)
    private var trackingArea: NSTrackingArea?
    #endif

	override init(frame frameRect: CGRect) {
		gameScene = GameScene(size: frameRect.size)
		
		super.init(frame: frameRect)
		
		presentScene(gameScene)
		
		showsFPS = true
		showsDrawCount = true
		showsNodeCount = true
		
		gameScene.stateMachine!.enter(GameMainTitleState.self)
        
        SoundManager.play(.backgroundMusic01)
        FocusManager.onInputModeChanged.on(onFocusManagerInputModeChanged)
        
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        notificationCenter.addObserver(forName: .GCControllerDidConnect, object: nil, queue: mainQueue) { notif in
            self.gameControllerDidConnect()
        }
        notificationCenter.addObserver(forName: .GCControllerDidDisconnect, object: nil, queue: mainQueue) { notif in
            self.gameControllerDidDisconnect()
        }
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    private func gameControllerDidConnect() {
        if currentController == nil {
            for controller in GCController.controllers() {
                let microGamepad = controller.microGamepad
                if microGamepad != nil {
                    currentController = controller
                    microGamepad!.valueChangedHandler = onMicroGamepadValueChanged(microGamepad:element:)
                    microGamepad!.reportsAbsoluteDpadValues = true
                    microGamepad!.dpad.up.pressedChangedHandler = onMicroGamepadButtonValueChanged(buttonInput:pressure:pressed:)
                    microGamepad!.dpad.down.pressedChangedHandler = onMicroGamepadButtonValueChanged(buttonInput:pressure:pressed:)
                    microGamepad!.dpad.left.pressedChangedHandler = onMicroGamepadButtonValueChanged(buttonInput:pressure:pressed:)
                    microGamepad!.dpad.right.pressedChangedHandler = onMicroGamepadButtonValueChanged(buttonInput:pressure:pressed:)
                    microGamepad!.buttonA.pressedChangedHandler = onMicroGamepadButtonValueChanged(buttonInput:pressure:pressed:)
                    microGamepad!.buttonX.pressedChangedHandler = onMicroGamepadButtonValueChanged(buttonInput:pressure:pressed:)
                    microGamepad!.buttonMenu.pressedChangedHandler = onMicroGamepadButtonValueChanged(buttonInput:pressure:pressed:)
                }
            }
        }
    }
    
    private func gameControllerDidDisconnect() {
        if currentController != nil && !GCController.controllers().contains(currentController!) {
            currentController = nil
            
            if FocusManager.inputMode == .gameController {
                FocusManager.inputMode = .pointer
            }
        }
    }
    
    private func onMicroGamepadValueChanged(microGamepad: GCMicroGamepad, element: GCControllerElement) {
        if FocusManager.inputMode != .gameController {
            FocusManager.inputMode = .gameController
        }
    }
    
    private func onMicroGamepadButtonValueChanged(buttonInput: GCControllerButtonInput, pressure: Float, pressed: Bool) {
        guard let microGamepad = currentController?.microGamepad else {
            return
        }
        
        guard FocusManager.inputMode == .gameController else {
            return
        }
        
        if gameScene.isInMenu {
            if !pressed {
                switch buttonInput {
                case microGamepad.dpad.down:
                    FocusManager.moveTowards(direction: .down)
                    break
                case microGamepad.dpad.up:
                    FocusManager.moveTowards(direction: .up)
                    break
                case microGamepad.dpad.left:
                    FocusManager.moveTowards(direction: .left)
                    break
                case microGamepad.dpad.right:
                    FocusManager.moveTowards(direction: .right)
                    break
                case microGamepad.buttonA:
                    FocusManager.doTrigger()
                    break
                default:
                    break
                }
            }
        }
        else {
            let pieceComponent = gameScene.currentPiece?.component(ofType: PieceComponent.self)
            
            switch buttonInput {
            case microGamepad.dpad.left:
                if pressed {
                    pieceComponent?.startMovingLeft()
                }
                else {
                    pieceComponent?.stopMovingLeft()
                }
                break
            case microGamepad.dpad.right:
                if pressed {
                    pieceComponent?.startMovingRight()
                }
                else {
                    pieceComponent?.stopMovingRight()
                }
                break
            case microGamepad.dpad.down:
                if pressed {
                    pieceComponent?.speedUp()
                }
                else {
                    pieceComponent?.resetSpeed()
                }
            case microGamepad.buttonX:
                if pressed {
                    pieceComponent?.turnLeft()
                }
                break
            case microGamepad.buttonA:
                if pressed {
                    pieceComponent?.turnRight()
                }
                break
            default:
                break
            }
        }

        if buttonInput == microGamepad.buttonMenu && !pressed {
            gameScene.toggleOptions()
        }
    }
    
    private func onFocusManagerInputModeChanged(inputMode: InputMode) {
        #if os(macOS)
        if inputMode != .pointer {
            trackingArea = NSTrackingArea(rect: frame, options: [.activeWhenFirstResponder, .mouseMoved], owner: self, userInfo: nil)
            addTrackingArea(trackingArea!)
        }
        else if trackingArea != nil {
            removeTrackingArea(trackingArea!)
        }
        #endif
    }
    
    #if os(macOS)
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
    #endif
    
}
