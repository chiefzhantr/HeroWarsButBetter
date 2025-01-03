//
//  Vector3D.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 03.01.2025.
//

import Foundation

struct Vector3D {
    let x: Int
    let y: Int
    let z: Int
    
    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    init(x: Int, y: Int) {
        self.init(x: x, y: y, z: 0)
    }
    
    static func +(lhs: Vector3D, rhs: Vector3D) -> Vector3D {
        Vector3D(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    static func *(scalar: Int, vector: Vector3D) -> Vector3D {
        Vector3D(x: vector.x * scalar, y: vector.y * scalar, z: scalar * vector.z)
    }
    
    static var random: Vector3D {
        Vector3D(x: Int.random(in: -1000 ... 1000), y: Int.random(in: -1000 ... 1000), z: Int.random(in: -1000 ... 1000))
    }
    
    static var zero: Vector3D {
        Vector3D(x: 0, y: 0)
    }
    
    var xy: Vector2D {
        Vector2D(x: x, y: y)
    }
}

extension Vector3D: Equatable { }
