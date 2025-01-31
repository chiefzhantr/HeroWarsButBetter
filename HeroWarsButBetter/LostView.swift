//
//  LostView.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 31.01.2025.
//

import Foundation
import SwiftUI
import SpriteKit

struct LostView: View {
    var body: some View {
        ZStack {
            Image("lostbackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            Image("lostcat")
                .resizable()
                .scaledToFit()
                .imageScale(.small)
            VStack {
                Text("You LOST!")
                    .font(.title)
                    .foregroundColor(.black)
                    .bold()
                Text("WHY ARE YOU UPSETING ILIAS????")
                    .font(.title3)
                    .foregroundColor(.black)
                    .bold()
            }
        }
        .onAppear(perform: {
            playMusic()
        })
    }
    
    private func playMusic() {
        SoundsPlayer.shared.playLost()
    }
}
