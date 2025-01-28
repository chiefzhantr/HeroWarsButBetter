//
//  ViewModel.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 08.01.2025.
//

import Foundation
import Combine

final class ViewModel: ObservableObject {
    @Published var selectedTile: Vector3D?
    @Published var selectedEntity: Entity?
    @Published var currentAction: Action?
    @Published var redrawCount = 0
    
    let map: Map
    var entities: [Entity] {
        battle.entities
    }
    let battle: Battle
    var redraw: (() -> Void)?
    
    var isBusy: Bool {
        entities.compactMap {
            $0.currentAction
        }.isEmpty == false
    }
    
    init(map: Map, entities: [Entity]) {
        self.map = map
        self.battle = Battle(entities: entities)
    }
    
    func clickTile(_ tile: Vector3D) {
        selectedTile = nil
        
        if map.tiles.keys.contains(tile.xy) {
            selectedTile = tile
        }
        
        if let currentAction {
            if let selectedTile, let selectedEntity {
                let action = type(of: currentAction).make(in: map, for: selectedEntity, targetting: selectedTile, allEntities: entities)
                self.currentAction = action
            }
        } else {
            selectedEntity = nil
            if let entity = entities.first(where: { $0.position == tile }),entity.isActive {
                selectedEntity = entity
            }
        }
    }
    
    func commitAction() {
        selectedEntity?.currentAction = currentAction
        currentAction = nil
        redraw?()
    }
}
