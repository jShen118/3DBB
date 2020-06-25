//
//  BrickLayouts.swift
//  3DBB
//
//  Created by Joshua Shen on 5/3/20.
//  Copyright © 2020 Joshua Shen. All rights reserved.
//

import Foundation
import SceneKit

struct BrickLayouts {
    //room dimensions: 11x18x12
    static let layout_blank: BrickLayout = BrickLayout(breakable: [], unbreakable: [])
    
    
    static let layout_1: BrickLayout = BrickLayout(breakable: fill(x1: 1, x2: 4, y1: 12, y2: 15, z1: -4, z2: -7) + fill(x1: 8, x2: 11, y1: 12, y2: 15, z1: -4, z2: -7), unbreakable: fill(x1: 1, x2: 4, y1: 11, y2: 11, z1: -4, z2: -7) + fill(x1: 8, x2: 11, y1: 11, y2: 11, z1: -4, z2: -7))
    
    
    static let layout_2 = BrickLayout(breakable: fill(x1: 1, x2: 2, y1: 9, y2: 15, z1: -3, z2: -10) + fill(x1: 10, x2: 11, y1: 9, y2: 15, z1: -3, z2: -10) + fill(x1: 5, x2: 7, y1: 10, y2: 14, z1: -3, z2: -10), unbreakable: fill(x1: 5, x2: 7, y1: 9, y2: 9, z1: -3, z2: -10) + fill(x1: 5, x2: 7, y1: 15, y2: 15, z1: -3, z2: -10))
    
    
    static let layout_3: BrickLayout = BrickLayout(breakable: [], unbreakable: [])
    
    
    static let layout_4: BrickLayout = BrickLayout(breakable: [], unbreakable: [])
    
    
    static let layout_5: BrickLayout = BrickLayout(breakable: [], unbreakable: [])
    
    
    static let layout_6: BrickLayout = BrickLayout(breakable: [], unbreakable: [])
    
    
    static let layout_7: BrickLayout = BrickLayout(breakable: [], unbreakable: [])
    static let layout_8: BrickLayout = BrickLayout(breakable: [], unbreakable: [])
    static let layout_9: BrickLayout = BrickLayout(breakable: [], unbreakable: [])
    static let layout_10: BrickLayout = BrickLayout(breakable: [], unbreakable: [])
}

//fills a defined space full of bricks. x2 should be bigger than or equal to x1, y2 should be bigger than or equal to y1, and IMPORTANT: z1 should be bigger than or equal to z2
func fill(x1: Int, x2: Int, y1: Int, y2: Int, z1: Int, z2: Int)->[SCNVector3] {
    var toRet = Array(repeating: SCNVector3(x: 0, y: 0, z: 0), count: (x2 - x1 + 1)*(y2 - y1 + 1)*(z1 - z2 + 1))
    var index = 0
    for x in x1...x2 {
        for y in y1...y2 {
            for z in z2...z1 {
                toRet[index] = SCNVector3(x: Float(x), y: Float(y), z: Float(z))
                index += 1
            }
        }
    }
    return toRet
}
