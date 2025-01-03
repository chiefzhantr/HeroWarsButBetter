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
    
    init(sprite: String, startPosition: Vector3D) {
        self.position = startPosition
        self.sprite = sprite
    }
}
