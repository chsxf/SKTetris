//
//  ButtonNode.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 05/04/2021.
//

import SpriteKit

#if os(macOS)
typealias ButtonColor = NSColor
#else
typealias ButtonColor = UIColor
#endif

class ButtonNode: SKSpriteNode {

	private(set) var onClicked = ParameterlessEventEmitter()
    private(set) var onDown = ParameterlessEventEmitter()
    private(set) var onUp = ParameterlessEventEmitter()
	
	override var isUserInteractionEnabled: Bool {
		get { true }
		set { }
	}

	private var originalColor: ButtonColor? = nil
	private var hoverColor: ButtonColor? = nil
	private var downColor: ButtonColor? = nil
	
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
            
            if oldValue != down {
                if down {
                    onDown.notify(from: self)
                }
                else {
                    onUp.notify(from: self)
                }
            }
		}
	}
	
    var focused: Bool = false {
        didSet { focusNode?.isHidden = !focused }
    }
    
    private var focusNode: SKNode?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ButtonManager.add(button: self)
        
        focusNode = childNode(withName: "Focus Node")
        reset()
    }
    
    func reset() {
        hovered = false
        down = false
        focused = false
    }
	
    func doTrigger() {
        onClicked.notify(from: self)
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
	
    #if os(macOS)
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
    #else
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        down = true
        hovered = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: parent!)
        let rect = calculateAccumulatedFrame()
        hovered = rect.contains(location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: parent!)
        let rect = calculateAccumulatedFrame()
        if down && rect.contains(location) {
            down = false
            hovered = false
            onClicked.notify(from: self)
        }
    }
    #endif
    
}
