//
//  GridTransformComponent.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 07/03/2021.
//

import GameplayKit

class GridTransformComponent: GKComponent {

	private let size: CGSize
	
	init(size: CGSize) {
		self.size = size
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    func getAdjustedCoordinates(forPiece piece: GKEntity, at coordinates: GridCoordinates) -> GridCoordinates {
		let pieceComponent = piece.component(ofType: PieceComponent.self)!
		let gridBounds = pieceComponent.gridBounds.offset(coordinates)
		
		var newX = coordinates.x
		var newY = coordinates.y
		if (gridBounds.bottomLeft.x < 0) {
			newX += -gridBounds.bottomLeft.x
		}
		if (gridBounds.bottomLeft.y < 0) {
			newY += -gridBounds.bottomLeft.y
		}
		if (gridBounds.topRight.x > Int(size.width)) {
			newX -= gridBounds.topRight.x - Int(size.width)
		}
		if (gridBounds.topRight.y > Int(size.height)) {
			newY -= gridBounds.topRight.y - Int(size.height)
		}
		
		return GridCoordinates(x: newX, y: newY)
	}
    
    func validateCoordinates(coordinatesList: [GridCoordinates]) -> Bool {
        for coordinate in coordinatesList {
            if coordinate.x < 0 || coordinate.x >= Int(size.width) || coordinate.y < 0 || coordinate.y >= Int(size.height) {
                return false
            }
        }
        return true
    }
	
}
