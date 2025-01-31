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

extension ViewModel {
    static let levels = [
        //1
        ViewModel(map: Map(heightMap: [
            [1,1,1,1,1],
            [1,1,1,1,1],
            [1,1,1,1,1],
            [1,1,1,1,1],
            [1,1,1,1,1],
        ]), entities: [
            Entity(sprite: "Knight", startPosition: Vector3D(x: 1, y: 1, z: 1), range: 3, maxHeightDifference: 1, team: "Player", fullHP: 3, expressionHP: "3"),
            Entity(sprite: "Knight", startPosition: Vector3D(x: 3, y: 2, z: 1), range: 3, maxHeightDifference: 1, team: "Enemy", fullHP: 3, expressionHP: "3*2 - 1 - 5/5 - 4/2 + 1"),
            Entity(sprite: "Rogue", startPosition: Vector3D(x: 1, y: 3, z: 1), range: 4, attackRange: 3, team: "Enemy", fullHP: 2, expressionHP: "2*3 - 3 - 4*3 + 2*9 - 12 + 6 + 2"),
            Entity(sprite: "Rogue", startPosition: Vector3D(x: 4, y: 4, z: 1), range: 4, attackRange: 3, team: "Enemy", fullHP: 5, expressionHP: "(2 × 3) - (√9 - 1)"),
        ]),
        
        //2
        ViewModel(map: Map(heightMap: [
            [1,1,1,1],
            [1,1,1,1],
            [1,1,1,1],
            [1,1,1,1],
        ]), entities: [
            Entity(sprite: "Knight", startPosition: Vector3D(x: 1, y: 1, z: 1), range: 3, maxHeightDifference: 1, team: "Player", fullHP: 2, expressionHP: "4 - 2"),
            Entity(sprite: "Rogue", startPosition: Vector3D(x: 1, y: 4, z: 1), range: 3, maxHeightDifference: 1, team: "Enemy", fullHP: 1, expressionHP: "2 - 1"),
            Entity(sprite: "Rogue", startPosition: Vector3D(x: 4, y: 0, z: 1), range: 4, attackRange: 3, team: "Enemy", fullHP: 3, expressionHP: "2*3 - 3"),
        ]),
        
        //3
        ViewModel(map: Map(heightMap: [
                [1,1,1,1],
                [1,1,1,1],
                [1,1,1,1],
                [1,1,1,1],
            ]), entities: [
                Entity(sprite: "Knight", startPosition: Vector3D(x: 1, y: 1, z: 1), range: 3, maxHeightDifference: 1, team: "Player", fullHP: 2, expressionHP: "4 - 2"),
                Entity(sprite: "Rogue", startPosition: Vector3D(x: 1, y: 4, z: 1), range: 3, maxHeightDifference: 1, team: "Enemy", fullHP: 1, expressionHP: "2 - 1"),
                Entity(sprite: "Rogue", startPosition: Vector3D(x: 4, y: 0, z: 1), range: 4, attackRange: 3, team: "Enemy", fullHP: 3, expressionHP: "2*3 - 3"),
            ])
        ]
}
