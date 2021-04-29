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
    
    var showsPause = true {
        didSet {
            icon!.texture = showsPause ? pauseTexture : playTexture
        }
    }
    
    override func reset() {
        super.reset()
        
        showsPause = true
    }
    
    override func mouseUp(with event: NSEvent) {
        if hovered {
            showsPause = !showsPause
        }
        
        super.mouseUp(with: event)
    }
}
