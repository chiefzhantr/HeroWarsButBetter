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
    let range: Int
    let maxHeightDifference: Int
    
    init(sprite: String, startPosition: Vector3D, range: Int = Int.max, maxHeightDifference: Int = Int.max) {
        self.position = startPosition
        self.sprite = sprite
        self.range = range
        self.maxHeightDifference = maxHeightDifference
    }
    
    func copy() -> Entity {
        let copy = Entity(sprite: sprite, startPosition: position)
        copy.rotation = rotation
        return copy
    }
    
    func completeCurrentAction() {
        currentAction?.complete()
        currentAction = nil
    }
}
