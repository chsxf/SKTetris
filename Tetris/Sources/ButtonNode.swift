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

	var originalColor: NSColor? = nil
	var focusColor: NSColor? = nil
	var downColor: NSColor? = nil
	
	var focused: Bool = false {
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
	
	override func mouseDown(with event: NSEvent) {
		down = true
	}
	
	override func mouseUp(with event: NSEvent) {
		down = false
		if focused {
			onClicked.notify()
		}
	}
	
	override func mouseEntered(with event: NSEvent) {
		focused = true
	}
	
	override func mouseExited(with event: NSEvent) {
		focused = false
	}
	
	private func ensureInitColors() {
		if originalColor == nil {
			originalColor = color
			focusColor = color.highlight(withLevel: 0.5)
			downColor = color.shadow(withLevel: 0.5)
		}
	}
	
	private func applyColor() {
		color = focused ? (down ? downColor! : focusColor!) : originalColor!
	}
	
}
