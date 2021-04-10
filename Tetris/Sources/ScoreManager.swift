//
//  ScoreManager.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 10/04/2021.
//

import SpriteKit

class ScoreManager {
	
	private var currentScore: Int = 0
	private var currentLevel: Int = 1
	
	private let scoreMap = [40, 100, 300, 1200]
	
	private let scoreLabel: SKLabelNode
	
	init(withScoreLabel scoreLabel: SKLabelNode) {
		self.scoreLabel = scoreLabel
		updateLabels()
	}
	
	func pushLines(_ countLines: Int) -> Void {
		currentScore += scoreMap[countLines - 1] * currentLevel
		updateLabels()
	}
	
	private func updateLabels() {
		scoreLabel.text = "\(currentScore)"
	}
	
}
