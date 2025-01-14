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
    
    func test_moveAction_description() {
        let path = [
            Vector3D(x: 2, y: 2, z: 3),
            Vector3D(x: 2, y: 1, z: 3),
            Vector3D(x: 2, y: 1, z: 1),
        ]
        
        let action = MoveAction(path: path)
        XCTAssertEqual(action.description, "Move to (\(path[2].x),\(path[2].y))")
    }
    
    func test_moveAction_description_emptyDescription() {
        let action = MoveAction(path: [])
        XCTAssertEqual(action.description, "Move to ...")
    }
    
    func test_moveAction_canComplete_returnsTrue_whenPathIsNotEmpty() {
        let action = MoveAction(path: [Vector3D(x: 1, y: 2, z: 3)])
        XCTAssertEqual(action.canComplete, true)
    }
    
    func test_moveAction_canComplete_returnsTrue_whenPathIsEmpty() {
        let action = MoveAction(path: [])
        XCTAssertEqual(action.canComplete, false)
    }
    
    func test_moveAction_reachableTiles_returns_tilesWithinRange_ofEntity() {
        let entity = Entity(sprite: "Example Entity", startPosition: .init(x: 1, y: 1, z: 1))
        let expectedReachableTiles = [
            Vector3D(x: 0, y: 2, z: 1),
            Vector3D(x: 1, y: 4, z: 1),
            Vector3D(x: 0, y: 0, z: 1),
            Vector3D(x: 0, y: 1, z: 1),
            Vector3D(x: 1, y: 2, z: 1),
            Vector3D(x: 2, y: 0, z: 1),
            Vector3D(x: 3, y: 0, z: 1),
            Vector3D(x: 1, y: 1, z: 1),
            Vector3D(x: 1, y: 3, z: 1),
            Vector3D(x: 0, y: 3, z: 1),
            Vector3D(x: 2, y: 1, z: 3),
            Vector3D(x: 1, y: 0, z: 1),
        ]
        
        let reachableTiles = MoveAction.reachableTiles(in: exampleMap, for: entity)
        
        XCTAssertEqual(reachableTiles.count, expectedReachableTiles.count)
        
        for reachableTile in reachableTiles {
            XCTAssertTrue(expectedReachableTiles.contains(reachableTile))
        }
    }
    
    func test_moveAction_make_returnsNil_whenCoord_thatIsNotIn_reachableTiles_isPassedIn() {
        let entity = Entity(sprite: "Example Entity", startPosition: .init(x: 1, y: 1, z: 1))
        let maybeMoveAction = MoveAction.make(in: exampleMap, for: entity, targetting: Vector3D(x: 4, y: 4, z: 1))
        XCTAssertNil(maybeMoveAction)
    }
    
    func test_moveAction_reachableTiles_returns_lessTilesWithingRange_for_entity_with_shorterRange() {
        let shortRangeEntity = Entity(sprite: "Short Range Entity", startPosition: .init(x: 2, y: 2, z: 1), range: 2)
        let longRangeEntity = Entity(sprite: "Long Range Entity", startPosition: .init(x: 2, y: 2, z: 1))
        
        let map = Map(heightMap: [
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1]
        ])
        
        XCTAssertLessThan(MoveAction.reachableTiles(in: map, for: shortRangeEntity).count, MoveAction.reachableTiles(in: map, for: longRangeEntity).count)
    }
    
    func test_moveAction_reachableTiles_takesMaximumHeightDifference_intoAccount() {
        let entity = Entity(sprite: "Example Entity", startPosition: Vector3D(x: 0, y: 0, z: 1), range: Int.max, maxHeightDifference: 1)
        let reachableTiles = MoveAction.reachableTiles(in: Map(heightMap: [
        [1,1,1],
        [1,3,1],
        [1,1,1],
        ]), for: entity)
        
        let expectedReachableTiles = [
            Vector3D(x: 0, y: 0, z: 1),
            Vector3D(x: 1, y: 0, z: 1),
            Vector3D(x: 2, y: 0, z: 1),
            Vector3D(x: 0, y: 1, z: 1),
            Vector3D(x: 2, y: 1, z: 1),
            Vector3D(x: 0, y: 2, z: 1),
            Vector3D(x: 1, y: 2, z: 1),
            Vector3D(x: 2, y: 2, z: 1),
        ]
        
        XCTAssertEqual(reachableTiles.count, expectedReachableTiles.count)
        for reachableTile in reachableTiles {
            XCTAssertTrue(expectedReachableTiles.contains(reachableTile))
        }
    }
    
    func test_moveAction_make_takesMaximumHeightDifference_intoAccount() throws {
        let entity = Entity(sprite: "Example Entity", startPosition: .zero, range: Int.max, maxHeightDifference: 1)
        
        let moveAction = try XCTUnwrap(MoveAction.make(in: exampleMap, for: entity, targetting: Vector3D(x: 2, y: 1, z: 3)))
        let expected = [
            Vector3D(x: 0, y: 0, z: 1),
            Vector3D(x: 0, y: 1, z: 1),
            Vector3D(x: 0, y: 2, z: 1),
            Vector3D(x: 0, y: 3, z: 1),
            Vector3D(x: 1, y: 3, z: 1),
            Vector3D(x: 2, y: 3, z: 2),
            Vector3D(x: 2, y: 2, z: 3),
            Vector3D(x: 2, y: 1, z: 3),
        ]
        
        XCTAssertEqual(moveAction.path, expected)
    }
}
