//
//  BlockTools.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 05/03/2021.
//

import SpriteKit

class BlockTools {
	
	public static let BLOCK_SIZE = 16
	public static let HALF_BLOCK_SIZE = BLOCK_SIZE >> 1
	
	private static var _blockAtlas: SKTextureAtlas? = nil
	public static var blockAtlas: SKTextureAtlas {
		get {
			if (_blockAtlas == nil) {
				_blockAtlas = SKTextureAtlas(named: "Main Atlas")
				
				for name in _blockAtlas!.textureNames {
					_blockAtlas!.textureNamed(name).filteringMode = .nearest
				}
			}
			return _blockAtlas!
		}
	}
	
	public static func transformCoordinatesFromGridToScene(_ coordinates: GridCoordinates) -> CGPoint {
		var point = coordinates.toCGPoint()
		point = point.applying(CGAffineTransform.init(scaleX: CGFloat(BLOCK_SIZE), y: CGFloat(BLOCK_SIZE)))
		point = point.applying(CGAffineTransform.init(translationX: CGFloat(HALF_BLOCK_SIZE), y: CGFloat(HALF_BLOCK_SIZE)))
		return point
	}
}
