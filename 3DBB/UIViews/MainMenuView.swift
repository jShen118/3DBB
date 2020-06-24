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
    
    var body: some View {
        ScrollView {
            VStack {
                Text("3D Brick Breaker")
                    .font(.system(size: 40))
                Spacer().frame(height: 20)
                HStack{
                    Button("1"){
                        self.gameScene.changeLevel(layout: BrickLayouts.layout_1)
                        self.inMenu = false
                    }.frame(width: 100, height: 100)
                    .buttonStyle(GradientBackgroundStyle())
                    Spacer().frame(width: 20)
                    Button("2"){
                        self.gameScene.changeLevel(layout: BrickLayouts.layout_2)
                        self.inMenu = false
                    }.frame(width: 100, height: 100)
                    .buttonStyle(GradientBackgroundStyle())
                }
                Spacer().frame(width: 20)
                HStack{
                    Button("3"){
                        self.gameScene.changeLevel(layout: BrickLayouts.layout_3)
                        self.inMenu = false
                    }
                    Spacer().frame(width: 20)
                    Button("4"){
                        self.gameScene.changeLevel(layout: BrickLayouts.layout_4)
                        self.inMenu = false
                    }
                }
                Spacer().frame(width: 20)
                HStack{
                    Button("5"){
                        self.gameScene.changeLevel(layout: BrickLayouts.layout_5)
                        self.inMenu = false
                    }
                    Spacer().frame(width: 20)
                    Button("6"){
                        self.gameScene.changeLevel(layout: BrickLayouts.layout_6)
                        self.inMenu = false
                    }
                }
                Spacer().frame(width: 20)
            }
        }
    }
}


