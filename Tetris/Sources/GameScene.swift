//
//  GameScene.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 04/03/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

	static private(set) var grid: GKEntity = GKEntity()
	
	private(set) var blockGeometryComponentSystem = GKComponentSystem(componentClass: GeometryComponent.self)
	
	private(set) var stateMachine: GameStateMachine?
	
	private(set) var currentPiece: GKEntity?
	private(set) var nextPiece: GKEntity?
	
	private var gridRoot: SKNode?
	private var nextPieceRoot: SKNode?
	
	private var currentTime: TimeInterval = 0
	private var deltaTime: TimeInterval = 0
	
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
	
	private func initGrid(withRootNode gridRoot: SKNode) -> Void {
		GameScene.grid = GKEntity()
		
		let geometryComponent = GeometryComponent(withNode: gridRoot)
		GameScene.grid.addComponent(geometryComponent)
		
		let gridTransformComponent = GridTransformComponent(size: CGSize(width: 10, height: 18))
		GameScene.grid.addComponent(gridTransformComponent)
		
		let gridBlockContainerComponent = GridBlockContainerComponent()
		GameScene.grid.addComponent(gridBlockContainerComponent)
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
        let pieceComponent = piece.component(ofType: PieceComponent.self)!
		pieceComponent.setGridCoordinates(adjustedCoordinates)
		
		currentPiece = piece
	}
	
	func landCurrentPiece() -> Void {
		let piece = currentPiece!
		currentPiece = nil
		
		let pieceComponent = piece.component(ofType: PieceComponent.self)!
		
		let gridBlockContainerComponent = GameScene.grid.component(ofType: GridBlockContainerComponent.self)!
		gridBlockContainerComponent.addBlocks(pieceComponent.blocks)
		
		for block in pieceComponent.blocks {
			blockGeometryComponentSystem.addComponent(foundIn: block)
		}
	}
	
	func removeBlock(_ block: GKEntity) -> Void {
		let gridBlockContainerComponent = GameScene.grid.component(ofType: GridBlockContainerComponent.self)!
		gridBlockContainerComponent.removeBlock(block)
		
		blockGeometryComponentSystem.removeComponent(foundIn: block)
		
		let geometry = block.component(ofType: GeometryComponent.self)!
		geometry.skNode.removeFromParent()
	}
	
	override func update(_ currentTime: TimeInterval) {
		if (self.currentTime > 0) {
			deltaTime = currentTime - self.currentTime
		}
		self.currentTime = currentTime
	}
	
	override func didFinishUpdate() {
		stateMachine!.update(deltaTime: deltaTime)
		blockGeometryComponentSystem.update(deltaTime: deltaTime)
	}
	
}
