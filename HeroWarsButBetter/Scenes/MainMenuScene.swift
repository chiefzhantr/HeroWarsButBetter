//
//  MainMenuScene.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 06.12.2024.
//

import SpriteKit

final class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white

        let titleLabel = SKLabelNode(text: "Hero wars but better")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 36
        titleLabel.fontColor = SKColor.black
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        addChild(titleLabel)

        let startButton = SKLabelNode(text: "Start Game")
        startButton.fontName = "AvenirNext-Bold"
        startButton.fontSize = 24
        startButton.fontColor = SKColor.blue
        startButton.position = CGPoint(x: size.width / 2, y: size.height * 0.5)
        startButton.name = "startButton"
        addChild(startButton)

        let settingsButton = SKLabelNode(text: "Settings")
        settingsButton.fontName = "AvenirNext-Bold"
        settingsButton.fontSize = 24
        settingsButton.fontColor = SKColor.gray
        settingsButton.position = CGPoint(x: size.width / 2, y: size.height * 0.4)
        settingsButton.name = "settingsButton"
        addChild(settingsButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        if touchedNode.name == "startButton" {
            let gameScene = GameScene(size: size)
            let transition = SKTransition.fade(withDuration: 1.0)
            view?.presentScene(gameScene, transition: transition)
        } else if touchedNode.name == "settingsButton" {
            let gameScene = SettingsScene(size: size)
            let transition = SKTransition.fade(withDuration: 1.0)
            view?.presentScene(gameScene, transition: transition)
        }
    }
}
