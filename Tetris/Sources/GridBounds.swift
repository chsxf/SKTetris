//
//  GridBounds.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 20/03/2021.
//

struct GridBounds: CustomStringConvertible {
	var bottomLeft: GridCoordinates
	var topRight: GridCoordinates
	
	var width: UInt { UInt(abs(topRight.x - bottomLeft.x)) }
	var height: UInt { UInt(abs(topRight.y - bottomLeft.y)) }
	
	var description: String { "GridBounds(bottomLeft: (\(bottomLeft.x), \(bottomLeft.y)), size: (\(width), \(height)))" }
		
	init(bottomLeft: GridCoordinates, width: UInt = 1, height: UInt = 1) {
		self.bottomLeft = bottomLeft
		topRight = GridCoordinates(x: bottomLeft.x + Int(width), y: bottomLeft.y + Int(height))
	}
	
	init(x: Int, y: Int, width: UInt = 1, height: UInt = 1) {
		bottomLeft = GridCoordinates(x: x, y: y)
		topRight = GridCoordinates(x: x + Int(width), y: y + Int(height))
	}
	
	init(bottomLeft: GridCoordinates, topRight: GridCoordinates) {
		self.bottomLeft = bottomLeft
		self.topRight = topRight
	}
	
	func encapsulate(_ otherBounds: GridBounds) -> GridBounds {
		return GridBounds(
			bottomLeft: GridCoordinates(x: min(bottomLeft.x, otherBounds.bottomLeft.x), y: min(bottomLeft.y, otherBounds.bottomLeft.y)),
			topRight: GridCoordinates(x: max(topRight.x, otherBounds.topRight.x), y: max(topRight.y, otherBounds.topRight.y))
		)
	}
	
	func offset(_ amount: GridCoordinates) -> GridBounds {
		return GridBounds(bottomLeft: bottomLeft + amount, topRight: topRight + amount)
	}
	
}
