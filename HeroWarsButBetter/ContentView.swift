//
//  ContentView.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 02.01.2025.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    let scene = GameScene()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
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
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    ContentView()
//}
