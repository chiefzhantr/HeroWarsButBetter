//
//  HeroWarsButBetterTests.swift
//  HeroWarsButBetterTests
//
//  Created by Admin  on 06.12.2024.
//

import XCTest
@testable import HeroWarsButBetter

final class HeroWarsButBetterTests: XCTestCase {
    func test_increasingXbyOne_OffsetsXandYInScreenSpace_by_16and8() {
        let coordinateInWorldSpace = Vector3D(x: 1, y: 0)
        let expectedCoordinateInScreenSpace = Vector2D(x: 16, y: 8)
        XCTAssertEqual(convertWorldToScreen(coordinateInWorldSpace), expectedCoordinateInScreenSpace)
    }
    func test_increasingXbyOne_OffsetsXandYInScreenSpace_by_minus16and8() {
        let coordinateInWorldSpace = Vector3D(x: 0, y: 1)
        let expectedCoordinateInScreenSpace = Vector2D(x: -16, y: 8)
        XCTAssertEqual(convertWorldToScreen(coordinateInWorldSpace), expectedCoordinateInScreenSpace)
    }
    
    func test_linearBehaviourOf_convertWorldToScreen() {
        let worldCoordinates = [
            Vector3D(x: -1, y: 2),
            Vector3D(x: 2, y: 2),
            Vector3D(x: 2, y: -1),
            Vector3D(x: -1, y: 0),
            Vector3D(x: 0, y: -1),
            Vector3D(x: -1, y: -1),
        ]
        let expectedCoordinates = [
            Vector2D(x: -48, y: 8),
            Vector2D(x: 0, y: 32),
            Vector2D(x: 48, y: 8),
            Vector2D(x: -16, y: -8),
            Vector2D(x: 16, y: -8),
            Vector2D(x: 0, y: -16),
        ]
        for i in 0 ..< worldCoordinates.count {
            XCTAssertEqual(convertWorldToScreen(worldCoordinates[i]), expectedCoordinates[i])
        }
    }
    
    func test_convertWorldToScreen_linearity_for3rdDimension() {
        let worldSpaceCoordinates = [
            Vector3D(x: 1, y: 0, z: 1),
            Vector3D(x: 1, y: 1, z: 2),
            Vector3D(x: -1, y: 0, z: 1),
            Vector3D(x: -1, y: 2, z: 2)
        ]
        
        let expectedInScreenSpaceCoordinates = [
            Vector2D(x: 16, y: 16),
            Vector2D(x: 0, y: 32),
            Vector2D(x: -16, y: 0),
            Vector2D(x: -48, y: 24)
        ]
        for i in 0 ..< worldSpaceCoordinates.count {
            XCTAssertEqual(convertWorldToScreen(worldSpaceCoordinates[i]), expectedInScreenSpaceCoordinates[i])
        }
    }
    
    func test_convertWorldToZPosition_for2DCoordinates() {
        let testcases: [(coord: Vector3D, before: [Vector3D], behind: [Vector3D])] = [
            (Vector3D(x: -1, y: -1), [Vector3D(x: -1, y: 0), Vector3D(x: 0, y: -1)], []),
            (Vector3D(x: 0, y: 0), [Vector3D(x: 0, y: 1), Vector3D(x: 1, y: 0)], [Vector3D(x: -1, y: 0), Vector3D(x: 0, y: -1)]),
            (Vector3D(x: 1, y: 0), [Vector3D(x: 1, y: 1), Vector3D(x: 2, y: 0)], [Vector3D(x: 0, y: 0), Vector3D(x: 1, y: -1)])
        ]
        
        for testcase in testcases {
            for beforeCoord in testcase.before {
                XCTAssertGreaterThan(convertWorldToZPosition(testcase.coord), convertWorldToZPosition(beforeCoord))
            }
            for behindCoord in testcase.behind {
                XCTAssertLessThan(convertWorldToZPosition(testcase.coord), convertWorldToZPosition(behindCoord))
            }
        }
    }
    
