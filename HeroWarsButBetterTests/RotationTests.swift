//
//  RotationTests.swift
//  HeroWarsButBetterTests
//
//  Created by Admin  on 06.01.2025.
//

import Foundation
import XCTest

@testable import HeroWarsButBetter

final class RotationTests: XCTestCase {
    func test_withReferenceRotation_basedOnDefaultRotation_alwaysReturnsExistingRotation() {
        for rotation in [Rotation.degrees45, Rotation.degrees135, Rotation.degrees225, Rotation.degrees315] {
            XCTAssertEqual(rotation.withReferenceRotation(.defaultRotation), rotation)
        }
    }
    
    func test_withReferenceRotation_takesReferenceRotationIntoAccount() {
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
    
    func test_fromLookRotation_returnsCorrectRotation_forCartesianVectors_ofLengthOne() {
        let testcases: [(lookDirection: Vector2D, expected: Rotation)] = [
            (Vector2D(x: 0, y: 1), .degrees135),
            (Vector2D(x: 1, y: 0), .degrees45),
            (Vector2D(x: 0, y: -1), .degrees315),
            (Vector2D(x: -1, y: 0), .degrees225)
        ]
        
        for testcase in testcases {
            XCTAssertEqual(Rotation.fromLookDirection(testcase.lookDirection), testcase.expected)
        }
    }
    
    func test_fromLookRotation_returnNil_whenAVectorOfZeroLengthIsPassedIn() {
        XCTAssertNil(Rotation.fromLookDirection(.zero))
    }
}
