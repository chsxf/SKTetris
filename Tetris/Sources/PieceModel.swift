//
//  PieceModel.swift
//  Tetris
//
//  Created by Christophe on 13/03/2021.
//

import CoreGraphics

class PieceModel {
    
    let type: PieceType
    let gridOffsets: [GridCoordinates]
    
    init(withType type: PieceType) {
        self.type = type
        self.gridOffsets = PieceModel.getGridOffsets(forType: type)
    }
    
    fileprivate class func getGridOffsets(forType type: PieceType) -> [GridCoordinates] {
        switch type {
        case .jShaped:
            return [ GridCoordinates(), GridCoordinates(x: -1, y: 0), GridCoordinates(x: 0, y: 1), GridCoordinates(x: 0, y: 2) ]
        case .lShaped:
            return [ GridCoordinates(), GridCoordinates(x: 1, y: 0), GridCoordinates(x: 0, y: 1), GridCoordinates(x: 0, y: 2) ]
        case .row:
            return [ GridCoordinates(), GridCoordinates(x: 0, y: 1), GridCoordinates(x: 0, y: -1), GridCoordinates(x: 0, y: -2) ]
        case .square:
            return [ GridCoordinates(), GridCoordinates(x: 0, y: 1), GridCoordinates(x: 1, y: 0), GridCoordinates(x: 1, y: 1) ]
        case .sShaped:
            return [ GridCoordinates(), GridCoordinates(x: -1, y: 0), GridCoordinates(x: 0, y: 1), GridCoordinates(x: 1, y: 1) ]
        case .tShaped:
            return [ GridCoordinates(), GridCoordinates(x: -1, y: 0), GridCoordinates(x: 1, y: 0), GridCoordinates(x: 0, y: 1) ]
        case .zShaped:
            return [ GridCoordinates(), GridCoordinates(x: -1, y: 1), GridCoordinates(x: 0, y: 1), GridCoordinates(x: 1, y: 0) ]
        }
    }
    
}
