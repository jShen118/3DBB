//
//  BrickLayout.swift
//  3DBB
//
//  Created by Joshua Shen on 5/4/20.
//  Copyright © 2020 Joshua Shen. All rights reserved.
//

import Foundation
import SceneKit

struct BrickLayout {
    let breakableBricks: [SCNVector3]
    let unbreakableBricks: [SCNVector3]
    
    init(breakable: [SCNVector3], unbreakable: [SCNVector3]) {
        breakableBricks = breakable
        unbreakableBricks = unbreakable
    }
}
