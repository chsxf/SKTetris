//
//  SKNodeExtension.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 26/04/2021.
//

import SpriteKit

extension SKNode {
    
    var isHiddenInHierarchy: Bool {
        get {
            var node: SKNode? = self
            while node != nil {
                if node!.isHidden {
                    return true
                }
                node = node?.parent
            }
            return false
        }
    }
    
}
