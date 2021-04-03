//
//  PieceComponent.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 06/03/2021.
//

import GameplayKit
import SpriteKit

class PieceComponent: GKComponent {

    fileprivate let MOVE_TIME_INTERVAL = 0.15
    fileprivate let NORMAL_FALL_TIME_INTERVAL = 1.0
    fileprivate let SPEDUP_FALL_TIME_INTERVAL = 0.1

    let model: PieceModel
	
	var canRotate: Bool { model.type != .square }
	
	fileprivate(set) var falling = true
    
    fileprivate var isSpedUp = false
    
    fileprivate var movingLeft = false
    fileprivate var movingRight = false
    
    fileprivate var lastMoveTimeBuffer = 0.0
    fileprivate var lastFallTimeBuffer = 0.0
    
    let pieceHasLanded = SimpleEventEmitter()
    
    var coordinatesBuffer = [GridCoordinates](repeating: GridCoordinates(), count: 4)
    
	var gridBounds: GridBounds {
		get {
			var bounds = GridBounds(x: 0, y: 0, width: 0, height: 0)
			for block in subEntities {
				let transform = block.component(ofType: BlockTransformComponent.self)!
				bounds = bounds.encapsulate(GridBounds(bottomLeft: transform.coordinates))
			}
			return bounds
		}
	}
	
    fileprivate var fallTimeInterval: Double {
        get { return isSpedUp ? SPEDUP_FALL_TIME_INTERVAL : NORMAL_FALL_TIME_INTERVAL }
    }
    
	fileprivate var subEntities = [GKEntity]()
	
