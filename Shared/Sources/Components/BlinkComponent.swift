//
//  BlinkComponent.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 28/05/2021.
//

import GameplayKit

class BlinkComponent: GKComponent {

    private let BLINK_TIME_INTERVAL = 0.1
    private let MAX_BLINK_PHASE = 10
    
    var blinking = false
    private var blinkTimeBuffer: TimeInterval = 0
    private var blinkPhase = 0
    
    override func update(deltaTime seconds: TimeInterval) {
        if blinking {
            blinkTimeBuffer += seconds
            while blinkTimeBuffer > BLINK_TIME_INTERVAL && blinkPhase < MAX_BLINK_PHASE {
                blinkTimeBuffer -= BLINK_TIME_INTERVAL
                blinkPhase = min(blinkPhase + 1, MAX_BLINK_PHASE)
            }
            
            guard let skNode = entity?.component(ofType: GKSKNodeComponent.self)?.node else {
                return
            }
            
            if blinkPhase % 2 == 1 {
                skNode.alpha = 0.5
            }
            else {
                skNode.alpha = 1
            }
        }
    }
    
}
