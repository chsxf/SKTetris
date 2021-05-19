//
//  GameOverContainerNode.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 09/05/2021.
//

import SpriteKit

class GameOverContainerNode: SKNode, FocusHandler {
    
    private var replayButton: ButtonNode?
    
    var firstFocusTarget: ButtonNode { replayButton! }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        FocusManager.register(handler: self)
        
        replayButton = childNode(withName: "Replay Button") as? ButtonNode
        replayButton?.onClicked.on {
            (self.scene as! GameScene).replay()
        }
        
        isHidden = true
    }
    
    func nextFocusTarget(forDirection direction: FocusDirection, fromFocusTarget: ButtonNode) -> ButtonNode? {
        return nil
    }
    
}
