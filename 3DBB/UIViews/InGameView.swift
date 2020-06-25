//
//  PauseMenuView.swift
//  3DBB
//
//  Created by Joshua Shen on 6/24/20.
//  Copyright © 2020 Joshua Shen. All rights reserved.
//

import SwiftUI

struct InGameView: View {
    @ObservedObject var gameScene: GameScene
    @Binding var inMenu: Bool
    @State private var inSettings: Bool = false
    
    var body: some View {
        ZStack {
            if gameScene.gameIsPaused &&
                !inSettings {
                VStack {
                    Text("Paused")
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.gameScene.gameIsPaused = false
                            self.gameScene.restart()
                        }) {
                            Image(systemName: "arrow.clockwise.circle").resizable().aspectRatio(contentMode: .fit)
                                .foregroundColor(Color.black).frame(width: 50, height: 50).background(Color.green).clipShape(Circle())
                        }
                        Spacer()
                        Button(action: {
                            self.gameScene.changeLevel(layout: BrickLayouts.layout_blank)
                            self.gameScene.gameIsPaused = false
                            self.inMenu = true
                        }) {
                            ZStack {
                                Circle().fill(Color.black).frame(width: 50, height: 50)
                                Image(systemName: "list.dash").scaleEffect(0.92)
                                .foregroundColor(Color.black).frame(width: 42, height: 42).background(Color.green).clipShape(Circle())
                            }
                        }
                        Spacer()
                        Button(action: {self.inSettings = true}) {
                            ZStack {
                                Circle().fill(Color.green).scaleEffect(0.87)
                                Image(systemName: "gear").resizable().aspectRatio(contentMode: .fill)
                                .foregroundColor(Color.black)
                            }.frame(width: 50, height: 50)
                            //.background(Color.green).clipShape(Circle())
                        }
                        Spacer()
                    }
                    
                    Button(action: {self.gameScene.gameIsPaused = false}) {
                        Text("Resume")
                    }
                }.font(.largeTitle).frame(width: 300, height: 200)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: CGFloat(20)))
                .transition(.slide)
            }
            if inSettings {
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
            VStack {
                HStack {
                    Spacer()
                    Button(action: { self.gameScene.gameIsPaused.toggle() }) {
                        Text("⏸").font(.largeTitle).padding()
                    }
                }
                Text("\(gameScene.score)").font(.largeTitle)
                Spacer()
            }
        }
    }
}

extension UIColor {
    var color: Color {
        get {
            let rgbColours = self.cgColor.components
            return Color(
                red: Double(rgbColours![0]),
                green: Double(rgbColours![1]),
                blue: Double(rgbColours![2])
            )
        }
    }
}
