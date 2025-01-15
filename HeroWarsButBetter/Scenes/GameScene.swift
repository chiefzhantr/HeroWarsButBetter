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
    
    var rotation = Rotation.defaultRotation
    let cameraNode = SKCameraNode()
    let rootNode = SKNode()
    
    override func didMove(to view: SKView) {
        size = view.frame.size
        scaleMode = .aspectFill
        
        let cameraScreenPosition = convertWorldToScreen(Vector3D(x: 2, y: 2))
        cameraNode.position = CGPoint(x: cameraScreenPosition.x, y: cameraScreenPosition.y)
        cameraNode.setScale(0.5)
        addChild(cameraNode)
        self.camera = cameraNode
        
        addChild(rootNode)

        redraw()
        
        viewModel.redraw = redraw
    }
    
    func redraw() {
        let cameraScreenPosition = convertWorldToScreen(Vector3D(x: 2, y: 2), direction: rotation)
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
        
        for entity in entities {
            let sprite = SKSpriteNode(imageNamed: getIdleAnimationFirstFrameNameForEntity(entity, referenceRotation: rotation))
            let entityScreenPosition = convertWorldToScreen(entity.position, direction: rotation)
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0.3)
            sprite.position = CGPoint(x: entityScreenPosition.x, y: entityScreenPosition.y)
            sprite.zPosition = CGFloat(convertWorldToZPosition(entity.position + Vector3D(x: 0, y: 0, z: 2), direction: rotation))
            
            if let animation = createAnimationForEntity(entity) {
                sprite.run(animation)
            } else {
                sprite.run(.repeatForever(getAnimationForEntity(entity, animation: "Idle")))
            }
            rootNode.addChild(sprite)
        }
        
        print("Root node children count: \(rootNode.children.count)")
        for node in rootNode.children {
            print("Node position: \(node.position), userData: \(node.userData ?? [:])")
        }
    }
    
    func rotateCW() {
        rotation = rotation.rotated90DegreesClockwise
        redraw()
    }
    
    func rotateCCW() {
        rotation = rotation.rotated90DegreesCounterClockwise
        redraw()
    }
    
    func getAnimationForEntity(_ entity: Entity, animation: String) -> SKAction {
        let animationName = getAnimationNameForEntity(entity, animation: animation, referenceRotation: rotation)
        let frames = [
            "\(animationName)_0",
            "\(animationName)_1",
            "\(animationName)_2",
            "\(animationName)_3"
        ]
            .map { SKTexture(imageNamed: $0) }
            .map { frame in
                frame.filteringMode = .nearest
                return frame
            }
        let animation = SKAction.animate(with: frames, timePerFrame: 0.25)
        return animation
    }
    
    func createAnimationForEntity(_ entity: Entity) -> SKAction? {
        guard let currentAction = entity.currentAction else {
            return nil
        }
        
        switch type(of: currentAction) {
        case is MoveAction.Type:
            return createFollowPathAnimationForEntity(entity)
        case is AttackAction.Type:
            return createMeleeAttackActionForEntity(entity)
        case is TakeDamageAction.Type:
            return createTakeDamageAnimationForEntity(entity)
        default:
            print("not impl action type: \(currentAction). Returning fallback anim compl")
            return createCompleteActionForEntity(entity)
        }
    }
    
    func createCompleteActionForEntity(_ entity: Entity) -> SKAction {
        return SKAction.customAction(withDuration: 0.001) { [weak self] _, _ in
            entity.completeCurrentAction()
            self?.redraw()
        }
    }
    
    func createFollowPathAnimationForEntity(_ entity: Entity) -> SKAction? {
        
        guard let moveAction = entity.currentAction as? MoveAction else {
            return nil
        }
        
        var movementActions = [SKAction]()
        let duration = 0.25
        var lastCoord = entity.position.xy
        for coord in moveAction.path {
            let stuntDouble = entity.copy()
            let newRotation = Rotation.fromLookDirection(coord.xy - lastCoord) ?? entity.rotation
            stuntDouble.rotation = newRotation
            lastCoord = coord.xy
            let animation = getAnimationForEntity(stuntDouble, animation: "Walk")
            
            let screenCoord = convertWorldToScreen(coord, direction: rotation)
            let screenPosition = CGPoint(x: screenCoord.x, y: screenCoord.y)
            let movementAction = SKAction.move(to: screenPosition, duration: duration)
            let zPosition = convertWorldToZPosition(coord + Vector3D(x: 0, y: 0, z: 2), direction: rotation)
            let zPositionAction = SKAction.customAction(withDuration: duration) { node, time in
                node.zPosition = CGFloat(zPosition)
                
            }
            
            movementActions.append(.group([animation, movementAction, zPositionAction]))
        }
        
        let completeAction = createCompleteActionForEntity(entity)
        movementActions.append(completeAction)
         
        return SKAction.sequence(movementActions)
    }
    
    func createMeleeAttackActionForEntity(_ entity: Entity) -> SKAction? {
        guard let meleeAttackAction = entity.currentAction as? AttackAction else {
            return nil
        }
        
        guard let target = meleeAttackAction.target else {
            return nil
        }
        
        let stuntDouble = entity.copy()
        let newRotation = Rotation.fromLookDirection(target.position.xy - entity.position.xy) ?? stuntDouble.rotation
        stuntDouble.rotation = newRotation
        
        let attackAnimation = getAnimationForEntity(stuntDouble, animation: "MeleeAttack")
        let completeAction = createCompleteActionForEntity(entity)
        return SKAction.sequence([attackAnimation, completeAction])
    }
    
//    let hitAction = SKAction.customAction(withDuration: 0.001) { _, _ in
//        target.currentAction = TakeDamageAction()
//    }
    
    func createTakeDamageAnimationForEntity(_ entity: Entity) -> SKAction? {
        let stuntDouble = entity.copy()
        let animation = getAnimationForEntity(stuntDouble, animation: "TakeDamage")
        let completeAction = createCompleteActionForEntity(entity)
        
        return SKAction.sequence([animation, completeAction])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let map = viewModel.map
        let scenePoint = touch.location(in: self)
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
