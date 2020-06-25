//
//  MenuView.swift
//  3DBB
//
//  Created by Joshua Shen on 6/24/20.
//  Copyright © 2020 Joshua Shen. All rights reserved.
//

import SwiftUI

struct MainMenuView: View {
    @ObservedObject var gameScene: GameScene
    @Binding var inMenu: Bool
    @State var inSettings = false
    
    var body: some View {
        VStack {
            if !inSettings{
                VStack(spacing: 0){
                    HStack{
                        ZStack{
                            Text("3D Brick Breaker")
                                .font(.system(size: 40))
                                .foregroundColor(Color.black)
                            Text("3D Brick Breaker")
                                .font(.system(size: 40))
                                .offset(x: -2, y: -2)
                                .foregroundColor(Color.green)
                        }
                        Button(action: {self.inSettings = true}) {
                            ZStack {
                                Circle().fill(Color.green).scaleEffect(0.87)
                                Image(systemName: "gear").resizable().aspectRatio(contentMode: .fill)
                                    .foregroundColor(Color.black)
                            }.frame(width: 40, height: 40)
                            //.background(Color.green).clipShape(Circle())
                        }
                    }
                    Spacer()
                        .frame(height: 20)
                    HStack{
                        Text("Levels:")
                            .foregroundColor(Color.black)
                            .font(.system(size: 22))
                        Spacer()
                        Text("High Score:")
                            .foregroundColor(Color.black)
                            .font(.system(size: 22))
                    }
                    .frame(width: 250, height: 30)
                    ScrollView {
                        VStack {
                            ForEach(0..<Levels.array.count, id: \.self) { index in
                                Button(action: {
                                    self.gameScene.changeLevel(layout: Levels.array[index].layout, id: index)
                                    self.inMenu = false
                                }){
                                    LevelPreviewUI(level: Levels.array[index])
                                }
                            }
                        }.frame(width: 500)
                    }
                }
            } else {
                VStack {
                    HStack {
                        Button(action: {self.inSettings = false}) {
                            Image(systemName: "arrowshape.turn.up.left")
                                .scaleEffect(0.8)
                        }
                        Spacer()
                    }
                    Spacer()
                    Picker(selection: $gameScene.bouncerType, label: Text("")) {
                        Image(systemName: "square.fill").tag(BouncerType.plane)
                        Image(systemName: "triangle.fill").tag(BouncerType.pyramid)
                        Image(systemName: "circle.fill").tag(BouncerType.semisphere)
                    }.pickerStyle(SegmentedPickerStyle())
                    Spacer()
                    Toggle(isOn: $gameScene.spinOn) {Text("Spin")}.frame(width: 150)
                    Spacer()
                }.font(.largeTitle).frame(width: 300, height: 200)
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: CGFloat(20)))
                    .transition(.slide)
            }
        }
    }
}


