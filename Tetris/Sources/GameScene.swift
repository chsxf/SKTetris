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
	
	private(set) var currentPiece: GKEntity?
	
	override init(size: CGSize) {
		super.init(size: size)
		
		scaleMode = .aspectFit
		
		let cameraNode = SKCameraNode()
		cameraNode.position = CGPoint(x: 0, y: 0)
		addChild(cameraNode)
		camera = cameraNode
		
		backgroundColor = NSColor.gray
        
		let set = SKReferenceNode(fileNamed: "Background")!
		addChild(set)
		
		let gridRoot = set.childNode(withName: "//Grid Root")!
		initGrid(withRootNode: gridRoot)
		
		let newPiece = PieceComponent.createPieceEntity(ofType: .randomType())
		currentPiece = newPiece
		gridRoot.addChild(newPiece.component(ofType: GeometryComponent.self)!.skNode)
		
		let adjustedCoordinates = GameScene.grid.component(ofType: GridTransformComponent.self)!.getAdjustedCoordinates(forPiece: newPiece, at: GridCoordinates(x: 10, y: 18))
		newPiece.component(ofType: PieceComponent.self)!.setGridCoordinates(adjustedCoordinates)
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
	
}
