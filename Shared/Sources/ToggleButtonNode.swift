//
//  PauseButtonNode.swift
//  Tetris
//
//  Created by Christophe on 18/04/2021.
//

import SpriteKit

class ToggleButtonNode: ButtonNode {
    
    private var checkedTexture: SKTexture? {
        get {
            guard let textureName = userData!["checkedTextureName"] else {
                return nil
            }
            return BlockTools.mainAtlas.textureNamed(textureName as! String)
        }
    }
    
    private var uncheckedTexture: SKTexture? {
        get {
            guard let textureName = userData!["uncheckedTextureName"] else {
                return nil
            }
            return BlockTools.mainAtlas.textureNamed(textureName as! String)
        }
    }
    
    private var icon: SKSpriteNode? {
        get { childNode(withName: "Icon") as? SKSpriteNode }
    }
    
    var checked = true {
        didSet {
            let texture = checked ? checkedTexture : uncheckedTexture
            icon!.texture = texture
            icon!.isHidden = texture == nil
        }
    }
    
    override func doTrigger() {
        checked = !checked
        super.doTrigger()
    }
    
    #if os(macOS)
    override func mouseUp(with event: NSEvent) {
        if hovered {
            checked = !checked
        }
        
        super.mouseUp(with: event)
    }
    #else
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: parent!)
        let rect = calculateAccumulatedFrame()
        if down && rect.contains(location) {
            checked = !checked
        }
        
        super.touchesEnded(touches, with: event)
    }
    #endif
    
}
