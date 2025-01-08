//
//  Action.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 07.01.2025.
//

import Foundation

protocol Action {
    func complete()
}

extension Action {
    func complete() {
        print("Completed action: \(self)")
    }
}

struct DummyAction: Action {
    
}

struct MoveAction: Action {
    weak var owner: Entity?
    let path: [Vector3D]
    
    func complete() {
        guard let owner else {
            return
        }
        if path.count >= 1 {
            owner.position = path[path.count - 1]
            owner.rotation = Rotation.fromLookDirection(path[path.count - 1].xy - path[path.count - 2].xy) ?? owner.rotation
        }
    }
}
