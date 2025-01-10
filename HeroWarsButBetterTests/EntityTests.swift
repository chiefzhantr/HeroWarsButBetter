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
        
        let copy = entity.copy()
        XCTAssertEqual(copy.sprite, entity.sprite)
        XCTAssertEqual(copy.position, entity.position)
        XCTAssertEqual(copy.rotation, entity.rotation)
    }
     
    func test_completeCurrentAction_setsCurrentActionToNil() {
        let entity = Entity(sprite: "Entity", startPosition: .zero)
        entity.currentAction = DummyAction()
        entity.completeCurrentAction()
        
        XCTAssertNil(entity.currentAction)
    }
    
    func test_completeCurrentAction_callsActionComplete() {
        struct BlockAction: Action {
            static func make(in map: HeroWarsButBetter.Map, for entity: HeroWarsButBetter.Entity, targetting: HeroWarsButBetter.Vector3D) -> BlockAction? {
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
}
