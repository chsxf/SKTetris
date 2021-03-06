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
		
		let tallPiece = BlockTools.generatePiece(.row)
		addChild(tallPiece)
		
		let squaredPiece = BlockTools.generatePiece(.square)
		squaredPiece.position = CGPoint(x: -64, y: 0)
		addChild(squaredPiece)
		
		let jShapedPiece = BlockTools.generatePiece(.jShaped)
		jShapedPiece.position = CGPoint(x: -96, y: -64)
		addChild(jShapedPiece)

		let lShapedPiece = BlockTools.generatePiece(.lShaped)
		lShapedPiece.position = CGPoint(x: -64, y: -64)
		addChild(lShapedPiece)

		let sShapedPiece = BlockTools.generatePiece(.sShaped)
		sShapedPiece.position = CGPoint(x: 0, y: -64)
		addChild(sShapedPiece)
		
		let tShapedPiece = BlockTools.generatePiece(.tShaped)
		tShapedPiece.position = CGPoint(x: 64, y: 0)
		addChild(tShapedPiece)
		
		let zShapedPiece = BlockTools.generatePiece(.zShaped)
		zShapedPiece.position = CGPoint(x: 64, y: -64)
		addChild(zShapedPiece)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
