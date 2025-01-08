//
//  ViewModel.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 08.01.2025.
//

import Foundation

final class ViewModel {
    var selectedTile: Vector3D?
    var selectedEntity: Entity?
    let map: Map
    let entities: [Entity]
    
    init(map: Map, entities: [Entity]) {
        self.map = map
        self.entities = entities
    }
    
    func clickTile(_ tile: Vector3D) {
        selectedTile = nil
        selectedEntity = nil
        if map.tiles.keys.contains(tile.xy) {
            selectedTile = tile
        }
        
        if let entity = entities.first(where: {
            $0.position == tile
        }) {
            selectedEntity = entity
        }
    }
}
