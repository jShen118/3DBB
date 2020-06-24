//
//  GameScore.swift
//  3DBB
//
//  Created by Joshua Shen on 5/27/20.
//  Copyright © 2020 Joshua Shen. All rights reserved.
//

import Foundation
import SwiftUI
import SceneKit

class GameScene: SCNScene, ObservableObject, SCNPhysicsContactDelegate {
    @Published var score: Int = 0
    @Published var gameIsPaused: Bool = false {
        didSet {
            isPaused = gameIsPaused
        }
    }
    @Published var currentBrickLayout: BrickLayout = BrickLayouts.layout_blank
    @Published var spinOn: Bool = true {
        didSet {frictionSet()}
    }
    var frictionValue: CGFloat {
        return spinOn ? 1.0 : 0.0
    }
    let ballCategoryBitMask = 1
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func restart() {
        rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        score = 0
        setUpScene()
    }
    
    func frictionSet() {
        rootNode.enumerateChildNodes { (node, stop) in
            node.physicsBody?.friction = frictionValue
        }
    }
    
    override convenience init() {
        self.init(named: "art.scnassets/empty.scn")!
        setUpScene()
    }
    
    func setUpScene() {
        let ballNode = SCNNode(geometry: SCNSphere(radius: 0.5))
        ballNode.name = "ball"
        ballNode.physicsBody = SCNPhysicsBody.dynamic()
        ballNode.physicsBody?.friction = frictionValue
        ballNode.physicsBody?.damping = 0
        ballNode.physicsBody?.angularDamping = 0
        ballNode.physicsBody?.categoryBitMask = ballCategoryBitMask
        ballNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/sudoku-blankgrid.png")
        ballNode.position = SCNVector3(x: 5.5, y: 5, z: -6)
        ballNode.physicsBody?.velocity = SCNVector3(x: 0, y: 3, z: 0)
        //ballNode.physicsBody?.applyForce(SCNVector3(x: 0, y: 3, z: 0), asImpulse: true)
        rootNode.addChildNode(ballNode)

        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 5.5, y: 8, z: 17.5)
        rootNode.addChildNode(cameraNode)
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 5.5, y: 7.5, z: 20)
        rootNode.addChildNode(lightNode)
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        rootNode.addChildNode(ambientLightNode)
        physicsWorld.gravity = SCNVector3(x: 0, y: 0, z: 0)
        physicsWorld.contactDelegate = self
        
        
        boxSetUp(bouncerType: .plane)
        brickSetUp()
    }
    
    //Coordinate system convention: a brick flush at the bottom left front corner of the room as (1,1,-1), opposite corner is (11, 18, -12)
    //the room is 11x18x12, bricks are 1x1x1
    func brickSetUp() {
        insertBrickLayout(layout: self.currentBrickLayout)
    }
    
    func changeLevel(layout: BrickLayout){
        self.currentBrickLayout = layout
        self.restart()
    }
    
    func insertBrickLayout(layout: BrickLayout) {
        for b in layout.breakableBricks {insertBrick(x: b.x, y: b.y, z: b.z, type: .breakable)}
        for b in layout.unbreakableBricks {insertBrick(x: b.x, y: b.y, z: b.z, type: .unbreakable)}
    }
    
    func insertBrick(x: Float, y: Float, z: Float, type: BrickType) {
        rootNode.addChildNode(generateBrick(x: x-0.5, y: y-0.5, z: z+0.5, type: type))
    }
    
    let breakableBrickColor1 = UIColor(hexaRGB: "#c0392b", alpha: 1.0)
    let breakableBrickColor2 = UIColor(hexaRGB: "#e67e22", alpha: 1.0)
    let breakableBrickColor3 = UIColor(hexaRGB: "#f1c40f", alpha: 1.0)
    let unbreakableBrickColor = UIColor(hexaRGB: "#7b9095", alpha: 1.0)
    func generateBrick(x: Float, y: Float, z: Float, type: BrickType)-> SCNNode {
        let brickGeom = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.15)
        if type == .breakable {
            brickGeom.firstMaterial?.diffuse.contents = breakableBrickColor1
        } else {brickGeom.firstMaterial?.diffuse.contents = unbreakableBrickColor}
        let newBrick = SCNNode(geometry: brickGeom)
        newBrick.name = "brick"
        newBrick.physicsBody = SCNPhysicsBody.static()
        newBrick.physicsBody?.friction = frictionValue
        newBrick.physicsBody?.restitution = 1
        newBrick.physicsBody?.contactTestBitMask = ballCategoryBitMask
        newBrick.position = SCNVector3(x: x, y: y, z: z)
        return newBrick
    }
    
    let boxColor = UIColor(hexaRGB: "#40739e", alpha: 1.0)
    //bottom left front corner of the "room" is (0,0,0)
    func boxSetUp(bouncerType: BouncerType) {
        var bouncerGeom: SCNGeometry = SCNPlane(width: 4, height: 4)
        if bouncerType == .pyramid {bouncerGeom = SCNPyramid(width: 4, height: 1, length: 4)}
        if bouncerType == .semisphere {bouncerGeom = SCNSphere(radius: 2)}
        
        bouncerGeom.firstMaterial?.isDoubleSided = true
        bouncerGeom.firstMaterial?.diffuse.contents = UIColor(hexaRGB: "#8c7ae6", alpha: 1.0)
        let bouncerNode = SCNNode(geometry: bouncerGeom)
        bouncerNode.name = "bouncer"
        if bouncerType == .plane {bouncerNode.eulerAngles = SCNVector3(x: Float(Double.pi / -2), y: 0, z: 0)}
        bouncerNode.position = SCNVector3(x: 5.5, y: 0, z: -6.5)
        bouncerNode.physicsBody = SCNPhysicsBody.kinematic()
        bouncerNode.physicsBody?.friction = frictionValue
        bouncerNode.physicsBody?.restitution = 1
        bouncerNode.physicsBody?.contactTestBitMask = ballCategoryBitMask
        rootNode.addChildNode(bouncerNode)
        
        let boxTop = SCNBox(width: 13, height: 1, length: 13, chamferRadius: 0)
        boxTop.firstMaterial?.diffuse.contents = boxColor
        let boxTopNode = SCNNode(geometry: boxTop)
        rootNode.addChildNode(boxTopNode)
        boxTopNode.position = SCNVector3(x: 5.5, y: 18.5, z: -6.5)
        boxTopNode.physicsBody = SCNPhysicsBody.static()
        boxTopNode.physicsBody?.friction = frictionValue
        

        let boxLeft = SCNBox(width: 1, height: 18, length: 13, chamferRadius: 0)
        boxLeft.firstMaterial?.diffuse.contents = boxColor
        let boxLeftNode = SCNNode(geometry: boxLeft)
        rootNode.addChildNode(boxLeftNode)
        boxLeftNode.position = SCNVector3(x: -0.5, y: 9, z: -6.5)
        boxLeftNode.physicsBody = SCNPhysicsBody.static()
        boxLeftNode.physicsBody?.friction = frictionValue

        let boxRight = SCNBox(width: 1, height: 18, length: 13, chamferRadius: 0)
        boxRight.firstMaterial?.diffuse.contents = boxColor
        let boxRightNode = SCNNode(geometry: boxRight)
        rootNode.addChildNode(boxRightNode)
        boxRightNode.position = SCNVector3(x: 11.5, y: 9, z: -6.5)
        boxRightNode.physicsBody = SCNPhysicsBody.static()
        boxRightNode.physicsBody?.friction = frictionValue

        let boxBack = SCNBox(width: 11, height: 18, length: 1, chamferRadius: 0)
        boxBack.firstMaterial?.diffuse.contents = boxColor
        let boxBackNode = SCNNode(geometry: boxBack)
        rootNode.addChildNode(boxBackNode)
        boxBackNode.position = SCNVector3(x: 5.5, y: 9, z: -12.5)
        boxBackNode.physicsBody = SCNPhysicsBody.static()
        boxBackNode.physicsBody?.friction = frictionValue

        let boxFront = SCNBox(width: 11, height: 18, length: 1, chamferRadius: 0)
        let boxFrontNode = SCNNode(geometry: boxFront)
        rootNode.addChildNode(boxFrontNode)
        boxFrontNode.position = SCNVector3(x: 5.5, y: 9, z: -0.5)
        boxFrontNode.physicsBody = SCNPhysicsBody.static()
        boxFrontNode.opacity = 0
        boxFrontNode.physicsBody?.friction = frictionValue
    }
    
    //nodeA should always be ball, nodeB should always be brick or bouncer
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        //print("\(contact.nodeA.name), \(contact.nodeB.name)")
        if contact.nodeB.name == "brick" {
            let brickColor = contact.nodeB.geometry?.firstMaterial?.diffuse.contents as! UIColor
            
            switch brickColor {
                case unbreakableBrickColor: break
                case breakableBrickColor1: contact.nodeB.geometry?.firstMaterial?.diffuse.contents = breakableBrickColor2
                case breakableBrickColor2: contact.nodeB.geometry?.firstMaterial?.diffuse.contents = breakableBrickColor3
                default: contact.nodeB.removeFromParentNode(); DispatchQueue.main.async {self.score += 1}
            }
        } else if spinOn {
            //print(contact.nodeB.physicsBody?.velocity)
            let xTorque = contact.nodeB.physicsBody?.velocity.z ?? 0
            let zTorque = contact.nodeB.physicsBody?.velocity.x ?? 0
            contact.nodeA.physicsBody?.applyTorque(SCNVector4(x: xTorque, y: 0.0, z: zTorque, w: 0.01), asImpulse: true)
        }
    }
}

extension UIColor {
    convenience init?(hexaRGB: String, alpha: CGFloat = 1) {
        var chars = Array(hexaRGB.hasPrefix("#") ? hexaRGB.dropFirst() : hexaRGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }
        case 6: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                alpha: alpha)
    }
}
