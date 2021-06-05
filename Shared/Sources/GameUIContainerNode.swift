//
//  GameUIContainerNode.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 09/05/2021.
//

import SpriteKit

class GameUIContainerNode: SKNode {

    private var pauseToggle: ToggleButtonNode?
    private var optionsButton: ButtonNode?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        pauseToggle = childNode(withName: "Pause Button") as? ToggleButtonNode
        pauseToggle?.onClicked.on { _ in
            (self.scene as! GameScene).togglePause()
        }
        pauseToggle?.checked = false
        
        optionsButton = childNode(withName: "Options Button") as? ButtonNode
        optionsButton?.onClicked.on { _ in
            (self.scene as! GameScene).toggleOptions()
        }
        
        FocusManager.onInputModeChanged.on(onFocusManagerInputModeChanged(_:sender:))
        onFocusManagerInputModeChanged(FocusManager.inputMode, sender: nil)
    }
    
    private func onFocusManagerInputModeChanged(_ inputMode: InputMode, sender: Any?) {
        #if os(macOS)
        let hide = (inputMode == .gameController)
        pauseToggle?.isHidden = hide
        optionsButton?.isHidden = hide
        #endif
    }
    
    func switchPauseToggle() {
        pauseToggle!.checked = !pauseToggle!.checked
    }
    
}
