//
//  GameScene.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 04/03/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

	static var grid: GKEntity?
	
	private(set) var blockBlinkComponentSystem = GKComponentSystem(componentClass: BlinkComponent.self)
	
	private(set) var stateMachine: GameStateMachine?
	
	private(set) var currentPiece: GKEntity?
	private(set) var nextPiece: GKEntity?
	
	private var nextPieceRoot: SKNode?
    
	private var gameOverContainer: SKNode?
    private var pauseContainer: SKNode?
    private var uiContainer: GameUIContainerNode?
    private var optionsContainer: SKNode?
    private var mainTitleContainer: SKNode?
    
    private var currentTime: TimeInterval = 0
	private var deltaTime: TimeInterval = 0
	
	private var scoreManager: ScoreManager?
    
    public override var isPaused: Bool {
        didSet {
            ButtonManager.update()
            FocusManager.update()
        }
    }
    
    public var isInMenu: Bool {
        get { uiContainer!.isHidden }
    }
    
	required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        SoundManager.onSoundFinishedPlaying.on(onSoundFinishedPlaying(_:))
        
        stateMachine = GameStateMachine(withScene: self)
        ButtonManager.scene = self
        
        scaleMode = .aspectFit
        
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: 0, y: 0)
        addChild(cameraNode)
        camera = cameraNode
        
        nextPieceRoot = childNode(withName: "//Next Piece Root")
        
        gameOverContainer = childNode(withName: "//Game Over Container")
        uiContainer = childNode(withName: "//Game UI Container") as? GameUIContainerNode
        optionsContainer = childNode(withName: "//Options UI Container")
        mainTitleContainer = childNode(withName: "//Main Title Container")

        pauseContainer = childNode(withName: "//Pause Container")
        pauseContainer!.isHidden = true
       
        let scoreLabel = childNode(withName: "//Score Container")! as! ValueDisplayNode
        let levelLabel = childNode(withName: "//Level Container")! as! ValueDisplayNode
        scoreManager = ScoreManager(withScoreLabel: scoreLabel, andLevelLevel: levelLabel)
        scoreManager?.onLevelChanged.on({ _newLevel in
            SoundManager.play(.newLevel)
        })
        
        let resolutionState = stateMachine!.state(forClass: GameResolutionState.self)
        resolutionState?.onLinesCompleted.on(scoreManager!.pushLines)
        
        isUserInteractionEnabled = true
	}
	
    func spawnNextPiece() -> Void {
		let newPiece = PieceComponent.createPieceEntity(ofType: .randomType())
		nextPiece = newPiece
		
		let pieceNode = newPiece.component(ofType: GKSKNodeComponent.self)!.node
		let pieceRect = pieceNode.calculateAccumulatedFrame()
		pieceNode.position = CGPoint(
			x: -(pieceRect.minX + pieceRect.width / 2.0),
			y: -(pieceRect.minY + pieceRect.height / 2.0)
		)
		nextPieceRoot!.addChild(pieceNode)
	}
	
	func dropCurrentPiece() -> Void {
		let piece = nextPiece!

		let pieceNode = piece.component(ofType: GKSKNodeComponent.self)!.node
		pieceNode.position = CGPoint()
		
		pieceNode.removeFromParent()
        GameScene.grid!.component(ofType: GKSKNodeComponent.self)!.node.addChild(pieceNode)

		let adjustedCoordinates = GameScene.grid!.component(ofType: GridTransformComponent.self)!.getAdjustedCoordinates(forPiece: piece, at: GridCoordinates(x: 5, y: 18))
        let pieceComponent = piece.component(ofType: PieceComponent.self)!
		pieceComponent.setGridCoordinates(adjustedCoordinates)
		
		currentPiece = piece
	}
	
	func landCurrentPiece() -> Void {
		let piece = currentPiece!
		currentPiece = nil
		
		let pieceComponent = piece.component(ofType: PieceComponent.self)!
		
		let gridBlockContainerComponent = GameScene.grid!.component(ofType: GridBlockContainerComponent.self)!
		gridBlockContainerComponent.addBlocks(pieceComponent.blocks)
		
		for block in pieceComponent.blocks {
			blockBlinkComponentSystem.addComponent(foundIn: block)
		}
	}
	
	func removeBlock(_ block: GKEntity) -> Void {
		let gridBlockContainerComponent = GameScene.grid!.component(ofType: GridBlockContainerComponent.self)!
		gridBlockContainerComponent.removeBlock(block)
		
		blockBlinkComponentSystem.removeComponent(foundIn: block)
		
		let skNodeComponent = block.component(ofType: GKSKNodeComponent.self)!
		skNodeComponent.node.removeFromParent()
	}
	
    func showMainTitle() -> Void {
        mainTitleContainer?.isHidden = false
        uiContainer?.isHidden = true
    }
    
    func hideMainTitle() -> Void {
        mainTitleContainer?.isHidden = true
        uiContainer?.isHidden = false
    }
    
    func gameOver() -> Void {
        if SettingsManager.sfxEnabled {
            SoundManager.stop(.backgroundMusic01)
            SoundManager.play(.gameOver)
        }
        
		if nextPiece != nil {
			let skNodeComponent = nextPiece!.component(ofType: GKSKNodeComponent.self)!
			skNodeComponent.node.removeFromParent()
			nextPiece = nil
		}
		
		if currentPiece != nil {
			let skNodeComponent = currentPiece!.component(ofType: GKSKNodeComponent.self)!
            skNodeComponent.node.removeFromParent()
			currentPiece = nil
		}
		
		let gridBlockContainerComponent = GameScene.grid!.component(ofType: GridBlockContainerComponent.self)!
		gridBlockContainerComponent.removeAllBlocks()
		
		uiContainer!.isHidden = true
        gameOverContainer!.isHidden = false
	}
	
	func replay() -> Void {
		gameOverContainer!.isHidden = true
        
		scoreManager!.reset()
		
		stateMachine!.enter(GameIdleState.self)
        
        uiContainer!.isHidden = false
	}
	
    func togglePause(fromController: Bool = false) -> Void {
        if !uiContainer!.isHidden {
            if fromController {
                uiContainer!.switchPauseToggle()
            }
            pauseContainer!.isHidden = !pauseContainer!.isHidden
            isPaused = !isPaused
        }
    }
    
    func toggleOptions() -> Void {
        if mainTitleContainer!.isHidden {
            uiContainer!.isHidden = !uiContainer!.isHidden
            optionsContainer!.isHidden = !optionsContainer!.isHidden
            if pauseContainer!.isHidden {
                isPaused = !isPaused
            }
            else {
                pauseContainer!.isHidden = true
                isPaused = true
            }
        }
    }
    
	override func update(_ currentTime: TimeInterval) {
        ButtonManager.update()
        FocusManager.update()
        
        if isPaused {
            deltaTime = 0
        }
        else if self.currentTime > 0 {
			deltaTime = currentTime - self.currentTime
		}
		self.currentTime = currentTime
	}
	
	override func didFinishUpdate() {
		stateMachine!.update(deltaTime: deltaTime)
		blockBlinkComponentSystem.update(deltaTime: deltaTime)
	}
    
    private func onSoundFinishedPlaying(_ soundKey: SoundKey) {
        if soundKey == .gameOver {
            SoundManager.play(.backgroundMusic01)
        }
    }
	
}
