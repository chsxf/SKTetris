//
//  GameView.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 04/03/2021.
//

import Cocoa
import SpriteKit

class GameView: SKView {

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		
		let gameScene = GameScene(size: frameRect.size)
		presentScene(gameScene)
		
		let set = SKReferenceNode(fileNamed: "Background")
		gameScene.addChild(set!)
		
		let tallPiece = BlockTools.generatePiece(.row)
		gameScene.addChild(tallPiece)
		
		let squaredPiece = BlockTools.generatePiece(.square)
		squaredPiece.position = CGPoint(x: -64, y: 0)
		gameScene.addChild(squaredPiece)
		
		let jShapedPiece = BlockTools.generatePiece(.jShaped)
		jShapedPiece.position = CGPoint(x: -96, y: -64)
		gameScene.addChild(jShapedPiece)

		let lShapedPiece = BlockTools.generatePiece(.lShaped)
		lShapedPiece.position = CGPoint(x: -64, y: -64)
		gameScene.addChild(lShapedPiece)

		let sShapedPiece = BlockTools.generatePiece(.sShaped)
		sShapedPiece.position = CGPoint(x: 0, y: -64)
		gameScene.addChild(sShapedPiece)
		
		let tShapedPiece = BlockTools.generatePiece(.tShaped)
		tShapedPiece.position = CGPoint(x: 64, y: 0)
		gameScene.addChild(tShapedPiece)
		
		let zShapedPiece = BlockTools.generatePiece(.zShaped)
		zShapedPiece.position = CGPoint(x: 64, y: -64)
		gameScene.addChild(zShapedPiece)
		
		showsFPS = true
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
}
