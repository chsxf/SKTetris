//
//  ButtonNode.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 05/04/2021.
//

import SpriteKit

class ButtonNode: SKSpriteNode {

	private(set) var onClicked = ParameterlessEventEmitter()
	
	override var isUserInteractionEnabled: Bool {
		get { true }
		set { }
	}

	private var originalColor: NSColor? = nil
	private var hoverColor: NSColor? = nil
	private var downColor: NSColor? = nil
	
	var hovered: Bool = false {
		didSet {
			ensureInitColors()
			applyColor()
		}
	}
	
	var down: Bool = false {
		didSet {
			ensureInitColors()
			applyColor()
		}
	}
	
    func reset() {
        hovered = false
        down = false
    }
    
    override func mouseDown(with event: NSEvent) {
		down = true
	}
	
	override func mouseUp(with event: NSEvent) {
		down = false
		if hovered {
			onClicked.notify()
		}
	}
	
	override func mouseEntered(with event: NSEvent) {
		hovered = true
	}
	
	override func mouseExited(with event: NSEvent) {
		hovered = false
	}
	
	private func ensureInitColors() {
		if originalColor == nil {
			originalColor = color
			hoverColor = color.highlight(withLevel: 0.5)
			downColor = color.shadow(withLevel: 0.5)
		}
	}
	
	private func applyColor() {
		color = hovered ? (down ? downColor! : hoverColor!) : originalColor!
	}
	
}
