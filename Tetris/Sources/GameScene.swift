//
//  GameScene.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 04/03/2021.
//

import Cocoa
import SpriteKit

class GameScene: SKScene {

	private var currentPiece: PieceEntity?
	
	override init(size: CGSize) {
		super.init(size: size)
		
		scaleMode = .aspectFit
		
		let cameraNode = SKCameraNode()
		cameraNode.position = CGPoint(x: 0, y: 0)
		addChild(cameraNode)
		camera = cameraNode
		
		backgroundColor = NSColor.gray
		
		let set = SKReferenceNode(fileNamed: "Background")
		addChild(set!)
		
		let newPiece = PieceEntity(ofType: .row)
		currentPiece = newPiece
		addChild(newPiece.skNode)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func startMovingCurrentPieceLeft() -> Void {
		
	}
	
	func startMovingCurrentPieceRight() -> Void {
		
	}
	
	func stopMovingPiece() -> Void {
		
	}
	
	func speedUpCurrentPiece() -> Void {
		
	}
	
	func resetSpeedForCurrentPiece() -> Void {
		
	}
	
	func turnCurrentPieceRight() -> Void {
		currentPiece?.turnRight()
	}
	
	func turnCurrentPieceLeft() -> Void {
		currentPiece?.turnLeft()
	}
	
}
