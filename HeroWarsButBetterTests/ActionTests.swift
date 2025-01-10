//
//  ActionTest.swift
//  HeroWarsButBetterTests
//
//  Created by Admin  on 07.01.2025.
//

import Foundation
import XCTest

@testable import HeroWarsButBetter

final class ActionTests: XCTestCase {
    
    let exampleMap = Map(heightMap: [
        [1,1,1,1,1,2,3],
        [1,1,3,3,3,1,1],
        [1,1,3,5,4,1,5],
        [1,1,2,2,2,1,4],
        [1,1,1,1,1,1,3],
        [1,1,1,1,1,1,2],
        [1,1,1,1,1,1,1],
    ])
    
    func test_moveAction_complete_setsPosition() {
        let entity = Entity(sprite: "Example", startPosition: .zero)
        let path = [
            Vector3D(x: 0, y: 0, z: 0),
            Vector3D(x: 0, y: 1, z: 1),
            Vector3D(x: 0, y: 2, z: 1),
            Vector3D(x: 1, y: 2, z: 1),
            Vector3D(x: 2, y: 2, z: 2),
            Vector3D(x: 3, y: 2, z: 2),
        ]
        let moveAction = MoveAction(owner: entity, path: path)
        moveAction.complete()
        XCTAssertEqual(entity.position, path.last)
    }
    
    func test_moveAction_complete_setsRotation() {
        let entity = Entity(sprite: "Example", startPosition: .zero)
        let path = [
            Vector3D(x: 0, y: 0, z: 0),
            Vector3D(x: 0, y: -1, z: 1),
            Vector3D(x: 0, y: -2, z: 1),
        ]
        let moveAction = MoveAction(owner: entity, path: path)
        moveAction.complete()
        XCTAssertEqual(entity.rotation, .degrees315)
    }
    
    func test_moveAction_make_isBasedOnPathFinding() throws {
        let entity = Entity(sprite: "ExampleEntity", startPosition: .zero)
        let targetPosition = Vector2D(x: 1, y: 1)
        let expectedPath = [
            Vector3D(x: 0, y: 0, z: 1),
            Vector3D(x: 0, y: 1, z: 1),
            Vector3D(x: 1, y: 1, z: 1),
        ]
        
        let action = try XCTUnwrap(MoveAction.make(in: exampleMap, for: entity, targetting: exampleMap.convertTo3D(targetPosition)))
        
        XCTAssertEqual(action.path, expectedPath)
    }
}
