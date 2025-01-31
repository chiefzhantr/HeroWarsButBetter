//
//  LevelsView.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 31.01.2025.
//

import Foundation
import SwiftUI
import SpriteKit

struct LevelsView: View {
    let levels = ["Level 1", "Level 2", "Level 3"]
        
    var body: some View {
        NavigationStack {
            List(levels.indices, id: \.self) { index in
                NavigationLink(levels[index], destination: ContentView(viewModel: ViewModel.levels[index]))
                    .font(.headline)
            }
            .navigationTitle("Levels")
        }
    }
}
