//
//  GameScene.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 04/03/2021.
//

import Cocoa
import SpriteKit

class GameScene: SKScene {

	override init(size: CGSize) {
		super.init(size: size)
		
		let cameraNode = SKCameraNode()
		cameraNode.position = CGPoint(x: 0, y: 0)
		addChild(cameraNode)
		camera = cameraNode
		
		backgroundColor = NSColor.gray
		
		let tallPiece = BlockTools.generateTallPiece()
		addChild(tallPiece)
		
		let tShapedPiece = BlockTools.generateTShapedPiece()
		tShapedPiece.position = CGPoint(x: 64, y: 0)
		addChild(tShapedPiece)
		
		let squaredPiece = BlockTools.generateSquaredPiece()
		squaredPiece.position = CGPoint(x: -64, y: 0)
		addChild(squaredPiece)
		
		let sShapedPiece = BlockTools.generateSShapedPiece()
		sShapedPiece.position = CGPoint(x: 0, y: -64)
		addChild(sShapedPiece)
		
		let zShapedPiece = BlockTools.generateZShapedPiece()
		zShapedPiece.position = CGPoint(x: 64, y: -64)
		addChild(zShapedPiece)
		
		let lShapedPiece = BlockTools.generateLShapedPiece()
		lShapedPiece.position = CGPoint(x: -64, y: -64)
		addChild(lShapedPiece)
		
		let jShapedPiece = BlockTools.generateJShapedPiece()
		jShapedPiece.position = CGPoint(x: -96, y: -64)
		addChild(jShapedPiece)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
