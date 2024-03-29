//
//  MainTitleScreenNode.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 07/05/2021.
//

import SpriteKit

class MainTitleScreenNode: SKNode, FocusHandler {
    
    private var buttonsContainer: SKNode?
    
    private var playButton: ButtonNode?
    private var creditsButton: ButtonNode?
    
    private var firstDisplay = true
    
    var firstFocusTarget: ButtonNode { playButton! }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        FocusManager.register(handler: self)
        
        buttonsContainer = childNode(withName: "Button Container")
        
        playButton = buttonsContainer!.childNode(withName: "Play Button")! as? ButtonNode
        playButton?.onClicked.on(playButtonClicked)
        
        creditsButton = buttonsContainer!.childNode(withName: "Credits Button")! as? ButtonNode
        creditsButton?.onClicked.on(creditsButtonClicked)
        #if os(tvOS)
        creditsButton?.isHidden = true
        #endif        
        
        let versionLabel = childNode(withName: "Version Anchor/Version Label")! as! SKLabelNode
        #if os(macOS)
        let os = "macOS"
        #elseif os(iOS)
        let os = "iOS"
        #elseif os(tvOS)
        let os = "tvOS"
        #endif
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        versionLabel.text = "\(appVersion)-\(os)"
        
        isHidden = true
    }
    
    override var isHidden: Bool {
        didSet {
            if !isHidden {
                if firstDisplay {
                    // Init main atlas to apply nearest filtering
                    let _ = BlockTools.mainAtlas
                    
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
    
    func playButtonClicked(sender: Any?) {
        guard let gameScene = scene as? GameScene else {
            return
        }
        
        gameScene.hideMainTitle()
        gameScene.stateMachine?.enter(GameIdleState.self)
    }
    
    func creditsButtonClicked(sender: Any?) {
        let url = URL(string: "https://github.com/chsxf/SKTetris#licence")
        if url != nil {
            #if os(macOS)
            NSWorkspace.shared.open(url!)
            #else
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            #endif
        }
    }
    
    func nextFocusTarget(forDirection direction: FocusDirection, fromFocusTarget: ButtonNode) -> ButtonNode? {
        #if os(tvOS)
        return nil
        #else
        switch (direction, fromFocusTarget) {
        case (.down, playButton):
            return creditsButton
        case (.up, creditsButton):
            return playButton
        default:
            return nil
        }
        #endif
    }
    
}
