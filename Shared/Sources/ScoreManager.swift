//
//  ScoreManager.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 10/04/2021.
//

import SpriteKit

class ScoreManager {
	
	private var currentScore: Int = 0
	private var currentLevel: Int = 0
	
	private var totalLinesCleared: Int = 0
	
	private let scoreMap = [40, 100, 300, 1200]
	
	private let scoreLabel: ValueDisplayNode
	private let levelLabel: ValueDisplayNode
	
	let onLevelChanged = EventEmitter<Int>()
	
	init(withScoreLabel scoreLabel: ValueDisplayNode, andLevelLevel levelLabel: ValueDisplayNode) {
		self.scoreLabel = scoreLabel
		self.levelLabel = levelLabel
		
		reset()
	}
	
	func reset() {
		currentScore = 0
		currentLevel = 1
		totalLinesCleared = 0
		
		updateLabels()
	}
	
    func pushLines(_ countLines: Int, sender: Any?) -> Void {
		currentScore += scoreMap[countLines - 1] * currentLevel
		
		totalLinesCleared += countLines
		let previousLevel = currentLevel
		currentLevel = (totalLinesCleared / 10) + 1
		if previousLevel != currentLevel {
			onLevelChanged.notify(currentLevel)
		}
		
		updateLabels()
	}
	
	private func updateLabels() {
		scoreLabel.text = "\(currentScore)"
		levelLabel.text = "\(currentLevel)"
	}
	
}
