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
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
            VStack {
                Spacer()
                Button("Random!") {
                    scene.moveRandomEntityToRandomPosition()
                } 
                HStack {
                    Button("Rotate Knight CCW") {
                        scene.rotateKnightCCW()
                    }
                    Button("Rotate Knight CW") {
                        scene.rotateKnightCW()
                    }
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
    }
}

#Preview {
    ContentView()
}
