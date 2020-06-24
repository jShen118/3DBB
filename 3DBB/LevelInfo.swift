//
//  LevelInfo.swift
//  3DBB
//
//  Created by Alex Marrinan on 6/24/20.
//  Copyright © 2020 Joshua Shen. All rights reserved.
//

import Foundation

struct Level{
    let id: Int
    let layout: BrickLayout
    let name: String
    var highScore = 0
    var completed = false
    
    init(id: Int, layout: BrickLayout, name: String){
        self.id = id
        self.layout = layout
        self.name = name
    }
}

struct Levels{
    static var array: [Level] = [Level(id: 0, layout: BrickLayouts.layout_blank, name: "Blank Level"),
                                 Level(id: 1, layout: BrickLayouts.layout_1, name: "Level 1"),
                                 Level(id: 2, layout: BrickLayouts.layout_2, name: "Level 2"),
                                 Level(id: 3, layout: BrickLayouts.layout_3, name: "Level 3"),
                                 Level(id: 4, layout: BrickLayouts.layout_4, name: "Level 4"),
                                 Level(id: 5, layout: BrickLayouts.layout_4, name: "Level 5"),
                                 Level(id: 6, layout: BrickLayouts.layout_4, name: "Level 6"),
                                 Level(id: 7, layout: BrickLayouts.layout_4, name: "Level 7"),
                                 Level(id: 8, layout: BrickLayouts.layout_4, name: "Level 8"),
                                 Level(id: 9, layout: BrickLayouts.layout_4, name: "Level 9"),
                                 Level(id: 10, layout: BrickLayouts.layout_4, name: "Level 10")
    ]
}
