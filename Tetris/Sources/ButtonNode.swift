//
//  ButtonNode.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 05/04/2021.
//

import SpriteKit

class ButtonNode: SKSpriteNode {

	private(set) var onClicked = SimpleEventEmitter()
	
	override var isUserInteractionEnabled: Bool {
		get { true }
		set { }
	}
	
	override func mouseDown(with event: NSEvent) {
		onClicked.notify()
	}
	
}
