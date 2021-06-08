//
//  VirtualGamepadDelegate.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 10/06/2021.
//

protocol VirtualGamepadDelegate {
    
    func onVirtualGamepadKeyDown(_ key: VirtualGamepadKey)
    func onVirtualGamepadKeyUp(_ key: VirtualGamepadKey)
    
}
