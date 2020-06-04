//
//  GameUIView.swift
//  3DBB
//
//  Created by Joshua Shen on 5/20/20.
//  Copyright © 2020 Joshua Shen. All rights reserved.
//

import SwiftUI

struct GameUIView: View {
    @ObservedObject var gameScene: GameScene
    
    var body: some View {
        ZStack {
            // The if statement determines what is shown in the view: either the pause menu
            // or a "Pause" symbol and the maximum tower height.
            if gameScene.gameIsPaused {
                Color.red.opacity(0.5)
                VStack {
                    VStack {
                        Text("Paused")
                        Button("Continue") {
                            // when the continue button is pressed, we unpause the game
                            self.gameScene.gameIsPaused = false
                        }
                    }.font(.largeTitle)
                    .padding()
                    .background(Color.green.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: CGFloat(10)))
                }.transition(.slide)
            } else {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: { self.gameScene.gameIsPaused = true }) {
                            Text("⏸").font(.largeTitle).padding()
                        }
                    }
                    Text("\(gameScene.score)").font(.largeTitle)
                    Spacer()
                }.transition(.slide)
            }
        }
    }
}
/*
struct GameUIView_Previews: PreviewProvider {
    static var previews: some View {
        GameUIView(score: 0)
    }
}*/
