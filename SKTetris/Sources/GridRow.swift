//
//  GridLine.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 04/04/2021.
//

import GameplayKit

struct GridRow {
	
	let index: Int
	let blocks: [GKEntity]
	
	init(index: Int, blocks: [GKEntity]) {
		self.index = index
		self.blocks = blocks
	}
	
}
