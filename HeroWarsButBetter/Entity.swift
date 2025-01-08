//
//  Entity.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 02.01.2025.
//

import Foundation

final class Entity {
    let sprite: String
    var position: Vector3D
    var rotation = Rotation.defaultRotation
    var currentAction: Action?
    
    init(sprite: String, startPosition: Vector3D, rotation: Rotation = .defaultRotation) {
        self.position = startPosition
        self.sprite = sprite
        self.rotation = rotation
    }
    
    func copy() -> Entity {
        Entity(sprite: sprite, startPosition: position, rotation: rotation)
    }
    
    func completeCurrentAction() {
        currentAction?.complete()
        currentAction = nil
    }
}
