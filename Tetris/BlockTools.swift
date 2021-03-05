//
//  BlockTools.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 05/03/2021.
//

import SpriteKit

class BlockTools {
	public static let BLOCK_SIZE = 16
	
	fileprivate static var _blockAtlas: SKTextureAtlas? = nil
	public static var blockAtlas: SKTextureAtlas {
		get {
			if (_blockAtlas == nil) {
				_blockAtlas = SKTextureAtlas(named: "Main Atlas")
			}
			return _blockAtlas!
		}
	}
	
	public static func generateTallPiece() -> SKNode {
		let blockRoot = SKNode()
		
		let texture = blockAtlas.textureNamed("blocks1")
		texture.filteringMode = .nearest
		for i in 0...3 {
			let sprite = SKSpriteNode(texture: texture)
			sprite.position = CGPoint(x: 0, y: i * BLOCK_SIZE)
			blockRoot.addChild(sprite)
		}
		
		return blockRoot
	}
}
