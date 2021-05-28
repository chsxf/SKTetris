//
//  PieceComponent.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 06/03/2021.
//

import GameplayKit
import SpriteKit

class PieceComponent: GKComponent {

    private let MOVE_TIME_INTERVAL = 0.15
    private let NORMAL_FALL_TIME_INTERVAL = 1.0
    private let SPEDUP_FALL_TIME_INTERVAL = 0.1

    let model: PieceModel
	
	var canRotate: Bool { model.type != .square }
	
    private var isSpedUp = false
    
    private var movingLeft = false
    private var movingRight = false
    
    private var lastMoveTimeBuffer = 0.0
    private var lastFallTimeBuffer = 0.0
    
    let pieceHasLanded = ParameterlessEventEmitter()
    
    var coordinatesBuffer = [GridCoordinates](repeating: GridCoordinates(), count: 4)
    
	var gridBounds: GridBounds {
		get {
			var bounds = GridBounds(x: 0, y: 0, width: 0, height: 0)
			for block in blocks {
				let transform = block.component(ofType: BlockTransformComponent.self)!
				bounds = bounds.encapsulate(GridBounds(bottomLeft: transform.coordinates))
			}
			return bounds
		}
	}
	
    private var fallTimeInterval: Double {
        get { return isSpedUp ? SPEDUP_FALL_TIME_INTERVAL : NORMAL_FALL_TIME_INTERVAL }
    }
    
	private(set) var blocks = [GKEntity]()
	
	init(ofType type: PieceType) {
		model = PieceModel(withType: type)
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func turnLeft() -> Void {
		if canRotate {
            let pivotTransform = blocks[0].component(ofType: BlockTransformComponent.self)!
            let pivotCoordinates = pivotTransform.coordinates
            var newCoordinateList = [GridCoordinates]()
            newCoordinateList.append(pivotCoordinates)
            for i in 1..<blocks.count {
                let transform = blocks[i].component(ofType: BlockTransformComponent.self)!
				let oldCoordinates = transform.coordinates - pivotCoordinates
				let newCoordinates = GridCoordinates(x: -oldCoordinates.y, y: oldCoordinates.x)
                newCoordinateList.append(newCoordinates + pivotCoordinates)
			}
            
            let gridComponent = GameScene.grid!.component(ofType: GridBlockContainerComponent.self)!
            if gridComponent.validateCoordinates(coordinatesList: newCoordinateList) {
                for i in 0..<newCoordinateList.count {
                    blocks[i].component(ofType: BlockTransformComponent.self)!.coordinates = newCoordinateList[i]
                }
                
                SoundManager.play(.brickRotate)
            }
		}
	}
	
	func turnRight() -> Void {
		if canRotate {
            let pivotTransform = blocks[0].component(ofType: BlockTransformComponent.self)!
            let pivotCoordinates = pivotTransform.coordinates
            var newCoordinateList = [GridCoordinates]()
            newCoordinateList.append(pivotCoordinates)
            for i in 1..<blocks.count {
				let transform = blocks[i].component(ofType: BlockTransformComponent.self)!
				let oldCoordinates = transform.coordinates - pivotCoordinates
				let newCoordinates = GridCoordinates(x: oldCoordinates.y, y: -oldCoordinates.x)
                newCoordinateList.append(newCoordinates + pivotCoordinates)
			}
            
            let gridComponent = GameScene.grid!.component(ofType: GridBlockContainerComponent.self)!
            if gridComponent.validateCoordinates(coordinatesList: newCoordinateList) {
                for i in 0..<newCoordinateList.count {
                    blocks[i].component(ofType: BlockTransformComponent.self)!.coordinates = newCoordinateList[i]
                }
                
                SoundManager.play(.brickRotate)
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
			let transform = blocks[i].component(ofType: BlockTransformComponent.self)!
			
			transform.coordinates = offset + coordinates
		}
	}
	
	private func generateBlockEntities() -> Void {
        guard let rootNode = entity?.component(ofType: GKSKNodeComponent.self)?.node else {
            return
        }
		
		let texture = BlockTools.mainAtlas.textureNamed(model.type.textureName)
		for offset in model.gridOffsets {
			let sprite = SKSpriteNode(texture: texture)

			let blockEntity = GKEntity()
			let skNodeComponent = GKSKNodeComponent(node: sprite)
			blockEntity.addComponent(skNodeComponent)
            blockEntity.addComponent(BlinkComponent())
			let blockComponent = BlockTransformComponent(atCoordinates: offset)
			blockEntity.addComponent(blockComponent)

			rootNode.addChild(sprite)
			blocks.append(blockEntity)
		}
	}
	
    override func update(deltaTime seconds: TimeInterval) {
        let grid = GameScene.grid!.component(ofType: GridBlockContainerComponent.self)!
        var validUpdate = true
        
        for i in 0..<blocks.count {
            let transform = blocks[i].component(ofType: BlockTransformComponent.self)!
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
                    for i in 0..<blocks.count {
                        let transform = blocks[i].component(ofType: BlockTransformComponent.self)!
                        coordinatesBuffer[i] = transform.coordinates
                    }
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
                let transform = blocks[i].component(ofType: BlockTransformComponent.self)!
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
        
		let skNodeComponent = GKSKNodeComponent(node: rootNode)
		entity.addComponent(skNodeComponent)
		
		let pieceComponent = PieceComponent(ofType: type)
		entity.addComponent(pieceComponent)
		
		return entity
	}
	
}
