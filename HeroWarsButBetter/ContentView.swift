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
        Entity(sprite: "Knight", startPosition: Vector3D(x: 1, y: 1, z: 1), range: 3, maxHeightDifference: 1, team: "AI"),
        Entity(sprite: "Knight", startPosition: Vector3D(x: 1, y: 2, z: 1), range: 3, maxHeightDifference: 1, team: "AI"),
        Entity(sprite: "Rogue", startPosition: Vector3D(x: 4, y: 0, z: 1), range: 4, attackRange: 3, team: "Player"),
    ])
    
    let scene = GameScene()
    
    var body: some View { 
        ZStack {
            SpriteView(scene: scene)
            VStack {
                Text("Current team: \(viewModel.battle.activeTeam)")
                    .padding(.top, 32)
                    .foregroundStyle(.white)
                if viewModel.battle.activeTeam != "Player" {
                    Button("Let enemies act") {
                        for entity in viewModel.entities.filter ({
                            $0.team != "Player"
                        }) {
                            entity.currentAction = DummyAction()
                        }
                        viewModel.redraw?()
                    }.buttonStyle(BorderedProminentButtonStyle())
                }
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
