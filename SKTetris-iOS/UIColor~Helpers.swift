//
//  UIColor~Helpers.swift
//  SKTetris-iOS
//
//  Created by Christophe on 23/05/2021.
//

import UIKit

extension UIColor {
    
    func highlight(withLevel level: CGFloat) -> UIColor {
        return withSaturationMultiplier(0.5, brightnessMultiplier: 2, andLevel: level)
    }
    
    func shadow(withLevel level: CGFloat) -> UIColor {
        return withSaturationMultiplier(2, brightnessMultiplier: 0.5, andLevel: level)
    }
    
    private func withSaturationMultiplier(_ saturationMultiplier: CGFloat, brightnessMultiplier: CGFloat, andLevel level: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha);
        
        let targetSaturation = min(max(saturation * saturationMultiplier, 0), 1)
        let targetBrightness = min(max(brightness * brightnessMultiplier, 0), 1)
        
        let clampedLevel = min(max(level, 0), 1)
        let newBrightness = brightness + (targetBrightness - brightness) * clampedLevel
        let newSaturation = saturation + (targetSaturation - saturation) * clampedLevel
        return UIColor(hue: hue, saturation: newSaturation, brightness: newBrightness, alpha: alpha)
    }
    
}
