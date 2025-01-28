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
//            [1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1],
//            [1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1],
//            [1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 2, 1],
//            [1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1],
//            [1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1],
//            [1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1],
//            [1, 1, 1, 2, 1, 1, 1, 1, 2, 3, 2, 1, 1],
//            [1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1],
//            [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1],
//            [1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1],
//            [1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1],
//            [1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1],
//            [1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1],
//            [1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1],
//            [1, 1, 1, 1, 1, 2, 3, 2, 1, 1, 1, 2, 1],
        [1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1],
    ]), entities: [
        Entity(sprite: "Knight", startPosition: Vector3D(x: 1, y: 1, z: 1), range: 3, maxHeightDifference: 1, team: "AI"),
        Entity(sprite: "Knight", startPosition: Vector3D(x: 1, y: 4, z: 1), range: 3, maxHeightDifference: 1, team: "AI"),
        Entity(sprite: "Rogue", startPosition: Vector3D(x: 4, y: 0, z: 1), range: 4, attackRange: 3, team: "Player"),
    ])
    
    let scene = GameScene()
    
    var body: some View { 
        ZStack {
            SpriteView(scene: scene)
            Color.green.opacity(0.0001)
                .onTapGesture { screenCord in
                    scene.processTap(at: screenCord)
                }
            VStack {
                Text("State: \(viewModel.battle.state)")
                    .padding(.top, 32)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("Current team: \(viewModel.battle.activeTeam)")
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
                    Button("Zoom Out", systemImage: "minus.magnifyingglass") {
                        scene.zoomOut()
                    }
                    .font(.largeTitle)
                    .labelStyle(.iconOnly)
                    .padding()
                    
                    Button("Zoom In", systemImage: "plus.magnifyingglass") {
                        scene.zoomIn()
                    }
                    .font(.largeTitle)
                    .labelStyle(.iconOnly)
                    .padding()
                    
                    Button("Rotate CCW", systemImage: "arrow.counterclockwise") {
                        scene.rotateCCW()
                    }
                    .font(.largeTitle)
                    .labelStyle(.iconOnly)
                    .padding()
                    
                    Button("Rotate CW", systemImage: "arrow.clockwise") {
                        scene.rotateCW()
                    }
                    .font(.largeTitle)
                    .labelStyle(.iconOnly)
                    .padding()
                }
            }
            .padding()
        }
        .disabled(viewModel.isBusy)
        .ignoresSafeArea()
        .onAppear(perform: {
            scene.viewModel = viewModel
        })
    }
}

//#Preview {
//    ContentView()
//}
