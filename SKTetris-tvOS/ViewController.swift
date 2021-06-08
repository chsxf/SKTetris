//
//  ViewController.swift
//  SKTetris-iOS
//
//  Created by Christophe on 23/05/2021.
//

import Foundation
import UIKit

class ViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = GameView(frame: self.view.frame)
        self.view.addSubview(view)
        
        let gestureRecognizer = SiriRemoteGestureRecognizer(withGameView: view, andDelegate: view)
        self.view.addGestureRecognizer(gestureRecognizer)
        
        FocusManager.inputMode = .remote
    }
    
}
