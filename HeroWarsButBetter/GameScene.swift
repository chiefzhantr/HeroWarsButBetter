//
//  GameScene.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 06.12.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var viewModel: ViewModel!
    
    let zoomLevels = [1.0, 0.5, 0.25]
    var zoomLevelIndex = 1
    
    var rotation = Rotation.defaultRotation
    let cameraNode = SKCameraNode()
    let rootNode = SKNode()
    let fxRootNode = SKNode()
    
    override func didMove(to view: SKView) {
        SoundsPlayer.shared.playBackground()
        size = view.frame.size
        scaleMode = .aspectFill
        
        let cameraScreenPosition = convertWorldToScreen(Vector3D(x: 2, y: 2))
        cameraNode.position = CGPoint(x: cameraScreenPosition.x, y: cameraScreenPosition.y)
        cameraNode.setScale(0.5)
        addChild(cameraNode)
        self.camera = cameraNode
        
        addChild(rootNode)
        addChild(fxRootNode)

        redraw()
        
        viewModel.redraw = redraw
    }
    
    func redraw() {
        let cameraScreenPosition = convertWorldToScreen(viewModel.selectedTile ?? Vector3D(x: 2, y: 2), direction: rotation)
        cameraNode.position = CGPoint(x: cameraScreenPosition.x, y: cameraScreenPosition.y)
        
        let map = viewModel.map
        let entities = viewModel.entities
        
        for node in rootNode.children {
            node.removeFromParent()
        }
        
        let path = entities.compactMap{ ($0.currentAction as? MoveAction)?.path}
        
        for y in 0 ..< map.rowCount {
            for x in 0 ..< map.colCount {
                let elevation = map[Vector2D(x: x, y: y)]
                for z in 0 ... elevation {
                    let sprite = SKSpriteNode(imageNamed: "block")
                    sprite.texture?.filteringMode = .nearest
                    let position = Vector3D(x: x, y: y, z: z)
                    let screenPosition = convertWorldToScreen(position, direction: rotation)
                    sprite.position = CGPoint(x: screenPosition.x, y: screenPosition.y)
                    sprite.zPosition = CGFloat(convertWorldToZPosition(position, direction: rotation))
                    
                    var color = SKColor.white
                    if position == viewModel.selectedTile {
                        color = SKColor.purple
                    } else if path.contains(where: {$0.contains(position)}){
                        color = SKColor.blue
                    } else if let currentAction = viewModel.currentAction, let selectedEntity = viewModel.selectedEntity, type(of: currentAction).reachableTiles(in: map, for: selectedEntity, allEntities: viewModel.entities).contains(position) {
                        color = SKColor.systemPink
                    }
                    sprite.colorBlendFactor = 1
                    sprite.color = color
                    
                    sprite.userData = ["coord" : position]
                     
                    rootNode.addChild(sprite)
                }
            }
        }
        let entitiesToDraw = entities.filter { $0.shouldDraw }
        for entity in entitiesToDraw {
            let sprite = SKSpriteNode(imageNamed: getIdleAnimationFirstFrameNameForEntity(entity, referenceRotation: rotation))
            let entityScreenPosition = convertWorldToScreen(entity.position, direction: rotation)
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0.3)
            sprite.position = CGPoint(x: entityScreenPosition.x, y: entityScreenPosition.y)
            sprite.zPosition = CGFloat(convertWorldToZPosition(entity.position + Vector3D(x: 0, y: 0, z: 2), direction: rotation))
            
            let animationFX = createAnimationAndFXForEntity(entity)
            if let animation = animationFX.animation {
                sprite.run(animation)
            } else {
                sprite.run(.repeatForever(getAnimationForEntity(entity, animation: "Idle")))
            }
            
            for fx in animationFX.fx {
                fxRootNode.addChild(fx)
            }
            
            rootNode.addChild(sprite)
        }
        
        viewModel.redrawCount += 1
    }
    
    func rotateCW() {
        rotation = rotation.rotated90DegreesClockwise
        redraw()
    }
    
    func rotateCCW() {
        rotation = rotation.rotated90DegreesCounterClockwise
        redraw()
    }
    
    func zoomOut() {
        zoomLevelIndex = max(zoomLevelIndex - 1, 0)
        let zoomLevel = self.zoomLevels[zoomLevelIndex]
        camera?.setScale(zoomLevel)
    }
    
    func zoomIn() {
        zoomLevelIndex = min(zoomLevelIndex + 1, zoomLevels.count - 1)
        let zoomLevel = self.zoomLevels[zoomLevelIndex]
        camera?.setScale(zoomLevel)
    }
    
    func processTap(at screenCoord: CGPoint) {
        let map = viewModel.map
        let scenePoint = convertPoint(fromView: screenCoord)
        
        let nodeCoords = nodes(at: scenePoint)
            .sorted {($0.position - scenePoint).sqrMagnitude < ($1.position - scenePoint).sqrMagnitude}
            .compactMap { node -> Vector3D? in
                guard let coord = node.userData?["coord"] as? Vector3D else {
                    return nil
                }
                return coord
            }
            .filter {$0 == map.convertTo3D($0.xy)}
        if let clickedTile = nodeCoords.first {
            viewModel.clickTile(clickedTile)
        }
        redraw()
    }
}

extension CGPoint {
    static func  -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    var sqrMagnitude: Double {
        x * x + y * y
    }
}

extension Entity {
    var shouldDraw: Bool {
        isActive || currentAction != nil
    }
}
// сделать аи атаку плеера после удара: done
// показ хелза в виде математического уравнения: done
// сменить юниты на лучников а моего плеера на мечника: done
// сделать меню: in process
// сделать левелы
// сделать звуки: done partially
