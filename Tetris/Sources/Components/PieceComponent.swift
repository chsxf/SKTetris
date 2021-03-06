//
//  PieceComponent.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 06/03/2021.
//

import GameplayKit

class PieceComponent: GKComponent {

	fileprivate let _skNode: SKNode
	var skNode: SKNode { _skNode }
	
	init(ofType type: PieceType) {
		_skNode = BlockTools.generatePiece(type)
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