    func test_convertWorldToZPosition_for3DCoordinates() {
        let testcases: [(coord: Vector3D, before: [Vector3D], behind: [Vector3D])] = [
            (Vector3D(x: -1, y: 0, z: 1), [Vector3D(x: 0, y: 0, z: 0), Vector3D(x: 0, y: 1, z: 0)], []),
            (Vector3D(x: 1, y: 1, z: 1), [Vector3D(x: 1, y: 1, z: 0), Vector3D(x: 1, y: 2, z: 0)], [Vector3D(x: 1, y: 1, z: 2), Vector3D(x: 1, y: 0, z: 1)]),
            (Vector3D(x: -1, y: 2, z: 1), [Vector3D(x: -1, y: 2, z: 0), Vector3D(x: 0, y: 2, z: 0)], [Vector3D(x: -1, y: 2, z: 2)])
        ]
        
        for testcase in testcases {
            for beforeCoord in testcase.before {
                XCTAssertGreaterThan(convertWorldToZPosition(testcase.coord), convertWorldToZPosition(beforeCoord))
            }
            for behindCoord in testcase.behind {
                XCTAssertLessThan(convertWorldToZPosition(testcase.coord), convertWorldToZPosition(behindCoord))
            }
        }
    }
    
    func test_rotateCoordinate_returnsInputCoordinate_forDefaultRotation() {
        let inputCoordinates = [
            Vector3D(x: -1, y: 1, z: 0),
            Vector3D(x: -3, y: 1, z: -2),
            Vector3D(x: 3, y: 3, z: 2),
        ]
        
        for coord in inputCoordinates {
            XCTAssertEqual(rotateCoordinate(coord, direction: .defaultRotation), coord)
        }
    }
    
    func test_rotateCoordinate_returnsInputCoordinate_forClockWiseRotation() {
        let inputCoordinates = [
            Vector3D(x: 2, y: -5, z: 0),
            Vector3D(x: 3, y: 1, z: 0),
            Vector3D(x: -7, y: 3, z: 0),
            Vector3D(x: -2, y: -4, z: 0),
        ]
        
        let expectedCoordinates = [
            Vector3D(x: 5, y: 2, z: 0),
            Vector3D(x: -1, y: 3, z: 0),
            Vector3D(x: -3, y: -7, z: 0),
            Vector3D(x: 4, y: -2, z: 0),
        ]
        
        for i in 0 ..< inputCoordinates.count {
            XCTAssertEqual(rotateCoordinate(inputCoordinates[i], direction: .defaultRotation.rotated90DegreesCounterClockwise), expectedCoordinates[i])
        }
    }
    
    func test_rotateCoordinate_doesNotChangeZProperty() {
        let inputCoordinates = [
            Vector3D(x: 2, y: -5, z: 5),
            Vector3D(x: 3, y: 1, z: -2),
            Vector3D(x: -7, y: 3, z: 4),
            Vector3D(x: -2, y: -4, z: -8),
        ]
        
        for coord in inputCoordinates {
            XCTAssertEqual(rotateCoordinate(coord, direction: .defaultRotation.rotated90DegreesClockwise).z, coord.z)
        }
    }
    
    func test_convertWorldToScreen_takesRotationIntoAccount() {
        let rotations: [Rotation] = [.degrees45, .degrees135, .degrees225, .degrees315]
        
        for _ in 0 ..< 20 {
            for rotation in rotations {
                let coord = Vector3D.random
                let convertedCoordinate = convertWorldToScreen(coord, direction: rotation)
                let rotatedCoordinate = rotateCoordinate(coord, direction: rotation)
                let expectedCoordinate = convertWorldToScreen(rotatedCoordinate)
                XCTAssertEqual(convertedCoordinate, expectedCoordinate)
            }
        }
    }
    
    func test_convertWorldToZPosition_takesRotationIntoAccount() {
        let rotations: [Rotation] = [.degrees45, .degrees135, .degrees225, .degrees315]
        
        for _ in 0 ..< 20 {
            for rotation in rotations {
                let coord = Vector3D.random
                let convertedCoordinate = convertWorldToZPosition(coord, direction: rotation)
                let rotatedCoordinate = rotateCoordinate(coord, direction: rotation)
                let expectedCoordinate = convertWorldToZPosition(rotatedCoordinate)
                XCTAssertEqual(convertedCoordinate, expectedCoordinate)
            }
        }
    }
    
    func test_rotationWithReferenceRotation_basedOnDefaultRotation_alwaysReturnsExistingRotation() {
        for rotation in [Rotation.degrees45, Rotation.degrees135, Rotation.degrees225, Rotation.degrees315] {
            XCTAssertEqual(rotation.withReferenceRotation(.defaultRotation), rotation)
        }
    }
    
