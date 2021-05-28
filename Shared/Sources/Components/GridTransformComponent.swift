//
//  GridTransformComponent.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 07/03/2021.
//

import GameplayKit

@objc(GridTransformComponent)
class GridTransformComponent: GKComponent {

    @GKInspectable var size: CGSize = CGSize()
	
    override class var supportsSecureCoding: Bool { true }
    
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
    
}
