//
//  ButtonManager.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 26/04/2021.
//

import SpriteKit

typealias TrackingAreaData = (trackingArea: NSTrackingArea?, inUse: Bool)

class ButtonManager {
    
    static var scene: SKScene?
    
    private static var buttons = [ButtonNode]()
    private static var trackingAreas: [ButtonNode:NSTrackingArea] = [:]
    
    static func addButton(_ button: ButtonNode) -> Void {
        if !buttons.contains(button) {
            buttons.append(button)
        }
    }
    
    static func removeButton(_ button: ButtonNode) -> Void {
        if buttons.contains(button) {
            if let trackingArea = trackingAreas[button] {
                scene?.view?.removeTrackingArea(trackingArea)
            }
            trackingAreas[button] = nil
            buttons.removeAll { item in
                item == button
            }
        }
    }
    
    static func updateButtons(invalidateTrackingAreas: Bool) -> Void {
        if scene?.view == nil {
            return
        }
        
        let gameView = scene!.view! as! GameView
        
        if invalidateTrackingAreas {
            for (_, trackingArea) in trackingAreas {
                gameView.removeTrackingArea(trackingArea)
            }
            trackingAreas = [:]
        }
        
        for button in buttons {
            let trackingArea = trackingAreas[button]
            
            let buttonIsVisible = !button.isHiddenInHierarchy
            if buttonIsVisible {
                if trackingArea == nil {
                    trackingAreas[button] = gameView.addTrackingArea(fromNode: button)
                }
            }
            else if trackingArea != nil {
                button.reset()
                gameView.removeTrackingArea(trackingArea!)
                trackingAreas[button] = nil
            }
        }
    }
    
}
