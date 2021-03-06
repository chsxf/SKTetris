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
		
		showsFPS = true
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
}
