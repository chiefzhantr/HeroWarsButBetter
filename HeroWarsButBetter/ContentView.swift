//
//  ContentView.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 02.01.2025.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    let scene = GameScene()
    let viewModel = ViewModel(map: Map(heightMap: [
            [1, 1, 1, 1, 1],
            [1, 1, 2, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 2, 1],
            [2, 1, 1, 2, 1],
    ]), entities: [
        Entity(sprite: "Knight", startPosition: Vector3D(x: 1, y: 1, z: 1)),
        Entity(sprite: "Knight", startPosition: Vector3D(x: 1, y: 2, z: 1)),
        Entity(sprite: "Rogue", startPosition: Vector3D(x: 4, y: 0, z: 1)),
    ])
    
    var body: some View { 
        ZStack {
            SpriteView(scene: scene)
            VStack {
                Spacer()
                HStack {
                    Button("Rotate CCW") {
                        scene.rotateCCW()
                    }
                    Button("Rotate CW") {
                        scene.rotateCW()
                    }
                }
            }
            .padding()
        }
        .ignoresSafeArea()
        .onAppear(perform: {
            scene.viewModel = viewModel
        })
    }
}

#Preview {
    ContentView()
}
