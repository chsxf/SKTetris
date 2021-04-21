//
//  PauseButtonNode.swift
//  Tetris
//
//  Created by Christophe on 18/04/2021.
//

import Cocoa
import SpriteKit

class PauseButtonNode: ButtonNode {
    
    private var pauseTexture: SKTexture? {
        get { BlockTools.mainAtlas.textureNamed("icon_pause") }
    }
    private var playTexture: SKTexture? {
        get { BlockTools.mainAtlas.textureNamed("icon_play") }
    }
    
    private var icon: SKSpriteNode? {
        get { childNode(withName: "Icon") as? SKSpriteNode }
    }
    
    private var showsPause = true
    
    override func reset() {
        super.reset()
        
        showsPause = true
        icon!.texture = pauseTexture
    }
    
    override func mouseUp(with event: NSEvent) {
        if hovered {
            icon!.texture = showsPause ? playTexture : pauseTexture
            showsPause = !showsPause
        }
        
        super.mouseUp(with: event)
    }
}
