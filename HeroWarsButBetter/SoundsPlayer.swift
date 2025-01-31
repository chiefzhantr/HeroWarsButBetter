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
    
    var audioPlayer: AVAudioPlayer?
    
    func playWeakPunch() {
        let url = getUrl(name: "weak_punch")
        playSound(url: url)
    }
    func playStrongPunch() {
        let url = getUrl(name: "strong_punch")
        playSound(url: url)
    }
    func playExplosion() {
        let url = getUrl(name: "explosion")
        playSound(url: url)
    }
    func playLost() {
        let url = getUrl(name: "lost")
        playSound(url: url)
    }
    func playBackground() {
        let url = getUrl(name: "background")
        playSound(url: url)
    }
    
    func getUrl(name: String) -> URL {
        let pathToSound = Bundle.main.path(forResource: name, ofType: "mp3")!
        let url = URL(fileURLWithPath: pathToSound)
        return url
    }
    
    func playSound(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }
        catch {
            print(error)
        }
    }
}
