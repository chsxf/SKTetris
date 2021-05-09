//
//  GameUIContainerNode.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 09/05/2021.
//

import SpriteKit

class GameUIContainerNode: SKNode {

    private var pauseToggle: ToggleButtonNode?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        pauseToggle = childNode(withName: "Pause Button") as? ToggleButtonNode
        pauseToggle?.onClicked.on {
            (self.scene as! GameScene).togglePause()
        }
        pauseToggle?.checked = false
        
        let optionsButton = childNode(withName: "Options Button")! as! ButtonNode
        optionsButton.onClicked.on {
            (self.scene as! GameScene).toggleOptions()
        }
    }
    
    func switchPauseToggle() {
        pauseToggle!.checked = !pauseToggle!.checked
    }
    
}
