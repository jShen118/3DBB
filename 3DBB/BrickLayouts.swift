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
    static let layout_1: [SCNVector3] = fill(x1: 4, x2: 8, y1: 12, y2: 15, z1: -3, z2: -6)
    
    
    
}

//fills a defined space full of bricks. x2 should be bigger than x1, y2 should be bigger than y1, and IMPORTANT: z1 should be bigger than z2
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
