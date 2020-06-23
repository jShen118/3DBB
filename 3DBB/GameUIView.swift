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
    @State var inMenu = true
    var body: some View{
        VStack{
            if inMenu{
                ZStack{
                    VStack{
                        Text("3D Brick Breaker")
                            .font(.system(size: 40))
                        Spacer()
                            .frame(height: 20)
                        Text("Levels:")
                        HStack(){
                            Button("1"){
                                self.gameScene.changeLevel(layout: BrickLayouts.layout_1)
                                self.inMenu = false
                            }
                            Spacer()
                                .frame(width: 20)
                            Button("2"){
                                self.gameScene.changeLevel(layout: BrickLayouts.layout_2)
                                self.inMenu = false
                            }
                            Spacer()
                                .frame(width: 20)
                            Button("3"){
                                self.gameScene.changeLevel(layout: BrickLayouts.layout_2)
                                self.inMenu = false
                            }
                            Spacer()
                                .frame(width: 20)
                            Button("4"){
                                self.gameScene.changeLevel(layout: BrickLayouts.layout_2)
                                self.inMenu = false
                            }
                            Spacer()
                                .frame(width: 20)
                            Button("5"){
                                self.gameScene.changeLevel(layout: BrickLayouts.layout_2)
                                self.inMenu = false
                            }
                            
                        }
                    }
                }
                .font(.largeTitle)
                .padding()
                .background(Color.green.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: CGFloat(10)))
            }else{
                ZStack {
                    if gameScene.gameIsPaused {
                        Color.red.opacity(0.5)
                        VStack {
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
                                Toggle(isOn: $gameScene.spinOn) {
                                    Text("Spin")
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
    }
}
/*
 struct GameUIView_Previews: PreviewProvider {
 static var previews: some View {
 GameUIView(score: 0)
 }
 }*/
