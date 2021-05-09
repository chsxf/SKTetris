//
//  GameOverContainerNode.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 09/05/2021.
//

import SpriteKit

class GameOverContainerNode: SKNode {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let replayButton = childNode(withName: "Replay Button")! as! ButtonNode
        replayButton.onClicked.on {
            (self.scene as! GameScene).replay()
        }
        
        isHidden = true
    }
    
}
