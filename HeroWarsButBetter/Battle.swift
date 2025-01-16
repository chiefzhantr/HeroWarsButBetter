//
//  Battle.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 16.01.2025.
//

import Foundation

final class Battle {
    
    private let _entities: [Entity]
    var activeTeam: String {
        entities.first {
            $0.hasActed == false
        }?.team ?? ""
    }
    
    var entities: [Entity] {
        checkNextTurn()
        return _entities
    }
    
    init(entities: [Entity]) {
        self._entities = entities
    }
    
    var teams: [String] {
        let teamNames = _entities.map { $0.team }
        return teamNames.reduce(into: [String]()) {
            result, teamName in
            if result.contains(teamName) == false {
                result.append(teamName)
            }
        }
    }
    
    private func checkNextTurn() {
        if _entities.filter( { $0.hasActed == false}).isEmpty {
            for entity in _entities {
                entity.hasActed = false
            }
        }
    }
}