    func test_rotationWithReferenceRotation_takesReferenceRotationIntoAccount() {
        let testcases: [(lookRotation: Rotation, referenceRotation: Rotation, resultingRotation: Rotation)] = [
            (.degrees45, .degrees135, .degrees135),
            (.degrees135, .degrees135, .degrees225),
            (.degrees225, .degrees135, .degrees315),
            (.degrees315, .degrees135, .degrees45),
            (.degrees45, .degrees225, .degrees225),
            (.degrees135, .degrees225, .degrees315),
            (.degrees225, .degrees225, .degrees45),
            (.degrees315, .degrees225, .degrees135),
            (.degrees45, .degrees315, .degrees315),
            (.degrees135, .degrees315, .degrees45),
            (.degrees225, .degrees315, .degrees135),
            (.degrees315, .degrees315, .degrees225),
        ]
        
        for testcase in testcases {
            XCTAssertEqual(testcase.lookRotation.withReferenceRotation(testcase.referenceRotation), testcase.resultingRotation)
        }
    }
    
    func test_getIdleAnimationFirstFrameNameForEntity_whenKnightPassedIn() {
        let testcases: [(sprite: String, rotation: Rotation, expected: String)] = [
            ("Knight", .degrees45, "Knight_Idle_45_0"),
            ("Knight", .degrees135, "Knight_Idle_135_0"),
            ("Knight", .degrees225, "Knight_Idle_225_0"),
            ("Knight", .degrees315, "Knight_Idle_315_0"),
        ]
        
        for testcase in testcases {
            let entity = Entity(sprite: testcase.sprite, startPosition: .zero)
            entity.rotation = testcase.rotation
            XCTAssertEqual(getIdleAnimationFirstFrameNameForEntity(entity), testcase.expected)
        }
    }
    
    func test_getIdleAnimationFirstFrameNameForEntity_whenKnightPassedIn_andMapViewIsRotated() {
        let testcases: [(sprite: String, rotation: Rotation, expected: String)] = [
            ("Knight", .degrees45, "Knight_Idle_135_0"),
            ("Knight", .degrees135, "Knight_Idle_225_0"),
            ("Knight", .degrees225, "Knight_Idle_315_0"),
            ("Knight", .degrees315, "Knight_Idle_45_0"),
        ]
        
        for testcase in testcases {
            let entity = Entity(sprite: testcase.sprite, startPosition: .zero)
            entity.rotation = testcase.rotation
            XCTAssertEqual(getIdleAnimationFirstFrameNameForEntity(entity, referenceRotation: .degrees135), testcase.expected)
        }
    }
    
    func test_getIdleAnimationFirstFrameNameForEntity_whenRoguePassedIn() {
        let testcases: [(sprite: String, rotation: Rotation, expected: String)] = [
            ("Rogue", .degrees45,  "Rogue_2H_Melee_Idle_45_0"),
            ("Rogue", .degrees135, "Rogue_2H_Melee_Idle_135_0"),
            ("Rogue", .degrees225, "Rogue_2H_Melee_Idle_225_0"),
            ("Rogue", .degrees315, "Rogue_2H_Melee_Idle_315_0"),
        ]
        
        for testcase in testcases {
            let entity = Entity(sprite: testcase.sprite, startPosition: .zero)
            entity.rotation = testcase.rotation
            XCTAssertEqual(getIdleAnimationFirstFrameNameForEntity(entity), testcase.expected)
        }
    }
    
    func test_getIdleAnimationFirstFrameNameForEntity_whenRoguePassedIn_andMapViewIsRotated() {
        let testcases: [(sprite: String, rotation: Rotation, expected: String)] = [
            ("Rogue", .degrees45,  "Rogue_2H_Melee_Idle_135_0"),
            ("Rogue", .degrees135, "Rogue_2H_Melee_Idle_225_0"),
            ("Rogue", .degrees225, "Rogue_2H_Melee_Idle_315_0"),
            ("Rogue", .degrees315, "Rogue_2H_Melee_Idle_45_0"),
        ]
        
        for testcase in testcases {
            let entity = Entity(sprite: testcase.sprite, startPosition: .zero)
            entity.rotation = testcase.rotation
            XCTAssertEqual(getIdleAnimationFirstFrameNameForEntity(entity, referenceRotation: .degrees135), testcase.expected)
        }
    }
    
