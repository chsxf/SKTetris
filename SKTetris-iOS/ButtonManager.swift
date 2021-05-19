//
//  ButtonManager.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 26/04/2021.
//

import SpriteKit

final class ButtonManager {
    
    static var scene: SKScene?
    
    private static var previousViewSize: CGSize?
    
    private static var buttons = [ButtonNode]()
    private static var activeButtons = [ButtonNode]()
    
    static func add(button: ButtonNode) -> Void {
        if !buttons.contains(button) {
            buttons.append(button)
        }
    }
    
    static func remove(button: ButtonNode) -> Void {
        buttons.removeAll { item in
            item == button
        }
        activeButtons.removeAll { item in
            item == button
        }
    }
    
    static func update() -> Void {
        for button in buttons {
            let buttonIsVisible = !button.isHiddenInHierarchy
            let buttonIsActive = activeButtons.contains(button)
            if buttonIsVisible && !buttonIsActive {
                activeButtons.append(button)
            }
            else if !buttonIsVisible && buttonIsActive {
                button.reset()
                activeButtons.removeAll { item in
                    item == button
                }
            }
        }
    }
    
}
