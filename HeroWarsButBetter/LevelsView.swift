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
            ZStack {
                Image("levels")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                List(levels.indices, id: \.self) { index in
                    NavigationLink(destination: ContentView(viewModel: ViewModel.levels[index])) {
                        Text(levels[index])
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.5))) // Custom row background
                    }
                }
                .listStyle(.plain)
                .listRowSeparator(.hidden)
            }
            .navigationTitle("Levels")
        }
        .background(Color.clear)
        .scrollContentBackground(.hidden)
    }
}
