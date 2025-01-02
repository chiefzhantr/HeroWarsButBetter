//
//  SettingsScene.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 06.12.2024.
//

import SpriteKit
import GameplayKit

class SettingsScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.lightGray
        
        let label = SKLabelNode(text: "Settings Scene")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 36
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)
    }
}
