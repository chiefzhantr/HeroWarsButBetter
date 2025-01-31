//
//  EntityView.swift
//  HeroWarsButBetter
//
//  Created by Admin  on 10.01.2025.
//

import Foundation
import SwiftUI

struct EntityView: View {
    @ObservedObject var viewModel: ViewModel
    
    var entity: Entity {
        viewModel.selectedEntity ?? Entity(sprite: "PlaceHolder", startPosition: .random)
    }
    
    var body: some View {
        VStack {
            Text("\(entity.sprite) (\(entity.team))")
                .font(.headline)
                .foregroundStyle(.white)
            Text("\(entity.currentAction?.description ?? "Idle")")
                .foregroundStyle(.red)
            if entity.team == "Player" {
                Text("HP: \(entity.fullHP)")
                    .font(.subheadline)
                    .foregroundStyle(.red)
            } else {
                if entity.fullHP == entity.currentHP {
                    Text("HP: \(entity.expressionHP)")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                } else {
                    Text("HP: \(entity.currentHP)")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                }
            }
            if viewModel.currentAction == nil && entity.hasActed == false && entity.team == "Player" && viewModel.battle.activeTeam == "Player" {
                HStack {
                    Button("Move") {
                        print("Move")
                        viewModel.currentAction = MoveAction(owner: entity, path: [])
                        viewModel.redraw?()
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    Button("Attack") {
                        viewModel.currentAction = AttackAction()
                        viewModel.redraw?()
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                }
            }
        }.padding()
            .background(Color.gray.luminanceToAlpha())
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
    }
}

//#Preview {
//    EntityView(viewModel: ViewModel(map: Map(), entities: []))
//}
