//
//  GeometryComponent.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 15/03/2021.
//

import GameplayKit
import SpriteKit

class GeometryComponent: GKComponent {

	private let BLINK_TIME_INTERVAL = 0.1
	private let MAX_BLINK_PHASE = 10
	
	let skNode: SKNode
	
	var blinking = false
	private var blinkTimeBuffer: TimeInterval = 0
	private var blinkPhase = 0
	
	init(withNode skNode: SKNode) {
		self.skNode = skNode
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func update(deltaTime seconds: TimeInterval) {
		if blinking {
			blinkTimeBuffer += seconds
			while blinkTimeBuffer > BLINK_TIME_INTERVAL && blinkPhase < MAX_BLINK_PHASE {
				blinkTimeBuffer -= BLINK_TIME_INTERVAL
				blinkPhase = min(blinkPhase + 1, MAX_BLINK_PHASE)
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
