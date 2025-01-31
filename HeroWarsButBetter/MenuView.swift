//
//  MenuView.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 31.01.2025.
//

import Foundation
import SwiftUI
import SpriteKit

struct MenuView: View {
    
    @State private var isNavigating = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack {
                    Image("Knight_Idle_315_0")
                    Text("Welcome to MathWars!")
                        .font(.headline)
                        .padding(.bottom, 8)
                    Text("Your goal is to calculate the strengths of opponents, level up, and defeat them all!")
                        .frame(width: 360)
                        .padding(.bottom, 16)
                        .font(.subheadline)
                    
                    Button("Play!") {
                        isNavigating = true
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    NavigationLink("", destination: LevelsView(), isActive: $isNavigating)
                                        .hidden()
                }
            }
        }
    }
}
