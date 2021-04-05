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
	
	func removeBlock(_ block: GKEntity) -> Void {
		blocks.removeAll(where: { $0 === block })
	}
	
	func removeAllBlocks() -> Void {
		for block in blocks {
			let geometry = block.component(ofType: GeometryComponent.self)!
			geometry.skNode.removeFromParent()
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
