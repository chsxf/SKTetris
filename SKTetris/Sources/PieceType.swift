//
//  PieceType.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 06/03/2021.
//

enum PieceType: String, CaseIterable {
	case jShaped, lShaped, row, square, sShaped, tShaped, zShaped
	
	var textureName: String { "blocks_\(self.rawValue)" }
	
	static func randomType() -> PieceType {
		let values = PieceType.allCases
		return values[Int.random(in: 0..<values.count)]
	}
}
