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
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Text("\(gameScene.score)")

        }
    }
}
/*
struct GameUIView_Previews: PreviewProvider {
    static var previews: some View {
        GameUIView(score: 0)
    }
}*/