    func test_getAnimationNameForEntity_whenKnightIsPassedIn() {
        let testcases: [(sprite: String, animation: String, rotation: Rotation, expected: String)] = [
            ("Knight", "Idle", .degrees45, "Knight_Idle_45"),
            ("Knight", "Idle", .degrees135, "Knight_Idle_135"),
            ("Knight", "Idle", .degrees225, "Knight_Idle_225"),
            ("Knight", "Idle", .degrees315, "Knight_Idle_315"),
            ("Knight", "Walk", .degrees45, "Knight_Walking_B_45"),
            ("Knight", "Walk", .degrees135, "Knight_Walking_B_135"),
            ("Knight", "Walk", .degrees225, "Knight_Walking_B_225"),
            ("Knight", "Walk", .degrees315, "Knight_Walking_B_315"),
        ]
        
        for testcase in testcases {
            let entity = Entity(sprite: testcase.sprite, startPosition: .zero)
            entity.rotation = testcase.rotation
            XCTAssertEqual(getAnimationNameForEntity(entity, animation: testcase.animation), testcase.expected)
        }
    }
     
    func test_getAnimationNameForEntity_whenKnightPassedIn_andMapViewIsRotated() {
        let testcases: [(sprite: String, animation: String, rotation: Rotation, expected: String)] = [
            ("Knight", "Idle", .degrees45,  "Knight_Idle_135"),
            ("Knight", "Idle", .degrees135, "Knight_Idle_225"),
            ("Knight", "Idle", .degrees225, "Knight_Idle_315"),
            ("Knight", "Idle", .degrees315, "Knight_Idle_45"),
            ("Knight", "Walk", .degrees45,  "Knight_Walking_B_135"),
            ("Knight", "Walk", .degrees135, "Knight_Walking_B_225"),
            ("Knight", "Walk", .degrees225, "Knight_Walking_B_315"),
            ("Knight", "Walk", .degrees315, "Knight_Walking_B_45"),
        ]
        
        for testcase in testcases {
            let entity = Entity(sprite: testcase.sprite, startPosition: .zero)
            entity.rotation = testcase.rotation
            XCTAssertEqual(getAnimationNameForEntity(entity, animation: testcase.animation, referenceRotation: .degrees135), testcase.expected)
        }
    }
    
    func test_getAnimationNameForEntity_whenRoguePassedIn() {
        let testcases: [(sprite: String, animation: String, rotation: Rotation, expected: String)] = [
            ("Rogue", "Idle", .degrees45,  "Rogue_2H_Melee_Idle_45"),
            ("Rogue", "Idle", .degrees135, "Rogue_2H_Melee_Idle_135"),
            ("Rogue", "Idle", .degrees225, "Rogue_2H_Melee_Idle_225"),
            ("Rogue", "Idle", .degrees315, "Rogue_2H_Melee_Idle_315"),
            ("Rogue", "Walk", .degrees45,  "Rogue_Walking_C_45"),
            ("Rogue", "Walk", .degrees135, "Rogue_Walking_C_135"),
            ("Rogue", "Walk", .degrees225, "Rogue_Walking_C_225"),
            ("Rogue", "Walk", .degrees315, "Rogue_Walking_C_315"),
        ]
        
        for testcase in testcases {
            let entity = Entity(sprite: testcase.sprite, startPosition: .zero)
            entity.rotation = testcase.rotation
            XCTAssertEqual(getAnimationNameForEntity(entity, animation: testcase.animation), testcase.expected)
        }
    }
    
    func test_getAnimationNameForEntity_whenRoguePassedIn_andMapViewIsRotated() {
        let testcases: [(sprite: String, animation: String, rotation: Rotation, expected: String)] = [
            ("Rogue", "Idle", .degrees45,  "Rogue_2H_Melee_Idle_135"),
            ("Rogue", "Idle", .degrees135, "Rogue_2H_Melee_Idle_225"),
            ("Rogue", "Idle", .degrees225, "Rogue_2H_Melee_Idle_315"),
            ("Rogue", "Idle", .degrees315, "Rogue_2H_Melee_Idle_45"),
            ("Rogue", "Walk", .degrees45,  "Rogue_Walking_C_135"),
            ("Rogue", "Walk", .degrees135, "Rogue_Walking_C_225"),
            ("Rogue", "Walk", .degrees225, "Rogue_Walking_C_315"),
            ("Rogue", "Walk", .degrees315, "Rogue_Walking_C_45"),
        ]
        
        for testcase in testcases {
            let entity = Entity(sprite: testcase.sprite, startPosition: .zero)
            entity.rotation = testcase.rotation
            XCTAssertEqual(getAnimationNameForEntity(entity, animation: testcase.animation, referenceRotation: .degrees135), testcase.expected)
        }
    }
}
