//
//  EntityTests.swift
//  HeroWarsButBetterTests
//
//  Created by Admin  on 06.01.2025.
//

import Foundation
import XCTest
@testable import HeroWarsButBetter

final class EntityTests: XCTestCase {
    func test_copy_returnsNewInstance() {
        let entity = Entity(sprite: "Example Sprite", startPosition: .zero)
        let copy = entity.copy()
        XCTAssertTrue(entity !== copy)
    }
    
    func test_copy_returnAnInstanceWithSamePropertiesAsOriginal() {
        let entity = Entity(sprite: UUID().uuidString, startPosition: .random)
        entity.rotation = .degrees225
        entity.currentHP -= 1
        entity.currentAction = DummyAction()
        
        let copy = entity.copy()
        XCTAssertEqual(copy.sprite, entity.sprite)
        XCTAssertEqual(copy.position, entity.position)
        XCTAssertEqual(copy.rotation, entity.rotation)
        XCTAssertEqual(copy.currentHP, entity.currentHP)
        XCTAssertEqual(copy.currentAction?.description, entity.currentAction?.description)
    }
     
    func test_completeCurrentAction_setsCurrentActionToNil() {
        let entity = Entity(sprite: "Entity", startPosition: .zero)
        entity.currentAction = DummyAction()
        entity.completeCurrentAction()
        
        XCTAssertNil(entity.currentAction)
    }
    
    func test_completeCurrentAction_callsActionComplete() {
        struct BlockAction: Action {
            static func make(in map: HeroWarsButBetter.Map, for entity: HeroWarsButBetter.Entity, targetting: HeroWarsButBetter.Vector3D, allEntities: [Entity] = []) -> BlockAction? {
                BlockAction(block: {})
            }
            
            let block: () -> Void
            func complete() {
                block()
            }
        }
        
        let entity = Entity(sprite: "Entity", startPosition: .zero)
        var count = 0
        entity.currentAction = BlockAction {
            count += 1
        }
        entity.completeCurrentAction()
        XCTAssertEqual(count, 1)
    }
    
    func test_completeCurrentAction_sets_hasActed_toTrue_whenCurrentAction_isDone() {
        let entity = Entity(sprite: "Entity", startPosition: .zero)
        entity.currentAction = DummyAction()
        entity.completeCurrentAction()
        XCTAssertTrue(entity.hasActed)
    }
    
    func test_completeCurrentAction_doesNotSet_hasActed_toTrue_whenCurrentAction_doesNotEndTurn() {
        struct DummyActionThatDoesNotEndTurn: Action {
            static func make(in map: HeroWarsButBetter.Map, for entity: HeroWarsButBetter.Entity, targetting: HeroWarsButBetter.Vector3D, allEntities: [HeroWarsButBetter.Entity]) -> DummyActionThatDoesNotEndTurn? {
                DummyActionThatDoesNotEndTurn()
            }
            let endsTurn = false
        }
        let entity = Entity(sprite: "Entity", startPosition: .zero)
        entity.currentAction = DummyActionThatDoesNotEndTurn()
        entity.completeCurrentAction()
        XCTAssertFalse(entity.hasActed)
    }
    
    func test_takeDamage_lowersHP() {
        let entity = Entity(sprite: "Entity", startPosition: .zero)
        let originalHP = entity.currentHP
        
        entity.takeDamage(3)
        
        XCTAssertEqual(entity.currentHP, originalHP - 3)
    }
    
    func test_takeDamage_setsCurrentAction_toTakeDamage() throws {
        let entity = Entity(sprite: "Entity", startPosition: .zero)
        
        entity.takeDamage(3)
        
        let currentAction = try XCTUnwrap(entity.currentAction)
        XCTAssertTrue(currentAction is TakeDamageAction)
    }

    func test_aNewEntity_doesNotHaveATeam() {
        let entity = Entity(sprite: "Entity", startPosition: .zero)
        XCTAssertEqual(entity.team, "")
    }
    
    func test_canSetAteam_forANewEntity_whenPassingInTeam() {
        let entity = Entity(sprite: "Entity", startPosition: .zero, team: "A-team")
        XCTAssertEqual(entity.team, "A-team")
    }
    
    
}
