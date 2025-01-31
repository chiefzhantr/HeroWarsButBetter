//
//  WinView.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 31.01.2025.
//

import Foundation
import SwiftUI
import SpriteKit

struct WinView: View {
    var body: some View {
        ZStack {
            Image("winbackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            ZStack {
                Image("ilias")
                VStack {
                    Spacer()
                        .frame(height: 150)
                    Text("You WON!")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    Text("Ilias will be proud of you! good job")
                        .font(.title3)
                        .padding(.top, 8)
                        .bold()
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear(perform: {
            playMusic()
        })
    }
    
    private func playMusic() {
        SoundsPlayer.shared.playWin()
    }
}
