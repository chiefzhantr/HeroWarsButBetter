//
//  SoundsPlayer.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 31.01.2025.
//

import Foundation
import AVFoundation

final class SoundsPlayer {
    
    static let shared = SoundsPlayer()
    
    var weakPunchPlayer: AVAudioPlayer?
    var strongPunchPlayer: AVAudioPlayer?
    var explosionPlayer: AVAudioPlayer?
    var lostPlayer: AVAudioPlayer?
    var backgroundPlayer: AVAudioPlayer?
    var winPlayer: AVAudioPlayer?
    
    func playWeakPunch() {
        let url = getUrl(name: "weak_punch")
        playSound(url: url, audioPlayer: &weakPunchPlayer)
    }
    func playStrongPunch() {
        let url = getUrl(name: "strong_punch")
        playSound(url: url, audioPlayer: &strongPunchPlayer)
    }
    func playExplosion() {
        let url = getUrl(name: "explosion")
        playSound(url: url, audioPlayer: &explosionPlayer)
    }
    func playLost() {
        let url = getUrl(name: "lost")
        playSound(url: url, audioPlayer: &lostPlayer)
        if let winPlayer = winPlayer {
            winPlayer.stop()
        }
        if let backgroundPlayer = backgroundPlayer {
            backgroundPlayer.stop()
        }
    }
    func playWin() {
        let url = getUrl(name: "win")
        playSound(url: url, audioPlayer: &winPlayer)
        if let lostPlayer = lostPlayer {
            lostPlayer.stop()
        }
        if let backgroundPlayer = backgroundPlayer {
            backgroundPlayer.stop()
        }
    }
    func playBackground() {
        let url = getUrl(name: "background")
        playSound(url: url, audioPlayer: &backgroundPlayer, volume: 0.2)
        if let winPlayer = winPlayer {
            winPlayer.stop()
        }
        if let lostPlayer = lostPlayer {
            lostPlayer.stop()
        }
    }
    
    func getUrl(name: String) -> URL {
        let pathToSound = Bundle.main.path(forResource: name, ofType: "mp3")!
        let url = URL(fileURLWithPath: pathToSound)
        return url
    }
    
    func playSound(url: URL, audioPlayer: inout AVAudioPlayer?, volume: Float = 1) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = volume
            audioPlayer?.play()
        }
        catch {
            print(error)
        }
    }
}
