//
//  BlockTransformComponent.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 06/03/2021.
//

import GameplayKit

class BlockTransformComponent: GKComponent {

	var coordinates: GridCoordinates {
		didSet {
			updateNodePosition()
		}
	}
		
	init(atCoordinates coordinates: GridCoordinates) {
		self.coordinates = coordinates
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func didAddToEntity() {
		super.didAddToEntity()
		
		updateNodePosition()
	}
	
	private func updateNodePosition() -> Void {
		entity!.component(ofType: GeometryComponent.self)!.skNode.position = BlockTools.transformCoordinatesFromGridToScene(coordinates)
	}
	
}
