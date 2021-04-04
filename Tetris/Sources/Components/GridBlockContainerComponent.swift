//
//  GridBlockContainerComponent.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 04/04/2021.
//

import GameplayKit

class GridBlockContainerComponent: GKComponent {

	private var blocks: [GKEntity] = []
	
	func addBlocks(_ newBlocks: [GKEntity]) -> Void {
		let gridGeometryComponent = entity!.component(ofType: GeometryComponent.self)!
		
		for block in newBlocks {
			let blockGeometryComponent = block.component(ofType: GeometryComponent.self)!
			blockGeometryComponent.skNode.removeFromParent()
			gridGeometryComponent.skNode.addChild(blockGeometryComponent.skNode)
			
			self.blocks.append(block)
		}
	}
	
}
