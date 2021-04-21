//
//  GridCoordinates.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 14/03/2021.
//

import CoreGraphics

struct GridCoordinates : Equatable {
	var x: Int
	var y: Int
	
	init(x: Int = 0, y: Int = 0) {
		self.x = x
		self.y = y
	}
	
	func toCGPoint() -> CGPoint {
		return CGPoint(x: x, y: y)
	}
	
	static func + (left: GridCoordinates, right: GridCoordinates) -> GridCoordinates {
		return GridCoordinates(x: left.x + right.x, y: left.y + right.y)
	}
	
	static func - (left: GridCoordinates, right: GridCoordinates) -> GridCoordinates {
		return GridCoordinates(x: left.x - right.x, y: left.y - right.y)
	}
    
    static func += (left: inout GridCoordinates, right: GridCoordinates) -> Void {
        left = left + right
    }
    
    static func -= (left: inout GridCoordinates, right: GridCoordinates) -> Void {
        left = left - right
    }
}
