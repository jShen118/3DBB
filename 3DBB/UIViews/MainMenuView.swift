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
        VStack(spacing: 0){
            Text("3D Brick Breaker")
                .font(.system(size: 40))
            Spacer()
                .frame(height: 20)
            HStack{
                Text("Levels:")
                    .foregroundColor(Color.black)
                    .font(.system(size: 15))
                Spacer()
                Text("High Score:")
                    .foregroundColor(Color.black)
                    .font(.system(size: 15))
            }
            .frame(width: 250, height: 30)
            ScrollView {
                VStack {
                    ForEach(0..<Levels.array.count, id: \.self) { index in
                        Button(action: {
                            self.gameScene.changeLevel(layout: Levels.array[index].layout)
                            self.inMenu = false
                        }){
                            LevelPreviewUI(level: Levels.array[index])
                        }
                    }
                }.frame(width: 500)
            }
        }

        
    }
}


