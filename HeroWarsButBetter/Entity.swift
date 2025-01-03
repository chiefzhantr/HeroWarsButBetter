//
//  Entity.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 02.01.2025.
//

import Foundation

final class Entity {
    let sprite: String
    var position: Vector
    var rotation = Rotation.defaultRotation
    
    init(sprite: String, startPosition: Vector) {
        self.position = startPosition
        self.sprite = sprite
    }
}
