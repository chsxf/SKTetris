//
//  GridBlockContainerComponent.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 04/04/2021.
//

import GameplayKit

@objc(GridBlockContainerComponent)
class GridBlockContainerComponent: GKComponent {

	private var blocks: [GKEntity] = []
	
    override class var supportsSecureCoding: Bool { true }
    
	func addBlocks(_ newBlocks: [GKEntity]) -> Void {
		let gridSKNodeComponent = entity!.component(ofType: GKSKNodeComponent.self)!
		
		for block in newBlocks {
			let blockSKNodeComponent = block.component(ofType: GKSKNodeComponent.self)!
			blockSKNodeComponent.node.removeFromParent()
			gridSKNodeComponent.node.addChild(blockSKNodeComponent.node)
			
			self.blocks.append(block)
		}
	}
	
	func removeBlock(_ block: GKEntity) -> Void {
		blocks.removeAll(where: { $0 === block })
	}
	
	func removeAllBlocks() -> Void {
		for block in blocks {
			let skNodeComponent = block.component(ofType: GKSKNodeComponent.self)!
            skNodeComponent.node.removeFromParent()
		}
		blocks.removeAll()
	}
	
	func validateCoordinates(coordinatesList: [GridCoordinates]) -> Bool {
		let gridTransformComponent = entity!.component(ofType: GridTransformComponent.self)!
		let size = gridTransformComponent.size
		
		for coordinate in coordinatesList {
			if coordinate.x < 0 || coordinate.x >= Int(size.width) || coordinate.y < 0 || coordinate.y >= Int(size.height) {
				return false
			}
			
			for block in blocks {
				let transform = block.component(ofType: BlockTransformComponent.self)!
				if transform.coordinates == coordinate {
					return false
				}
			}
		}
		return true
	}
	
	func fallBlocks(aboveIndex minIndex: Int, ofRows countRows: Int) -> Void {
		for block in blocks {
			let transform = block.component(ofType: BlockTransformComponent.self)!
			if transform.coordinates.y >= minIndex {
				let newCoordinates = transform.coordinates - GridCoordinates(x: 0, y: countRows)
				transform.coordinates = newCoordinates
			}
		}
	}
	
	func getFullRows() -> [GridRow]? {
		let gridTransformComponent = entity!.component(ofType: GridTransformComponent.self)!
		let size = gridTransformComponent.size
		
		var rows: [GridRow]? = nil
		
		for y in 0..<Int(size.height) {
			var lineFull = true
			for x in 0..<Int(size.width) {
				let blockCoordinates = GridCoordinates(x: x, y: y)
				let block = getBlockAt(coordinates: blockCoordinates)
				if block == nil {
					lineFull = false
					break
				}
			}
			
			if lineFull {
				var rowBlocks = [GKEntity]()
				for x in 0..<Int(size.width) {
					let blockCoordinates = GridCoordinates(x: x, y: y)
					let block = getBlockAt(coordinates: blockCoordinates)!
					rowBlocks.append(block)
				}
				
				if rows == nil {
					rows = [GridRow]()
				}
				rows!.append(GridRow(index: y, blocks: rowBlocks))
			}
		}
		
		return rows
	}
	
	private func getBlockAt(coordinates: GridCoordinates) -> GKEntity? {
		for block in blocks {
			let transform = block.component(ofType: BlockTransformComponent.self)!
			if transform.coordinates == coordinates {
				return block
			}
		}
		return nil
	}
	
}
