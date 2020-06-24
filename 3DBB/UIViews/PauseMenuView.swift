//
//  PauseMenuView.swift
//  3DBB
//
//  Created by Joshua Shen on 6/24/20.
//  Copyright © 2020 Joshua Shen. All rights reserved.
//

import SwiftUI

struct PauseMenuView: View {
    @ObservedObject var gameScene: GameScene
    @Binding var inMenu: Bool
    
    var body: some View {
        VStack {
            if gameScene.gameIsPaused {
                VStack {
                    Text("Paused")
                    Button("Continue") {
                        // when the continue button is pressed, we unpause the game
                        self.gameScene.gameIsPaused = false
                    }
                            
                    Button("Restart") {
                        self.gameScene.gameIsPaused = false
                        self.gameScene.restart()
                    }
                    Button("Quit") {
                        self.gameScene.changeLevel(layout: BrickLayouts.layout_blank)
                        self.gameScene.gameIsPaused = false
                        self.inMenu = true
                    }
                    Toggle(isOn: $gameScene.spinOn) {Text("Spin")}
                }.font(.largeTitle)
                .padding()
                .background(Color.green.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: CGFloat(10)))
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
                }
            }
        }
    }
}


