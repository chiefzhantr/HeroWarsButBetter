//
//  MapTests.swift
//  HeroWarsButBetterTests
//
//  Created by Admin  on 03.01.2025.
//

import Foundation
import XCTest
@testable import HeroWarsButBetter

final class MapTests: XCTestCase {
    
    static let EXAMPLE_HEIGHTMAP = [
        [1, 1, 2, 1, 1],
        [1, 1, 1, 1, 1],
        [1, 1, 2, 1, 1],
        [1, 1, 1, 1, 1],
        [1, 1, 1, 2, 1],
        [2, 1, 1, 2, 1],
    ]
    
    static let EXAMPLE_HEIGHT_ROW_COUNT = EXAMPLE_HEIGHTMAP.count
    static let EXAMPLE_HEIGHT_COL_COUNT = EXAMPLE_HEIGHTMAP[0].count
    static let EXAMPLE_HEIGHTMAP_COORDS_OUTSIDE_OF_MAP = [
        Vector2D(x: -1, y: EXAMPLE_HEIGHT_ROW_COUNT - 1),
        Vector2D(x: -1, y: EXAMPLE_HEIGHT_ROW_COUNT),
        Vector2D(x: -1, y: EXAMPLE_HEIGHT_ROW_COUNT + 1),
        Vector2D(x: 0, y: EXAMPLE_HEIGHT_ROW_COUNT + 1),
        Vector2D(x: 1, y: EXAMPLE_HEIGHT_ROW_COUNT + 1),
        
        Vector2D(x: EXAMPLE_HEIGHT_COL_COUNT - 1, y: EXAMPLE_HEIGHT_ROW_COUNT + 1),
        Vector2D(x: EXAMPLE_HEIGHT_COL_COUNT, y: EXAMPLE_HEIGHT_ROW_COUNT + 1),
        Vector2D(x: EXAMPLE_HEIGHT_COL_COUNT + 1, y: EXAMPLE_HEIGHT_ROW_COUNT + 1),
        Vector2D(x: EXAMPLE_HEIGHT_COL_COUNT + 1, y: EXAMPLE_HEIGHT_ROW_COUNT),
        Vector2D(x: EXAMPLE_HEIGHT_COL_COUNT + 1, y: EXAMPLE_HEIGHT_ROW_COUNT - 1),
        
        Vector2D(x: -1, y: 1),
        Vector2D(x: -1, y: 0),
        Vector2D(x: -1, y: -1),
        Vector2D(x: 0, y: -1),
        Vector2D(x: 1, y: -1),
        
        Vector2D(x: EXAMPLE_HEIGHT_COL_COUNT - 1, y: -1),
        Vector2D(x: EXAMPLE_HEIGHT_COL_COUNT, y: -1),
        Vector2D(x: EXAMPLE_HEIGHT_COL_COUNT + 1, y: -1),
        Vector2D(x: EXAMPLE_HEIGHT_COL_COUNT + 1, y: 0),
        Vector2D(x: EXAMPLE_HEIGHT_COL_COUNT + 1, y: 1),
    ]
    
    func test_emptyMap_hasZeroWidthAndHeight() {
        let map = Map()
        XCTAssertEqual(map.colCount, 0)
        XCTAssertEqual(map.rowCount, 0)
    }
    
    func test_create_withHeightMap_setsHeightAndWidth() {
        let map = Map(heightMap: [
            [1, 1, 2, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 2, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 2, 1],
            [2, 1, 1, 2, 1],
        ])
        
        XCTAssertEqual(map.rowCount, 6)
        XCTAssertEqual(map.colCount, 5)
    }
    
    func test_subscript_returnsNegativeHeight_forCoordOutsideOfHeightMap() {
        let map = Map(heightMap: Self.EXAMPLE_HEIGHTMAP)
        
        for testCoord in Self.EXAMPLE_HEIGHTMAP_COORDS_OUTSIDE_OF_MAP {
            XCTAssertLessThan(map[testCoord], 0)
        }
    }
    
    func test_subscript_returnsHeight_forCoordWithinHeightMap() {
        let map = Map(heightMap: Self.EXAMPLE_HEIGHTMAP)
        for row in 0 ..< map.rowCount {
            for col in 0 ..< map.colCount {
                XCTAssertEqual(map[Vector2D(x: col, y: row)], Self.EXAMPLE_HEIGHTMAP[row][col])
            }
        }
    }
    
    func test_convertTo3D_xySameAsInput() {
        let map = Map(heightMap: Self.EXAMPLE_HEIGHTMAP)
        for y in -3 ..< 3 {
            for x in -3 ..< 3 {
                let coord = Vector2D(x: x, y: y)
                let result = map.convertTo3D(coord)
                XCTAssertEqual(result.xy, coord)
            }
        }
    }
    
    func test_convertTo3D_zProperty_isElevation() {
        let map = Map(heightMap: Self.EXAMPLE_HEIGHTMAP)
        for y in -3 ..< 3 {
            for x in -3 ..< 3 {
                let coord = Vector2D(x: x, y: y)
                let result = map.convertTo3D(coord)
                XCTAssertEqual(result.z, map[coord])
            }
        }
    }
}
