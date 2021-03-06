//
//  BlockTransformComponent.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 06/03/2021.
//

import GameplayKit

class BlockTransformComponent: GKComponent {

	private let skNode: SKNode
	
	init(withBlockSKNode skNode: SKNode) {
		self.skNode = skNode
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func turnLeft() -> Void {
		let oldPosition = skNode.position
		let newPosition = CGPoint(x: -oldPosition.y, y: oldPosition.x)
		skNode.position = newPosition
	}
	
	func turnRight() -> Void {
		let oldPosition = skNode.position
		let newPosition = CGPoint(x: oldPosition.y, y: -oldPosition.x)
		skNode.position = newPosition
	}
	
}
