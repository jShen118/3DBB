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
    let ballCategoryBitMask = 1
    @State var currentBrickLayout: BrickLayout = BrickLayouts.layout_blank
    
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
    
    override convenience init() {
        self.init(named: "art.scnassets/empty.scn")!
        setUpScene()
    }
    
    func setUpScene() {
        let ballNode = SCNNode(geometry: SCNSphere(radius: 0.5))
        ballNode.name = "ball"
        ballNode.physicsBody = SCNPhysicsBody.dynamic()
        ballNode.physicsBody?.friction = 0
        ballNode.physicsBody?.rollingFriction = 0
        //ballNode.physicsBody?.angularVelocityFactor = SCNVector3(x: 1, y: 1, z: 1)
        ballNode.physicsBody?.restitution = CGFloat(1.0)
        ballNode.physicsBody?.damping = CGFloat(0.0)
        ballNode.physicsBody?.angularDamping = 0
        ballNode.physicsBody?.categoryBitMask = ballCategoryBitMask
        ballNode.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        ballNode.position = SCNVector3(x: 5.5, y: 5, z: -6)
        ballNode.physicsBody?.velocity = SCNVector3(x: 0, y: 0, z: 0)
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
        physicsWorld.gravity = SCNVector3(x: 0, y: -5, z: 0)
        physicsWorld.contactDelegate = self
        
        
        boxSetUp(bouncerType: .plane)
        brickSetUp()
        //self.rootNode.childNode(withName: "ball", recursively: false)?.physicsBody?.categoryBitMask = ballCategoryBitMask
    }
    
    //Coordinate system convention: a brick flush at the bottom left front corner of the room as (1,1,-1), opposite corner is (11, 18, -12)
    //the room is 11x18x12, bricks are 1x1x1
    func brickSetUp() {
        //insertBrick(x: 1, y: 1, z: -1)
        //insertBrick(x: 11, y: 18, z: -12)
        
        insertBrickLayout(layout: self.currentBrickLayout)
    }
    
    
    
    func insertBrickLayout(layout: BrickLayout) {
        for b in layout.breakableBricks {insertBrick(x: b.x, y: b.y, z: b.z, type: .breakable)}
        for b in layout.unbreakableBricks {insertBrick(x: b.x, y: b.y, z: b.z, type: .unbreakable)}
        
    }
    
    func insertBrick(x: Float, y: Float, z: Float, type: BrickType) {
        rootNode.addChildNode(generateBrick(x: x-0.5, y: y-0.5, z: z+0.5, type: type))
    }
    
    func generateBrick(x: Float, y: Float, z: Float, type: BrickType)-> SCNNode {
        let brickGeom = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.15)
        if type == .breakable {
            brickGeom.firstMaterial?.diffuse.contents = UIColor.purple
        } else {brickGeom.firstMaterial?.diffuse.contents = UIColor.gray}
        let newBrick = SCNNode(geometry: brickGeom)
        newBrick.name = "brick"
        newBrick.physicsBody = SCNPhysicsBody.static()
        newBrick.physicsBody?.restitution = 1
        newBrick.physicsBody?.friction = 1
        newBrick.physicsBody?.contactTestBitMask = ballCategoryBitMask
        newBrick.position = SCNVector3(x: x, y: y, z: z)
        return newBrick
    }
    
    //bottom left front corner of the "room" is (0,0,0)
    func boxSetUp(bouncerType: BouncerType) {
        var bouncerGeom: SCNGeometry = SCNPlane(width: 15, height: 15)
        if bouncerType == .pyramid {bouncerGeom = SCNPyramid(width: 3, height: 1, length: 3)}
        if bouncerType == .semisphere {bouncerGeom = SCNSphere(radius: 1.5)}
        
        bouncerGeom.firstMaterial?.isDoubleSided = true
        bouncerGeom.firstMaterial?.diffuse.contents = UIColor.green
        let bouncerNode = SCNNode(geometry: bouncerGeom)
        rootNode.addChildNode(bouncerNode)
        bouncerNode.name = "bouncer"
        if bouncerType == .plane {bouncerNode.eulerAngles = SCNVector3(x: Float(Double.pi / -2), y: 0, z: 0)}
        bouncerNode.position = SCNVector3(x: 5.5, y: 0, z: -6.5)
        bouncerNode.physicsBody = SCNPhysicsBody.kinematic()
        bouncerNode.physicsBody?.restitution = CGFloat(1.0)
        bouncerNode.physicsBody?.friction = 1
        
        let boxTop = SCNBox(width: 13, height: 1, length: 13, chamferRadius: 0)
        boxTop.firstMaterial?.diffuse.contents = UIColor.blue
        let boxTopNode = SCNNode(geometry: boxTop)
        rootNode.addChildNode(boxTopNode)
        boxTopNode.position = SCNVector3(x: 5.5, y: 18.5, z: -6.5)
        boxTopNode.physicsBody = SCNPhysicsBody.static()
        boxTopNode.physicsBody?.restitution = 1
        boxTopNode.physicsBody?.friction = 1

        let boxLeft = SCNBox(width: 1, height: 18, length: 13, chamferRadius: 0)
        boxLeft.firstMaterial?.diffuse.contents = UIColor.blue
        let boxLeftNode = SCNNode(geometry: boxLeft)
        rootNode.addChildNode(boxLeftNode)
        boxLeftNode.position = SCNVector3(x: -0.5, y: 9, z: -6.5)
        boxLeftNode.physicsBody = SCNPhysicsBody.static()
        boxLeftNode.physicsBody?.restitution = 1
        boxLeftNode.physicsBody?.friction = 1

        let boxRight = SCNBox(width: 1, height: 18, length: 13, chamferRadius: 0)
        boxRight.firstMaterial?.diffuse.contents = UIColor.blue
        let boxRightNode = SCNNode(geometry: boxRight)
        rootNode.addChildNode(boxRightNode)
        boxRightNode.position = SCNVector3(x: 11.5, y: 9, z: -6.5)
        boxRightNode.physicsBody = SCNPhysicsBody.static()
        boxRightNode.physicsBody?.restitution = 1
        boxRightNode.physicsBody?.friction = 1

        let boxBack = SCNBox(width: 11, height: 18, length: 1, chamferRadius: 0)
        boxBack.firstMaterial?.diffuse.contents = UIColor.blue
        let boxBackNode = SCNNode(geometry: boxBack)
        rootNode.addChildNode(boxBackNode)
        boxBackNode.position = SCNVector3(x: 5.5, y: 9, z: -12.5)
        boxBackNode.physicsBody = SCNPhysicsBody.static()
        boxBackNode.physicsBody?.restitution = 1
        boxBackNode.physicsBody?.friction = 1

        let boxFront = SCNBox(width: 11, height: 18, length: 1, chamferRadius: 0)
        boxFront.firstMaterial?.diffuse.contents = UIColor.blue
        let boxFrontNode = SCNNode(geometry: boxFront)
        rootNode.addChildNode(boxFrontNode)
        boxFrontNode.position = SCNVector3(x: 5.5, y: 9, z: -0.5)
        boxFrontNode.physicsBody = SCNPhysicsBody.static()
        boxFrontNode.physicsBody?.restitution = 1
        boxFrontNode.opacity = 0
        boxFrontNode.physicsBody?.friction = 1
    }
    
    //nodeA should always be ball, nodeB should always be brick
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        let brickColor = contact.nodeB.geometry?.firstMaterial?.diffuse.contents as! UIColor
        switch brickColor {
            case UIColor.gray: grayBrickHit()
            case UIColor.purple: contact.nodeB.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 0.7, green: 0.0, blue: 0.3, alpha: 1.0)
            case UIColor(red: 0.7, green: 0.0, blue: 0.3, alpha: 1.0): contact.nodeB.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 0.9, green: 0.0, blue: 0.0, alpha: 1.0)
            default: contact.nodeB.removeFromParentNode(); DispatchQueue.main.async {self.score += 1}
        }
    }
    
    func grayBrickHit() {}
}
