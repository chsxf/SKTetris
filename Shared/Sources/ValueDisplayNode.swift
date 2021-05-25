//
//  ValueDislayNode.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 25/05/2021.
//

import SpriteKit

class ValueDisplayNode: SKNode {

    private var valueLabel: SKLabelNode?
    
    var text: String? {
        get { valueLabel?.text }
        set { valueLabel?.text = newValue }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        valueLabel = childNode(withName: "Value Anchor/Value Label") as? SKLabelNode
    }
    
}
