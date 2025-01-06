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
}
