//
//  GameViewController.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 06.12.2024.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    private let mainMenuScene = MainMenuScene()
    private let gameScene = GameScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let skView = self.view as? SKView {
            mainMenuScene.size = skView.bounds.size
            skView.presentScene(mainMenuScene)
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
