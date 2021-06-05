//
//  OptionsScreenNode.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 07/05/2021.
//

import SpriteKit

class OptionsScreenNode: SKNode, FocusHandler {

    private var sfxToggle: ToggleButtonNode?
    private var musicToggle: ToggleButtonNode?
    private var playButton: ButtonNode?
    private var quitButton: ButtonNode?
    
    var firstFocusTarget: ButtonNode { playButton! }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        FocusManager.register(handler: self)
        
        sfxToggle = childNode(withName: "SFX Toggle") as? ToggleButtonNode
        sfxToggle?.checked = SettingsManager.sfxEnabled
        sfxToggle?.onClicked.on { _ in
            SettingsManager.sfxEnabled = self.sfxToggle!.checked
        }
        
        musicToggle = childNode(withName: "Music Toggle") as? ToggleButtonNode
        musicToggle?.checked = SettingsManager.musicEnabled
        musicToggle?.onClicked.on { _ in
            SettingsManager.musicEnabled = self.musicToggle!.checked
        }
        
        playButton = childNode(withName: "Play Button") as? ButtonNode
        playButton?.onClicked.on { _ in
            (self.scene as! GameScene).toggleOptions()
        }
        
        quitButton = childNode(withName: "Quit Button") as? ButtonNode
        #if os(macOS)
        quitButton?.onClicked.on { _ in
            NSApp.terminate(nil)
        }
        #else
        quitButton?.isHidden = true
        #endif
        
        isHidden = true
    }
    
    func nextFocusTarget(forDirection direction: FocusDirection, fromFocusTarget: ButtonNode) -> ButtonNode? {
        if direction == .down {
            switch fromFocusTarget {
            case sfxToggle:
                return musicToggle
            case musicToggle:
                #if os(macOS)
                return quitButton
                #else
                return playButton
                #endif
            case quitButton:
                return playButton
            default:
                return nil
            }
        }
        else if direction == .up {
            switch fromFocusTarget {
            case musicToggle:
                return sfxToggle
            case quitButton:
                return musicToggle
            case playButton:
                #if os(macOS)
                return quitButton
                #else
                return musicToggle
                #endif
            default:
                return nil
            }
        }
        
        return nil
    }
    
}