	init(ofType type: PieceType) {
		model = PieceModel(withType: type)
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func turnLeft() -> Void {
		if canRotate {
            let pivotTransform = subEntities[0].component(ofType: BlockTransformComponent.self)!
            let pivotCoordinates = pivotTransform.coordinates
            var newCoordinateList = [GridCoordinates]()
            newCoordinateList.append(pivotCoordinates)
            for i in 1..<subEntities.count {
                let transform = subEntities[i].component(ofType: BlockTransformComponent.self)!
				let oldCoordinates = transform.coordinates - pivotCoordinates
				let newCoordinates = GridCoordinates(x: -oldCoordinates.y, y: oldCoordinates.x)
                newCoordinateList.append(newCoordinates + pivotCoordinates)
			}
            
            let gridComponent = GameScene.grid.component(ofType: GridTransformComponent.self)!
            if gridComponent.validateCoordinates(coordinatesList: newCoordinateList) {
                for i in 0..<newCoordinateList.count {
                    subEntities[i].component(ofType: BlockTransformComponent.self)!.coordinates = newCoordinateList[i]
                }
            }
		}
	}
	
	func turnRight() -> Void {
		if canRotate {
            let pivotTransform = subEntities[0].component(ofType: BlockTransformComponent.self)!
            let pivotCoordinates = pivotTransform.coordinates
            var newCoordinateList = [GridCoordinates]()
            newCoordinateList.append(pivotCoordinates)
            for i in 1..<subEntities.count {
				let transform = subEntities[i].component(ofType: BlockTransformComponent.self)!
				let oldCoordinates = transform.coordinates - pivotCoordinates
				let newCoordinates = GridCoordinates(x: oldCoordinates.y, y: -oldCoordinates.x)
                newCoordinateList.append(newCoordinates + pivotCoordinates)
			}
            
            let gridComponent = GameScene.grid.component(ofType: GridTransformComponent.self)!
            if gridComponent.validateCoordinates(coordinatesList: newCoordinateList) {
                for i in 0..<newCoordinateList.count {
                    subEntities[i].component(ofType: BlockTransformComponent.self)!.coordinates = newCoordinateList[i]
                }
            }
		}
	}
	
    func startMovingLeft() -> Void {
        movingLeft = true
        lastMoveTimeBuffer = MOVE_TIME_INTERVAL
    }
    
    func stopMovingLeft() -> Void {
        movingLeft = false
        lastMoveTimeBuffer = 0
    }
    
    func startMovingRight() -> Void {
        movingRight = true
        lastMoveTimeBuffer = MOVE_TIME_INTERVAL
    }
    
    func stopMovingRight() -> Void {
        movingRight = false
        lastMoveTimeBuffer = 0
    }
    
    func speedUp() -> Void {
        isSpedUp = true
    }
    
    func resetSpeed() -> Void {
        isSpedUp = false
    }
    
	override func didAddToEntity() {
		super.didAddToEntity()
		generateBlockEntities()
	}
	
	func setGridCoordinates(_ coordinates: GridCoordinates) -> Void {
		for i in 0..<model.gridOffsets.count {
			let offset = model.gridOffsets[i]
			let transform = subEntities[i].component(ofType: BlockTransformComponent.self)!
			
			transform.coordinates = offset + coordinates
		}
	}
	
	fileprivate func generateBlockEntities() -> Void {
		let rootNode = entity!.component(ofType: GeometryComponent.self)!.skNode
		
		let texture = BlockTools.blockAtlas.textureNamed(model.type.textureName)
		for offset in model.gridOffsets {
			let sprite = SKSpriteNode(texture: texture)

			let blockEntity = GKEntity()
			let geometryComponent = GeometryComponent(withNode: sprite)
			blockEntity.addComponent(geometryComponent)
			let blockComponent = BlockTransformComponent(atCoordinates: offset)
			blockEntity.addComponent(blockComponent)

			rootNode.addChild(sprite)
			subEntities.append(blockEntity)
		}
	}
	
    override func update(deltaTime seconds: TimeInterval) {
        let grid = GameScene.grid.component(ofType: GridTransformComponent.self)!
        var validUpdate = false
        
        for i in 0..<subEntities.count {
            let transform = subEntities[i].component(ofType: BlockTransformComponent.self)!
            coordinatesBuffer[i] = transform.coordinates
        }
        
        if movingLeft != movingRight {
            lastMoveTimeBuffer += seconds
            if lastMoveTimeBuffer > MOVE_TIME_INTERVAL {
                lastMoveTimeBuffer = 0
                var moveOffset: GridCoordinates
                if movingLeft {
                    moveOffset = GridCoordinates(x: -1, y: 0)
                }
                else {
                    moveOffset = GridCoordinates(x: 1, y: 0)
                }
                
                for i in 0..<coordinatesBuffer.count {
                    coordinatesBuffer[i] += moveOffset
                }
                
                if !grid.validateCoordinates(coordinatesList: coordinatesBuffer) {
                    for i in 0..<subEntities.count {
                        let transform = subEntities[i].component(ofType: BlockTransformComponent.self)!
                        coordinatesBuffer[i] = transform.coordinates
                    }
                }
                else {
                    validUpdate = true
                }
            }
        }
        
        lastFallTimeBuffer += seconds
        if lastFallTimeBuffer > fallTimeInterval {
            lastFallTimeBuffer = 0
            
            let fallOffset = GridCoordinates(x: 0, y: -1)
            for i in 0..<coordinatesBuffer.count {
                coordinatesBuffer[i] += fallOffset
            }
            
            validUpdate = grid.validateCoordinates(coordinatesList: coordinatesBuffer)
        }
        
        if validUpdate {
            for i in 0..<coordinatesBuffer.count {
                let transform = subEntities[i].component(ofType: BlockTransformComponent.self)!
                transform.coordinates = coordinatesBuffer[i]
            }
        }
        else {
            pieceHasLanded.notify()
        }
    }
    
	class func createPieceEntity(ofType type: PieceType) -> GKEntity {
		let entity = GKEntity()
		
		let rootNode = SKNode()
		let geometryComponent = GeometryComponent(withNode: rootNode)
		entity.addComponent(geometryComponent)
		
		let pieceComponent = PieceComponent(ofType: type)
		entity.addComponent(pieceComponent)
		
		return entity
	}
	
}
