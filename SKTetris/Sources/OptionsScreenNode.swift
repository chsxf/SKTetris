//
//  OptionsScreenNode.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 07/05/2021.
//

import SpriteKit

class OptionsScreenNode: SKNode {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let sfxToggle = childNode(withName: "SFX Toggle")! as? ToggleButtonNode
        sfxToggle!.checked = SettingsManager.sfxEnabled
        sfxToggle!.onClicked.on {
            SettingsManager.sfxEnabled = sfxToggle!.checked
        }
        
        let musicToggle = childNode(withName: "Music Toggle")! as? ToggleButtonNode
        musicToggle!.checked = SettingsManager.musicEnabled
        musicToggle!.onClicked.on {
            SettingsManager.musicEnabled = musicToggle!.checked
        }
        
        let playButton = childNode(withName: "Play Button")! as? ButtonNode
        playButton?.onClicked.on {
            (self.scene as! GameScene).toggleOptions()
        }
        
        let quitButton = childNode(withName: "Quit Button")! as? ButtonNode
        #if os(macOS)
        quitButton?.onClicked.on {
            NSApp.terminate(nil)
        }
        #else
        quitButton?.isHidden = true
        #endif
        
        isHidden = true
    }
    
}
