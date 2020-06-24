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
                .foregroundColor(Color.white.opacity(0.5))
            HStack{
                Text(level.name)
                    .foregroundColor(Color.black)
                    .font(.system(size: 25))
                Spacer()
                Text(String(level.highScore))
                    .foregroundColor(Color.black)
                    .font(.system(size: 30))
            }
            .frame(width: 250, height: 80)
        }
    }
}
