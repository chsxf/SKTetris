//
//  SoundManager.swift
//  SKTetris
//
//  Created by Christophe SAUVEUR on 01/05/2021.
//

import AVFoundation

enum SoundKey: String {
    case backgroundMusic01 = "background_music_01"
    
    case brickLand = "brick_land"
    case brickRotate = "brick_rotate"
    case gameOver = "game_over"
    case linesRemoved = "lines_removed"
    case newLevel = "new_level"
}

class SoundManager : NSObject, AVAudioPlayerDelegate {
    
    typealias SoundMapValue = (isSoundEffect: Bool, looping: Bool)

    private static let soundMap: [SoundKey: SoundMapValue] = [
        .backgroundMusic01: (false, true),
        
        .brickLand: (true, false),
        .brickRotate: (true, false),
        .linesRemoved: (true, false),
        .newLevel: (true, false),
        .gameOver: (true, false)
    ]
    
    private static var soundPlayersMap: [SoundKey: AVAudioPlayer] = [:]

    private static let singleDelegate = SoundManager()
    
    static let onSoundFinishedPlaying = EventEmitter<SoundKey>()
    
    static func preloadSounds() {
        for (key, entry) in soundMap {
            let url = Bundle.main.url(forResource: key.rawValue, withExtension: "mp3", subdirectory: "Sounds")
            do {
                let musicPlayer = try AVAudioPlayer(contentsOf: url!)
                musicPlayer.numberOfLoops = entry.looping ? -1 : 0
                musicPlayer.prepareToPlay()
                if entry.isSoundEffect {
                    musicPlayer.delegate = singleDelegate
                }
                soundPlayersMap[key] = musicPlayer
            }
            catch {
                print("SoundManager - Could not load \(key.rawValue)")
            }
        }
    }
    
    static func play(_ key: SoundKey) {
        guard let soundInfo = soundMap[key] else {
            return
        }
        if (soundInfo.isSoundEffect && SettingsManager.sfxEnabled) || (!soundInfo.isSoundEffect && SettingsManager.musicEnabled) {
            guard let sound = soundPlayersMap[key] else {
                return
            }
            if soundInfo.isSoundEffect {
                sound.stop()
                sound.currentTime = 0
            }
            sound.play()
        }
    }
    
    static func stop(_ key: SoundKey) {
        guard let sound = soundPlayersMap[key] else {
            return
        }
        if sound.isPlaying {
            sound.stop()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let soundKey = SoundManager.soundPlayersMap.first(where: { $1 == player })?.key
        if soundKey != nil {
            SoundManager.onSoundFinishedPlaying.notify(soundKey!)
        }
    }
}
