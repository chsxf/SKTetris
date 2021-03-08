//
//  GeometryComponent.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 15/03/2021.
//

import GameplayKit
import SpriteKit

class GeometryComponent: GKComponent {

	let skNode: SKNode
	
	init(withNode skNode: SKNode) {
		self.skNode = skNode
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
