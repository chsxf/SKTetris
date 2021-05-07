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
	
	private static var _mainAtlas: SKTextureAtlas? = nil
	public static var mainAtlas: SKTextureAtlas {
		get {
			if (_mainAtlas == nil) {
				_mainAtlas = SKTextureAtlas(named: "Main Atlas")
			}
            for name in _mainAtlas!.textureNames {
                _mainAtlas!.textureNamed(name).filteringMode = .nearest
            }
			return _mainAtlas!
		}
	}
	
	public static func transformCoordinatesFromGridToScene(_ coordinates: GridCoordinates) -> CGPoint {
		var point = coordinates.toCGPoint()
		point = point.applying(CGAffineTransform.init(scaleX: CGFloat(BLOCK_SIZE), y: CGFloat(BLOCK_SIZE)))
		point = point.applying(CGAffineTransform.init(translationX: CGFloat(HALF_BLOCK_SIZE), y: CGFloat(HALF_BLOCK_SIZE)))
		return point
	}
}
