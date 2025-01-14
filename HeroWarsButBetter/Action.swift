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
    static func make(in map: Map, for entity: Entity, targetting: Vector3D) -> Self?
    static func reachableTiles(in map: Map, for entity: Entity) -> [Vector3D]
    
    func complete()
}

extension Action {
    func complete() {
        print("Completed action: \(self)")
    }
    
    static func reachableTiles(in map: Map, for entity: Entity) -> [Vector3D] {
        map.tiles.keys.map { map.convertTo3D($0) }
    }
    
    var description: String {
        "\(self)"
    }
    
    var canComplete: Bool {
        true
    }
}

struct DummyAction: Action {
    static func make(in map: Map, for entity: Entity, targetting: Vector3D) -> DummyAction? {
        DummyAction()
    }
    
}

struct MoveAction: Action {
    static func make(in map: Map, for entity: Entity, targetting: Vector3D) -> MoveAction? {
        guard reachableTiles(in: map, for: entity).contains(targetting) else {
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
    
    static func reachableTiles(in map: Map, for entity: Entity) -> [Vector3D] {
        let dijkstra = map.dijkstra(target: entity.position.xy, maxHeightDifference: entity.maxHeightDifference)
        return dijkstra.filter {
            $0.value <= entity.range
        }.map {
            map.convertTo3D($0.key)
        }
    }
}
