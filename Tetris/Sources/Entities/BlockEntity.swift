//
//  BlockEntity.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 06/03/2021.
//

import GameplayKit

class BlockEntity: GKEntity {
	
	init(withBlockSKNode skNode: SKNode) {
		super.init()
		
		addComponent(BlockTransformComponent(withBlockSKNode: skNode))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
