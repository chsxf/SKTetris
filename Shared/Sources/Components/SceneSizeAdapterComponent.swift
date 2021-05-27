//
//  SceneSizeAdapterComponent.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 29/05/2021.
//

import GameplayKit

@objc(SceneSizeAdapterComponent)
class SceneSizeAdapterComponent: GKComponent {

    @GKInspectable var adaptHorizontally: Bool = true
    @GKInspectable var adaptVertially: Bool = true
    
    override class var supportsSecureCoding: Bool { true }
    
    func adaptTo(size: CGSize) {
        guard let spriteNode = entity?.component(ofType: GKSKNodeComponent.self)?.node as? SKSpriteNode else {
            return
        }
        
        var newSize = spriteNode.size
        if adaptHorizontally {
            newSize.width = size.width
        }
        if adaptVertially {
            newSize.height = size.height
        }
        spriteNode.size = newSize
    }
    
}
