//
//  SiriRemoteGestureRecognizer.swift
//  SKTetris-tvOS
//
//  Created by Christophe SAUVEUR on 08/06/2021.
//

import UIKit

class SiriRemoteGestureRecognizer: UIGestureRecognizer {

    private enum GestureDirection {
        case none
        case left
        case right
        case up
        case down
    }
    
    let gameView: GameView
    let virtualGamepadDelegate: VirtualGamepadDelegate
    
    private var touchStartPosition: CGPoint?
    private var previousTouchKey: VirtualGamepadKey?
    private var previousTouchDirection: GestureDirection?
    
    init(withGameView gameView: GameView, andDelegate delegate: VirtualGamepadDelegate) {
        self.gameView = gameView
        self.virtualGamepadDelegate = delegate
        
        super.init(target: nil, action: nil)
        
        allowedPressTypes = [
            NSNumber(value: UIPress.PressType.playPause.rawValue),
            NSNumber(value: UIPress.PressType.select.rawValue)
        ]
        
        allowedTouchTypes = [
            NSNumber(value: UITouch.TouchType.indirect.rawValue)
        ]
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent) {
        switch presses.first!.type {
        case .select:
            virtualGamepadDelegate.onVirtualGamepadKeyDown(.buttonA)
            break
        case .playPause:
            virtualGamepadDelegate.onVirtualGamepadKeyDown(.buttonMenu)
            break
        default:
            break
        }
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent) {
        switch presses.first!.type {
        case .select:
            virtualGamepadDelegate.onVirtualGamepadKeyUp(.buttonA)
            break
        case .playPause:
            virtualGamepadDelegate.onVirtualGamepadKeyUp(.buttonMenu)
            break
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        touchStartPosition = touches.first!.location(in: gameView)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        let location = touches.first!.location(in: gameView)
        
        let direction = getGeneralDirectionTowards(position: location)
        if previousTouchDirection != nil {
            if previousTouchDirection != direction {
                virtualGamepadDelegate.onVirtualGamepadKeyUp(previousTouchKey!)
            }
            else {
                return
            }
        }
        
        previousTouchDirection = direction
        switch direction {
        case.left:
            previousTouchKey = .dpadLeft
            break
        case .right:
            previousTouchKey = .dpadRight
            break
        case .up:
            previousTouchKey = .dpadUp
            break
        case .down:
            previousTouchKey = .dpadDown
            break
        default:
            previousTouchKey = nil
            previousTouchDirection = nil
            break
        }
        
        if previousTouchKey != nil {
            virtualGamepadDelegate.onVirtualGamepadKeyDown(previousTouchKey!)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        let location = touches.first!.location(in: gameView)
        
        let direction = getGeneralDirectionTowards(position: location)
        switch direction {
        case .left:
            virtualGamepadDelegate.onVirtualGamepadKeyUp(.dpadLeft)
            break
        case .right:
            virtualGamepadDelegate.onVirtualGamepadKeyUp(.dpadRight)
            break
        case .down:
            virtualGamepadDelegate.onVirtualGamepadKeyUp(.dpadDown)
            break
        case .up:
            virtualGamepadDelegate.onVirtualGamepadKeyUp(.dpadUp)
            break
        default:
            break
        }
    }
    
    private func getGeneralDirectionTowards(position: CGPoint) -> GestureDirection {
        guard let startPosition = touchStartPosition else {
            return .none
        }
        
        let diff = CGPoint(x: position.x - startPosition.x, y: position.y - startPosition.y)
        if abs(diff.x) < 1.0 && abs(diff.y) < 1.0 {
            return .none
        }
        
        let xyRatio = abs(diff.y / diff.x)
        if xyRatio > 0.75 && xyRatio < 1.5 {
            return .none
        }
        
        if xyRatio < 1 {
            return diff.x > 0 ? .right : .left
        }
        else {
            return diff.y < 0 ? .up : .down
        }
    }
}
