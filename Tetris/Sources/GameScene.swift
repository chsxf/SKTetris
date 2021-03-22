//
//  GameScene.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 04/03/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

	static fileprivate(set) var grid: GKEntity = GKEntity()
	
	fileprivate(set) var stateMachine: GameStateMachine?
	
	fileprivate(set) var currentPiece: GKEntity?
	fileprivate(set) var nextPiece: GKEntity?
	
	fileprivate var gridRoot: SKNode?
	fileprivate var nextPieceRoot: SKNode?
	
	fileprivate var currentTime: TimeInterval = 0
	fileprivate var deltaTime: TimeInterval = 0
	
	override init(size: CGSize) {
		super.init(size: size)
		
		stateMachine = GameStateMachine(withScene: self)
		
		scaleMode = .aspectFit
		
		let cameraNode = SKCameraNode()
		cameraNode.position = CGPoint(x: 0, y: 0)
		addChild(cameraNode)
		camera = cameraNode
		
		backgroundColor = NSColor.gray
        
		let set = SKReferenceNode(fileNamed: "Background")!
		addChild(set)
		
		gridRoot = set.childNode(withName: "//Grid Root")
		initGrid(withRootNode: gridRoot!)
		
		nextPieceRoot = set.childNode(withName: "//Next Piece Root")
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func initGrid(withRootNode gridRoot: SKNode) -> Void {
		let geometryComponent = GeometryComponent(withNode: gridRoot)
		GameScene.grid.addComponent(geometryComponent)
		
		let gridTransformComponent = GridTransformComponent(size: CGSize(width: 10, height: 18))
		GameScene.grid.addComponent(gridTransformComponent)
	}
	
	func spawnNextPiece() -> Void {
		let newPiece = PieceComponent.createPieceEntity(ofType: .randomType())
		nextPiece = newPiece
		
		let pieceNode = newPiece.component(ofType: GeometryComponent.self)!.skNode
		let pieceRect = pieceNode.calculateAccumulatedFrame()
		pieceNode.position = CGPoint(
			x: -(pieceRect.minX + pieceRect.width / 2.0),
			y: -(pieceRect.minY + pieceRect.height / 2.0)
		)
		nextPieceRoot!.addChild(pieceNode)
	}
	
	func dropCurrentPiece() -> Void {
		let piece = nextPiece!
		let pieceNode = piece.component(ofType: GeometryComponent.self)!.skNode
		pieceNode.position = CGPoint()
		
		pieceNode.removeFromParent()
		gridRoot!.addChild(pieceNode)
		
		let adjustedCoordinates = GameScene.grid.component(ofType: GridTransformComponent.self)!.getAdjustedCoordinates(forPiece: piece, at: GridCoordinates(x: 5, y: 18))
		piece.component(ofType: PieceComponent.self)!.setGridCoordinates(adjustedCoordinates)
		
		currentPiece = piece
	}
	
	override func update(_ currentTime: TimeInterval) {
		deltaTime = currentTime - self.currentTime
		self.currentTime = currentTime
	}
	
	override func didFinishUpdate() {
		stateMachine!.update(deltaTime: deltaTime)
	}
	
}
