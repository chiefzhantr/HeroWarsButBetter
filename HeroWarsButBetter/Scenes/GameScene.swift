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
    var knightRotation = Rotation.degrees225
    
    override func didMove(to view: SKView) {
        size = view.frame.size
        scaleMode = .aspectFill
        
        let cameraScreenPosition = convertWorldToScreen(Vector(x: 2, y: 2))
        cameraNode.position = CGPoint(x: cameraScreenPosition.x, y: cameraScreenPosition.y)
        cameraNode.setScale(0.5)
        addChild(cameraNode)
        camera = cameraNode
        
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
    }
    
    func redraw() {
        let cameraScreenPosition = convertWorldToScreen(Vector(x: 2, y: 2), direction: rotation)
        cameraNode.position = CGPoint(x: cameraScreenPosition.x, y: cameraScreenPosition.y)
        
        for node in rootNode.children {
            node.removeFromParent()
        }
        
        for y in 0 ..< heightMap.count {
            for x in 0 ..< heightMap[y].count {
                let elevation = heightMap[y][x]
                for z in 0 ..< elevation {
                    let sprite = SKSpriteNode(imageNamed: "block")
                    sprite.texture?.filteringMode = .nearest
                    let position = Vector(x: x, y: y, z: z)
                    let screenPosition = convertWorldToScreen(position, direction: rotation)
                    sprite.position = CGPoint(x: screenPosition.x, y: screenPosition.y)
                    sprite.zPosition = CGFloat(convertWorldToZPosition(position, direction: rotation))
                    rootNode.addChild(sprite)
                }
            }
        }
        
        let knight = SKSpriteNode(imageNamed: "Knight_225_0")
        let knightPosition = Vector(x: 1, y: 1, z: 1)
        let knightScreenPosition = convertWorldToScreen(knightPosition, direction: rotation)
        knight.anchorPoint = CGPoint(x: 0.5, y: 0.3)
        knight.position = CGPoint(x: knightScreenPosition.x, y: knightScreenPosition.y)
        knight.zPosition = CGFloat(convertWorldToZPosition(knightPosition, direction: rotation))
        knight.run(getKnightAnimation(lookRotation: knightRotation))
        rootNode.addChild(knight)
    }
    
    func rotateCW() {
        rotation = rotation.rotated90DegreesClockwise
        redraw()
    }
    
    func rotateCCW() {
        rotation = rotation.rotated90DegreesCounterClockwise
        redraw()
    }
    
    func rotateKnightCW() {
        knightRotation = knightRotation.rotated90DegreesClockwise
        redraw()
    }
    
    func rotateKnightCCW() {
        knightRotation = knightRotation.rotated90DegreesCounterClockwise
        redraw()
    }
    
    func getKnightAnimation(lookRotation: Rotation) -> SKAction {
        let viewRotation = lookRotation.withReferenceRotation(rotation)
        let frames = [
            "Knight_\(viewRotation.rawValue)_0",
            "Knight_\(viewRotation.rawValue)_1",
            "Knight_\(viewRotation.rawValue)_2",
            "Knight_\(viewRotation.rawValue)_3"
        ]
            .map { SKTexture(imageNamed: $0) }
            .map { frame in
                frame.filteringMode = .nearest
                return frame
            }
        let animation = SKAction.animate(with: frames, timePerFrame: 0.25)
        return SKAction.repeatForever(animation)
    }
}
