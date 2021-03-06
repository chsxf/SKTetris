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
				
				for name in _blockAtlas!.textureNames {
					_blockAtlas!.textureNamed(name).filteringMode = .nearest
				}
			}
			return _blockAtlas!
		}
	}
	
	public static func generateTallPiece() -> SKNode {
		let blockRoot = SKNode()
		
		let texture = blockAtlas.textureNamed("blocks1")
		var coordinates = [CGPoint]()
		for i in 0...3 {
			coordinates.append(CGPoint(x: 0, y: i))
		}
		generateBlocks(atCoordinates: coordinates, withTexture: texture, inParent: blockRoot)
		
		return blockRoot
	}
	
	public static func generateTShapedPiece() -> SKNode {
		let blockRoot = SKNode()
		
		let texture = blockAtlas.textureNamed("blocks2")
		let coordinates = [ CGPoint(), CGPoint(x: -1, y: 0), CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1) ]
		generateBlocks(atCoordinates: coordinates, withTexture: texture, inParent: blockRoot)
		
		return blockRoot
	}
	
	public static func generateSquaredPiece() -> SKNode {
		let blockRoot = SKNode()
		
		let texture = blockAtlas.textureNamed("blocks3")
		let coordinates = [ CGPoint(), CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 1) ]
		generateBlocks(atCoordinates: coordinates, withTexture: texture, inParent: blockRoot)
		
		return blockRoot
	}
	
	public static func generateSShapedPiece() -> SKNode {
		let blockRoot = SKNode()
		
		let texture = blockAtlas.textureNamed("blocks4")
		let coordinates = [ CGPoint(), CGPoint(x: -1, y: 0), CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 1) ]
		generateBlocks(atCoordinates: coordinates, withTexture: texture, inParent: blockRoot)
		
		return blockRoot
	}
	
	public static func generateZShapedPiece() -> SKNode {
		let blockRoot = SKNode()
		
		let texture = blockAtlas.textureNamed("blocks5")
		let coordinates = [ CGPoint(), CGPoint(x: -1, y: 1), CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 0) ]
		generateBlocks(atCoordinates: coordinates, withTexture: texture, inParent: blockRoot)
		
		return blockRoot
	}
	
	public static func generateLShapedPiece() -> SKNode {
		let blockRoot = SKNode()
		
		let texture = blockAtlas.textureNamed("blocks6")
		let coordinates = [ CGPoint(), CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1), CGPoint(x: 0, y: 2) ]
		generateBlocks(atCoordinates: coordinates, withTexture: texture, inParent: blockRoot)
		
		return blockRoot
	}
	
	public static func generateJShapedPiece() -> SKNode {
		let blockRoot = SKNode()
		
		let texture = blockAtlas.textureNamed("blocks7")
		let coordinates = [ CGPoint(), CGPoint(x: -1, y: 0), CGPoint(x: 0, y: 1), CGPoint(x: 0, y: 2) ]
		generateBlocks(atCoordinates: coordinates, withTexture: texture, inParent: blockRoot)
		
		return blockRoot
	}
	
	public static func generateBlocks(atCoordinates blockCoordinates: [CGPoint], withTexture texture: SKTexture, inParent parent: SKNode) {
		for point: CGPoint in blockCoordinates {
			let sprite = SKSpriteNode(texture: texture)
			sprite.position = point.applying(CGAffineTransform.init(scaleX: CGFloat(BLOCK_SIZE), y: CGFloat(BLOCK_SIZE)))
			parent.addChild(sprite)
		}
	}
}
