//
//  Action.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 07.01.2025.
//

import Foundation

protocol Action {
    var description: String { get }
    var canComplete: Bool { get }
    var endsTurn: Bool { get }
    static func make(in map: Map, for entity: Entity, targetting: Vector3D, allEntities: [Entity]) -> Self?
    static func reachableTiles(in map: Map, for entity: Entity, allEntities: [Entity]) -> [Vector3D]
    
    func complete()
}

extension Action {
    func complete() {
        print("Completed action: \(self)")
    }
    
    static func reachableTiles(in map: Map, for entity: Entity, allEntities: [Entity] = []) -> [Vector3D] {
        map.tiles.keys.map { map.convertTo3D($0) }
    }
    
    var description: String {
        "\(self)"
    }
    
    var canComplete: Bool {
        true
    }
    
    var endsTurn: Bool {
        true
    }
}

struct DummyAction: Action {
    static func make(in map: Map, for entity: Entity, targetting: Vector3D, allEntities: [Entity]) -> DummyAction? {
        DummyAction()
    }
    
}

struct MoveAction: Action {
    
    var endsTurn: Bool {
        false
    }
    
    static func make(in map: Map, for entity: Entity, targetting: Vector3D, allEntities: [Entity] = []) -> MoveAction? {
        guard reachableTiles(in: map, for: entity, allEntities: allEntities).contains(targetting) else {
            return nil
        }
        
        let dijkstra = map.dijkstra(target: entity.position.xy, maxHeightDifference: entity.maxHeightDifference)
        let path = map.getPath(to: targetting.xy, using: dijkstra, maxHeightDifference: entity.maxHeightDifference).map {
            map.convertTo3D($0)
        }
        return MoveAction(owner: entity, path: path)
    }
    
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
    
    var description: String {
        if let lastCoord = path.last {
            return "Move to (\(lastCoord.x),\(lastCoord.y))"
        }
        return "Move to ..."
    }
    
    var canComplete: Bool {
        path.isEmpty == false
    }
    
    static func reachableTiles(in map: Map, for entity: Entity, allEntities: [Entity] = []) -> [Vector3D] {
        let occcupiedTiles = allEntities
            .filter { $0.isActive }
            .map { $0.position.xy }
        let dijkstra = map.dijkstra(target: entity.position.xy, maxHeightDifference: entity.maxHeightDifference)
        
        return dijkstra
            .filter {
                $0.value <= entity.range
            }
            .filter {
                occcupiedTiles.contains($0.key) == false
            }
            .map {
                map.convertTo3D($0.key)
            }
    }
}

struct AttackAction: Action {
    
    weak var owner: Entity?
    weak var target: Entity?
    
    static func reachableTiles(in map: Map, for entity: Entity, allEntities: [Entity]) -> [Vector3D] {
        
        let dijkstra = map.dijkstra(target: entity.position.xy)
        
        return dijkstra
            .filter {
                $0.value <= entity.attackRange
            }
            .map {
                map.convertTo3D($0.key)
            }
    }
    
    static func make(in map: Map, for entity: Entity, targetting: Vector3D, allEntities: [Entity]) -> AttackAction? {
        
        guard reachableTiles(in: map, for: entity, allEntities: allEntities).contains(targetting) else {
            return nil
        }
        
        guard let targetEntity = allEntities.first(where: {
            $0.position == targetting
        }) else {
            return nil
        }
        
        guard targetEntity.isActive else {
            return nil
        }
        
        return AttackAction(owner: entity, target: targetEntity)
    }
    
    func complete() {
        let targetFullHP = target?.fullHP ?? 0
        let ownerFullHP = owner?.fullHP ?? 0
        
        if targetFullHP < ownerFullHP {
//            SoundsPlayer.shared.playStrongPunch()
            target?.takeDamage(targetFullHP)
        } else {
//            SoundsPlayer.shared.playWeakPunch()
            target?.takeDamage(targetFullHP / 3)
        }
        
        guard let owner, let target else {
            return
        }
        let attackDirection = Rotation.fromLookDirection(target.position.xy - owner.position.xy) ?? owner.rotation
        
        owner.rotation = attackDirection
        target.rotation = attackDirection.rotated90DegreesClockwise.rotated90DegreesClockwise
        if target.currentHP > 0 && owner.currentHP > 0 {
            target.currentAction = AttackAction(owner: target, target: owner)
        } else {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//                SoundsPlayer.shared.playExplosion()
//            })
            owner.fullHP += target.fullHP / 2
            owner.currentHP = owner.fullHP
        }
    }
    
    var canComplete: Bool {
        target != nil
    }
    
    var description: String {
        "Attack \(target?.sprite ?? "Nothing")"
    }
}

struct TakeDamageAction: Action {
    let endsTurn = false
    
    static func make(in map: Map, for entity: Entity, targetting: Vector3D, allEntities: [Entity]) -> TakeDamageAction? {
        TakeDamageAction()
    }
}

struct DefeatAction: Action {
    static func make(in map: Map, for entity: Entity, targetting: Vector3D, allEntities: [Entity]) -> DefeatAction? {
        DefeatAction()
    }
}
