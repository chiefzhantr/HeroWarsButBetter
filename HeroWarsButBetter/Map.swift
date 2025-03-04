//
//  Map.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 03.01.2025.
//

import Foundation

struct Map {
    var colCount: Int
    var rowCount: Int
    let tiles: [Vector2D: Int]
    
    init() {
        colCount = 0
        rowCount = 0
        tiles = [:]
    }
    
    init(heightMap: [[Int]]) {
        rowCount = heightMap.count
        colCount = heightMap.first?.count ?? 0
        var tiles = [Vector2D: Int]()
        
        for row in 0 ..< rowCount {
            for col in 0 ..< colCount {
                let elevation = heightMap[row][col]
                tiles[Vector2D(x: col, y: row)] = elevation
            }
        }
        self.tiles = tiles
    }
    
    subscript(coord: Vector2D) -> Int {
        tiles[coord, default: -1]
    }
    
    func convertTo3D(_ coord: Vector2D) -> Vector3D {
        Vector3D(x: coord.x, y: coord.y, z: self[coord])
    }
    
    func enterable(from: Vector2D, to: Vector2D, maxHeightDifference: Int) -> Bool {
        guard let neighbourHeight = tiles[from], let nodeHeight = tiles[to] else {
            return false
        }
        
        return abs(neighbourHeight - nodeHeight) <= maxHeightDifference
    }
    
    func getNeighboursFor(_ node: Vector2D, maxHeightDifference: Int = Int.max) -> [Vector2D] {
        node.neighbours.filter {
            tiles.keys.contains($0)
        }
        .filter {
            enterable(from: $0, to: node, maxHeightDifference: maxHeightDifference)
        }
    }
    
    func cost(from: Vector2D, to: Vector2D) -> Int {
        1 + abs(self[from] - self[to])
    }
    
    func dijkstra(target: Vector2D, maxHeightDifference: Int = Int.max) -> [Vector2D: Int] {
        var unvisited = Set<Vector2D>()
        var visited = Set<Vector2D>()
        var dist = [Vector2D: Int]()
        
        unvisited.insert(target)
        dist[target] = 0
        var currentNode = target
        while unvisited.isEmpty == false {
            let neighbours = getNeighboursFor(currentNode, maxHeightDifference: maxHeightDifference)
            for neighbour in neighbours {
                if visited.contains(neighbour) == false {
                    unvisited.insert(neighbour)
                }
                let alt = dist[currentNode]! + cost(from: currentNode, to: neighbour)
                if alt < dist[neighbour, default: Int.max] {
                    dist[neighbour] = alt
                }
            }
            
            unvisited.remove(currentNode)
            visited.insert(currentNode)
            
            if let newNode = unvisited.min(by: {
                dist[$0, default: Int.max] < dist[$1, default: Int.max]
            }) {
                currentNode = newNode
            }
        }
        print(dist)
        return dist
    }
    
    func getPath(to coord: Vector2D, using dijkstraMap: [Vector2D: Int], maxHeightDifference: Int = Int.max) -> [Vector2D] {
        var path = [coord]
        
        guard dijkstraMap.keys.contains(coord) else {
            return []
        }
        var current = coord
        while dijkstraMap[current] != 0 {
            let neighbours = current.neighbours
            let newCurrent = neighbours.filter {
                enterable(from: $0, to: current, maxHeightDifference: maxHeightDifference)
            }.min(by: {
                dijkstraMap[$0, default: Int.max] < dijkstraMap[$1, default: Int.max]
            })
            if let newCurrent {
                current = newCurrent
            } else {
                return []
            }
            path.append(current)
        }
        
        return path.reversed()
    }
}
