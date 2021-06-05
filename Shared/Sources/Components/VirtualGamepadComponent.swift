//
//  VirtualGamepadComponent.swift
//  SKTetris
//
//  Created by Christophe on 05/06/2021.
//

import GameplayKit

@objc(VirtualGamepadComponent)
class VirtualGamepadComponent: GKComponent {

    let onKeyDown = EventEmitter<VirtualGamepadKey>()
    let onKeyUp = EventEmitter<VirtualGamepadKey>()
    
    private var keyMap: [ButtonNode:VirtualGamepadKey] = [:]
    
    override class var supportsSecureCoding: Bool { true }
    
    func bindKeys() {
        guard let skNode = entity?.component(ofType: GKSKNodeComponent.self)?.node else {
            print("No node assigned")
            return
        }
        
        for child in skNode.children {
            guard let key = child.entity?.component(ofType: VirtualGamepadKeyComponent.self)?.key else {
                continue
            }
            
            guard let buttonNode = child as? ButtonNode else {
                continue
            }
            
            buttonNode.onDown.on(onButtonDown(sender:))
            buttonNode.onUp.on(onButtonUp(sender:))
            
            keyMap[buttonNode] = key
        }
    }
    
    private func onButtonDown(sender: Any?) {
        guard let button = sender as? ButtonNode else {
            return
        }
        
        guard let keyFromButton = keyMap[button] else {
            return
        }
        
        onKeyDown.notify(keyFromButton)
    }
    
    private func onButtonUp(sender: Any?) {
        guard let button = sender as? ButtonNode else {
            return
        }
        
        guard let keyFromButton = keyMap[button] else {
            return
        }
        
        onKeyUp.notify(keyFromButton)
    }
    
}
