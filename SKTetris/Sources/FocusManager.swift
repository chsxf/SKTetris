//
//  FocusManager.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 09/05/2021.
//

import Foundation

enum InputMode {
    case keyboard
    case pointer
    case gameController
}

enum FocusDirection {
    case up
    case down
    case left
    case right
    
    enum FocusDirectionError : Error {
        case invalidKey
    }
    
    static func from(key: Keycode) throws -> FocusDirection {
        switch (key) {
        case .leftArrow:
            return .left
        case .rightArrow:
            return .right
        case .downArrow:
            return .down
        case .upArrow:
            return .up
        default:
            throw FocusDirectionError.invalidKey
        }
    }
}

protocol FocusHandler : NSObjectProtocol {
    
    var isHidden: Bool { get }
    var firstFocusTarget: ButtonNode { get }
    
    func nextFocusTarget(forDirection direction: FocusDirection, fromFocusTarget: ButtonNode) -> ButtonNode?
    
}

final class FocusManager {
    
    static private(set) var onInputModeChanged = EventEmitter<InputMode>()
    
    private static var handlers = [FocusHandler]()
    
    private static var activeHandler: FocusHandler?
    private static var activeHandlerFocusTarget: ButtonNode?
    
    static var inputMode: InputMode = .pointer {
        didSet {
            if inputMode != oldValue {
                onInputModeChanged.notify(inputMode)
                focusIsVisible = (inputMode != .pointer)
            }
        }
    }
    
    static private(set) var focusIsVisible: Bool = false {
        didSet {
            activeHandlerFocusTarget?.focused = focusIsVisible
        }
    }
    
    static func register(handler: FocusHandler) {
        handlers.append(handler)
    }
    
    static func unregister(handler: FocusHandler) {
        for index in (handlers.count - 1)...0 {
            if handlers[index].isEqual(handler) {
                handlers.remove(at: index)
            }
        }
    }
    
    static func update() {
        if activeHandler != nil && !activeHandler!.isHidden {
            return
        }
        
        activeHandlerFocusTarget?.focused = false
        
        for handler in handlers {
            if !handler.isEqual(activeHandler) && !handler.isHidden {
                activeHandler = handler
                activeHandlerFocusTarget = activeHandler?.firstFocusTarget
                activeHandlerFocusTarget?.focused = focusIsVisible
                return
            }
        }
        
        activeHandler = nil
        activeHandlerFocusTarget = nil
    }
    
    static func moveTowards(direction: FocusDirection) {
        guard let handler = activeHandler else {
            return
        }
        
        let newFocusTarget = handler.nextFocusTarget(forDirection: direction, fromFocusTarget: activeHandlerFocusTarget!)
        if newFocusTarget != nil {
            activeHandlerFocusTarget?.focused = false
            activeHandlerFocusTarget = newFocusTarget
            activeHandlerFocusTarget?.focused = true
        }
    }
    
    static func doTrigger() {
        activeHandlerFocusTarget?.doTrigger()
    }
    
}
