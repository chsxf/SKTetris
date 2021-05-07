//
//  MainTitleScreenNode.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 07/05/2021.
//

import SpriteKit

class MainTitleScreenNode: SKNode {

    private var buttonsContainer: SKNode?
    
    private var playButton: ButtonNode?
    private var creditsButton: ButtonNode?
    
    private var firstDisplay = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        buttonsContainer = childNode(withName: "Button Container")
        
        playButton = buttonsContainer!.childNode(withName: "Play Button")! as? ButtonNode
        playButton?.onClicked.on(playButtonClicked)
        creditsButton = buttonsContainer!.childNode(withName: "Credits Button")! as? ButtonNode
        creditsButton?.onClicked.on(creditsButtonClicked)
        
        isHidden = true
    }
    
    override var isHidden: Bool {
        didSet {
            if !isHidden {
                if firstDisplay {
                    self.buttonsContainer?.isHidden = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.buttonsContainer?.isHidden = false
                    }
                }
                else {
                    buttonsContainer?.isHidden = false
                }
            }
        }
    }
    
    func playButtonClicked() {
        guard let gameScene = scene as? GameScene else {
            return
        }
        
        gameScene.hideMainTitle()
        gameScene.stateMachine?.enter(GameIdleState.self)
    }
    
    func creditsButtonClicked() {
        let url = URL(string: "https://github.com/chsxf/SKTetris#licence")
        if url != nil {
            NSWorkspace.shared.open(url!)
        }
    }
    
}
