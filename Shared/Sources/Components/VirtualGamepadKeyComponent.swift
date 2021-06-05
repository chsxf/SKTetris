//
//  VirtualGamepadKeyComponent.swift
//  SKTetris
//
//  Created by Christophe on 05/06/2021.
//

import GameplayKit

@objc(VirtualGamepadKeyComponent)
class VirtualGamepadKeyComponent: GKComponent {

    @GKInspectable var rawKey: Int = 1
    
    var key: VirtualGamepadKey? {
        get { VirtualGamepadKey(rawValue: rawKey) }
    }
    
    override class var supportsSecureCoding: Bool { true }
    
}
