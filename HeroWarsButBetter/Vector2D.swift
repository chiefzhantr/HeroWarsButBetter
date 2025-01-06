//
//  Vector2D.swift
//  HeroWarsButBetterTests
//
//  Created by Admin  on 03.01.2025.
//

import Foundation

struct Vector2D {
    let x: Int
    let y: Int
    
    static func +(lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        Vector2D(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        Vector2D(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func *(scalar: Int, vector: Vector2D) -> Vector2D {
        Vector2D(x: vector.x * scalar, y: vector.y * scalar)
    }
    
    static var zero: Vector2D {
        Vector2D(x: 0, y: 0)
    }
    
    var neighbours: [Vector2D] {
        [
            self + Vector2D(x: 1, y: 0),
            self + Vector2D(x: -1, y: 0),
            self + Vector2D(x: 0, y: 1),
            self + Vector2D(x: 0, y: -1),
        ]
    }
}

extension Vector2D: Hashable { }
