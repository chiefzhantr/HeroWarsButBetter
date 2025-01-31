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
    
    @State private var isNavigating = false
    
    var body: some View {
        ZStack {
            Image("levels")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
        }
    }
}
