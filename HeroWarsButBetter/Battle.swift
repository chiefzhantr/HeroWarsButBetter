//
//  Battle.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 16.01.2025.
//

import Foundation

final class Battle {
    enum BattleState: Equatable {
        case undecided
        case draw
        case won(team: String)
    }
    
    private let _entities: [Entity]
    
    var undefeatedEntities: [Entity] {
        entities.filter {$0.isActive}
    }
    
    var activeTeam: String {
        undefeatedEntities.first {
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
        for entity in _entities {
            if entity.team != "Player" {
                entity.hasActed = true
            }
        }
    }
    
    var state: BattleState {
        let undefeatedEntities = entities.filter {
            $0.isActive
        }
        
        let undefeatedTeams = undefeatedEntities
            .map {
                $0.team
            }
            .reduce(into: [String]()) { result, teamName in
                if result.contains(teamName) == false {
                    result.append(teamName)
                }
            }
        switch undefeatedTeams.count {
        case 0:
            return .draw
        case 1:
            return .won(team: undefeatedTeams[0])
        default:
            return .undecided
        }
    }
}
