//
//  ContentView.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 02.01.2025.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var viewModel = ViewModel(map: Map(heightMap: [
            [1, 1, 1, 1, 1],
            [1, 1, 2, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 2, 1],
            [2, 1, 1, 2, 1],
    ]), entities: [
        Entity(sprite: "Knight", startPosition: Vector3D(x: 1, y: 1, z: 1), maxHeightDifference: 1),
        Entity(sprite: "Knight", startPosition: Vector3D(x: 1, y: 2, z: 1), maxHeightDifference: 1),
        Entity(sprite: "Rogue", startPosition: Vector3D(x: 4, y: 0, z: 1), range: 4),
    ])
    
    let scene = GameScene()
    
    var body: some View { 
        ZStack {
            SpriteView(scene: scene)
            VStack {
                HStack {
                    Spacer()
                    if viewModel.selectedEntity != nil {
                        EntityView(viewModel: viewModel)
                    }
                }
                if let currentAction = viewModel.currentAction, currentAction.canComplete {
                    Button("Execute \(currentAction.description)") {
                        print("Execute \(currentAction)")
                        viewModel.commitAction()
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                }
                Spacer()
                if let selectedTile = viewModel.selectedTile {
                    Text("Selected tile: \(selectedTile)")
                        .foregroundStyle(.white)
                }
                
                if let selectedEntity = viewModel.selectedEntity {
                    Text("Selected entity: \(selectedEntity.sprite)")
                        .foregroundStyle(.white)
                }
                
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

//#Preview {
//    ContentView()
//}
