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
    
    var body: some View {
        VStack {
            if inMenu {
                MainMenuView(gameScene: gameScene, inMenu: $inMenu)
            } else {
                PauseMenuView(gameScene: gameScene, inMenu: $inMenu)
            }
        }
    }
    
    
}

