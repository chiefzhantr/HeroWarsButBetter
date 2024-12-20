//
//  GameScene.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 06.12.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let heightMap = [
        [1, 1, 1, 1, 1],
        [1, 1, 2, 3, 4],
        [1, 1, 2, 1, 2],
        [1, 3, 1, 1, 1],
        [2, 1, 1, 2, 1],
    ]
    
    var rotation = Rotation.defaultRotation
    let rootNode = SKNode()
    let cameraNode = SKCameraNode()
    
    let heroSprite: SKSpriteNode = {
        let sprite = SKSpriteNode(imageNamed: "hero")
        let screenPosition = convertWorldToScreen(Vector(x: -2, y: -2))
        sprite.position = CGPoint(x: screenPosition.x, y: screenPosition.y)
        sprite.zPosition = -Double(screenPosition.y)
        return sprite
    }()
    
    let rotateClockwiseButton: SKLabelNode = {
        let rotateClockwiseButton = SKLabelNode(text: "Rotate Clockwise")
        rotateClockwiseButton.fontName = "AvenirNext-Bold"
        rotateClockwiseButton.fontSize = 12
        rotateClockwiseButton.fontColor = SKColor.blue
        rotateClockwiseButton.position = CGPoint(x: 100, y: -100)
        rotateClockwiseButton.name = "rotateClockwiseButton"
        return rotateClockwiseButton
    }()
    
    let rotateCounterClockwiseButton: SKLabelNode = {
        let rotateCounterClockwiseButton = SKLabelNode(text: "Rotate CounterClockwise")
        rotateCounterClockwiseButton.fontName = "AvenirNext-Bold"
        rotateCounterClockwiseButton.fontSize = 12
        rotateCounterClockwiseButton.fontColor = SKColor.blue
        rotateCounterClockwiseButton.position = CGPoint(x: -100, y: -100)
        rotateCounterClockwiseButton.name = "rotateCounterClockwiseButton"
        return rotateCounterClockwiseButton
    }()
    
    override func didMove(to view: SKView) {
        
        addChild(heroSprite)
        size = view.frame.size
        scaleMode = .aspectFill
        
        let cameraScreenPosition = convertWorldToScreen(Vector(x: 2, y: 2))
        cameraNode.position = CGPoint(x: cameraScreenPosition.x, y: cameraScreenPosition.y)
        addChild(cameraNode)
        self.camera = cameraNode
        
        addChild(rootNode)

        redraw()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        if touchedNode.name == "rotateCounterClockwiseButton" {
            rotateCCW()
        }
        
        if touchedNode.name == "rotateClockwiseButton" {
            rotateCW()
        }
        
        
        heroSprite.position = touchedNode.position
        heroSprite.zPosition = Double(touchedNode.position.y)
    }
    
    func redraw() {
        let cameraScreenPosition = convertWorldToScreen(Vector(x: 2, y: 2), direction: rotation)
        cameraNode.position = CGPoint(x: cameraScreenPosition.x, y: cameraScreenPosition.y)
        
        for node in rootNode.children {
            node.removeFromParent()
        }
        
        rootNode.addChild(rotateClockwiseButton)
        rootNode.addChild(rotateCounterClockwiseButton)
        
        for y in 0 ..< heightMap.count {
            for x in 0 ..< heightMap[y].count {
                let elevation = heightMap[y][x]
                for z in 0 ..< elevation {
                    let sprite = SKSpriteNode(imageNamed: "block")
                    let position = Vector(x: x, y: y, z: z)
                    let screenPosition = convertWorldToScreen(position, direction: rotation)
                    sprite.position = CGPoint(x: screenPosition.x, y: screenPosition.y)
                    sprite.zPosition = CGFloat(convertWorldToZPosition(position, direction: rotation))
                    rootNode.addChild(sprite)
                }
            }
        }
    }
    
    @objc func rotateCW() {
        rotation = rotation.rotated90DegreesClockwise
        redraw()
    }
    
    @objc func rotateCCW() {
        rotation = rotation.rotated90DegreesCounterClockwise
        redraw()
    }
}
