//
//  SettingsManager.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 01/05/2021.
//

import Foundation

class SettingsManager {
    
    private static let SFX_ENABLED_KEY = "sfx_enabled"
    private static let MUSIC_ENABLED_KEY = "music_enabled"
    
    static func initialize() {
        UserDefaults.standard.register(defaults: [
            SFX_ENABLED_KEY: true,
            MUSIC_ENABLED_KEY: true
        ])
    }
    
    static var sfxEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: SFX_ENABLED_KEY) }
        set { UserDefaults.standard.setValue(newValue, forKey: SFX_ENABLED_KEY) }
    }
    
    static var musicEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: MUSIC_ENABLED_KEY) }
        set {
            UserDefaults.standard.setValue(newValue, forKey: MUSIC_ENABLED_KEY)
            if newValue {
                SoundManager.play(.backgroundMusic01)
            }
            else {
                SoundManager.stop(.backgroundMusic01)
            }
        }
    }
    
}
