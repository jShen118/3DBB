//
//  LevelPreviewUI.swift
//  3DBB
//
//  Created by Alex Marrinan on 6/24/20.
//  Copyright © 2020 Joshua Shen. All rights reserved.
//

import Foundation
import SwiftUI

struct LevelPreviewUI: View{
    @State var level: Level
    
    var body: some View{
        ZStack{
            Rectangle()
                .frame(width: 300, height: 80, alignment: .leading)
                .foregroundColor(Color.white.opacity(0.8))
            HStack{
                ZStack{
                    Text(level.name)
                        .foregroundColor(Color.black.opacity(1))
                        .font(.system(size: 25))
                        .offset(x:0.5,y:0.5)
                    Text(level.name)
                        .foregroundColor(Color.green.opacity(1))
                        .font(.system(size: 25))
                }
                Spacer()
                Text(String(level.highScore))
                    .foregroundColor(Color.black)
                    .font(.system(size: 30))
            }
            .frame(width: 250, height: 80)
        }
    }
}
