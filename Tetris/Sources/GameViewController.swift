//
//  GameViewController.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 06/03/2021.
//

import Cocoa

class GameViewController: NSViewController {

	fileprivate var sceneView: GameView?
	
	override init(nibName nibNameOrNil: NSNib.Name? = nil, bundle nibBundleOrNil: Bundle? = nil) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func loadView() {
		sceneView = GameView(frame: NSRect(x: 0, y: 0, width: 640, height: 360))
		
		if let sceneView = sceneView {
			view = sceneView
		
			let tallPiece = BlockTools.generatePiece(.row)
			sceneView.scene?.addChild(tallPiece)
			
			let squaredPiece = BlockTools.generatePiece(.square)
			squaredPiece.position = CGPoint(x: -64, y: 0)
			sceneView.scene?.addChild(squaredPiece)
			
			let jShapedPiece = BlockTools.generatePiece(.jShaped)
			jShapedPiece.position = CGPoint(x: -96, y: -64)
			sceneView.scene?.addChild(jShapedPiece)

			let lShapedPiece = BlockTools.generatePiece(.lShaped)
			lShapedPiece.position = CGPoint(x: -64, y: -64)
			sceneView.scene?.addChild(lShapedPiece)

			let sShapedPiece = BlockTools.generatePiece(.sShaped)
			sShapedPiece.position = CGPoint(x: 0, y: -64)
			sceneView.scene?.addChild(sShapedPiece)
			
			let tShapedPiece = BlockTools.generatePiece(.tShaped)
			tShapedPiece.position = CGPoint(x: 64, y: 0)
			sceneView.scene?.addChild(tShapedPiece)
			
			let zShapedPiece = BlockTools.generatePiece(.zShaped)
			zShapedPiece.position = CGPoint(x: 64, y: -64)
			sceneView.scene?.addChild(zShapedPiece)
		}
	}
}
