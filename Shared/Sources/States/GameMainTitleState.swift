//
//  GameMainTitleState.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 03/05/2021.
//

import GameplayKit

class GameMainTitleState: GKState {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == GameIdleState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        let gameStateMachine = stateMachine! as! GameStateMachine
        gameStateMachine.scene.showMainTitle()
    }
    
    override func willExit(to nextState: GKState) {
        let gameStateMachine = stateMachine! as! GameStateMachine
        gameStateMachine.scene.hideMainTitle()
    }
    
}
