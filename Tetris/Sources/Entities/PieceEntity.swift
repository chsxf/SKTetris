//
//  PieceEntity.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 06/03/2021.
//

import GameplayKit

class PieceEntity: GKEntity {

	private var subEntities = [BlockEntity]()
	
	var skNode: SKNode { component(ofType: PieceComponent.self)!.skNode }
	
	init(ofType type: PieceType) {
		super.init()
		
		let pieceComponent = PieceComponent(ofType: type)
		addComponent(pieceComponent)
		
		for child in pieceComponent.skNode.children {
			subEntities.append(BlockEntity(withBlockSKNode: child))
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func turnLeft() -> Void {
		for entity in subEntities {
			let transformComponent = entity.component(ofType: BlockTransformComponent.self)
			transformComponent?.turnLeft()
		}
	}
	
	func turnRight() -> Void {
		for entity in subEntities {
			let transformComponent = entity.component(ofType: BlockTransformComponent.self)
			transformComponent?.turnRight()
		}
	}
	
}
