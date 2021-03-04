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
		
		backgroundColor = NSColor.gray
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
