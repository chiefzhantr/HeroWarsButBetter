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
    var currentHP = 10
    let attackRange: Int
    let team: String
    var hasActed = false
    
    init(sprite: String, startPosition: Vector3D, range: Int = Int.max, maxHeightDifference: Int = Int.max, attackRange: Int = 1, team: String = "") {
        self.position = startPosition
        self.sprite = sprite
        self.range = range
        self.maxHeightDifference = maxHeightDifference
        self.attackRange = attackRange
        self.team = team
    }
    
    func copy() -> Entity {
        let copy = Entity(sprite: sprite, startPosition: position)
        copy.rotation = rotation
        copy.currentAction = currentAction
        copy.currentHP = currentHP
        return copy
    }
    
    func completeCurrentAction() {
        currentAction?.complete()
        if currentAction?.endsTurn ?? false {
            hasActed = true
        }
        currentAction = nil
    }
    
    func takeDamage(_ amount: Int) {
        currentHP -= amount
        
        currentAction = TakeDamageAction()
    }
}
