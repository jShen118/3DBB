import UIKit
import QuartzCore
import SceneKit
import Foundation
import SwiftUI

class GameViewController: UIViewController, SCNPhysicsContactDelegate {
    let scene = SCNScene(named: "art.scnassets/ball.scn")!
    let ballCategoryBitMask = 1
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 5.5, y: 8, z: 17.5)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 5.5, y: 7.5, z: 20)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
 
        
        boxSetUp(bouncerType: .plane)
        brickSetUp()
        
        // retrieve the ball node
        let ball = scene.rootNode.childNode(withName: "ball", recursively: false)
        ball?.physicsBody?.velocity = SCNVector3(x: 5, y: 15, z: 5)
        ball?.physicsBody?.categoryBitMask = ballCategoryBitMask
        scene.physicsWorld.contactDelegate = self
        
        // retrieve the SCNView
        let sceneView = self.view as! SCNView
        
        // set the scene to the view
        sceneView.scene = scene
        
        // allows the user to manipulate the camera
        sceneView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // configure the view
        sceneView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        //add a pan (drag) gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanning(pan:)))
        sceneView.addGestureRecognizer(panGesture)
        
    }
    
    //Coordinate system convention: a brick flush at the bottom left front corner of the room as (1,1,-1), opposite corner is (11, 18, -12)
    //the room is 11x18x12, bricks are 1x1x1
    func brickSetUp() {
        //insertBrick(x: 1, y: 1, z: -1)
        //insertBrick(x: 11, y: 18, z: -12)
        insertBrickLayout(layout: BrickLayouts.layout_1)
    }
    
    func insertBrickLayout(layout: BrickLayout) {
        for b in layout.breakableBricks {insertBrick(x: b.x, y: b.y, z: b.z, type: .breakable)}
        for b in layout.unbreakableBricks {insertBrick(x: b.x, y: b.y, z: b.z, type: .unbreakable)}
    }
    
    func insertBrick(x: Float, y: Float, z: Float, type: BrickType) {
        scene.rootNode.addChildNode(generateBrick(x: x-0.5, y: y-0.5, z: z+0.5, type: type))
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
        if type == .breakable {
            
        }
        newBrick.physicsBody?.contactTestBitMask = ballCategoryBitMask
        newBrick.position = SCNVector3(x: x, y: y, z: z)
        return newBrick
    }
    
    //bottom left front corner of the "room" is (0,0,0)
    func boxSetUp(bouncerType: BouncerType) {
        var bouncerGeom: SCNGeometry = SCNPlane(width: 3, height: 3)
        if bouncerType == .pyramid {bouncerGeom = SCNPyramid(width: 3, height: 1, length: 3)}
        if bouncerType == .semisphere {bouncerGeom = SCNSphere(radius: 1.5)}
        
        bouncerGeom.firstMaterial?.isDoubleSided = true
        bouncerGeom.firstMaterial?.diffuse.contents = UIColor.green
        let bouncerNode = SCNNode(geometry: bouncerGeom)
        scene.rootNode.addChildNode(bouncerNode)
        bouncerNode.name = "bouncer"
        if bouncerType == .plane {bouncerNode.eulerAngles = SCNVector3(x: Float(Double.pi / -2), y: 0, z: 0)}
        bouncerNode.position = SCNVector3(x: 5.5, y: 0, z: -6.5)
        bouncerNode.physicsBody = SCNPhysicsBody.static()
        bouncerNode.physicsBody?.restitution = 1
        
        let boxTop = SCNBox(width: 13, height: 1, length: 13, chamferRadius: 0)
        boxTop.firstMaterial?.diffuse.contents = UIColor.blue
        let boxTopNode = SCNNode(geometry: boxTop)
        scene.rootNode.addChildNode(boxTopNode)
        boxTopNode.position = SCNVector3(x: 5.5, y: 18.5, z: -6.5)
        boxTopNode.physicsBody = SCNPhysicsBody.static()
        boxTopNode.physicsBody?.restitution = 1
        boxTopNode.physicsBody?.friction = 0

        let boxLeft = SCNBox(width: 1, height: 18, length: 13, chamferRadius: 0)
        boxLeft.firstMaterial?.diffuse.contents = UIColor.blue
        let boxLeftNode = SCNNode(geometry: boxLeft)
        scene.rootNode.addChildNode(boxLeftNode)
        boxLeftNode.position = SCNVector3(x: -0.5, y: 9, z: -6.5)
        boxLeftNode.physicsBody = SCNPhysicsBody.static()
        boxLeftNode.physicsBody?.restitution = 1
        boxLeftNode.physicsBody?.friction = 0

        let boxRight = SCNBox(width: 1, height: 18, length: 13, chamferRadius: 0)
        boxRight.firstMaterial?.diffuse.contents = UIColor.blue
        let boxRightNode = SCNNode(geometry: boxRight)
        scene.rootNode.addChildNode(boxRightNode)
        boxRightNode.position = SCNVector3(x: 11.5, y: 9, z: -6.5)
        boxRightNode.physicsBody = SCNPhysicsBody.static()
        boxRightNode.physicsBody?.restitution = 1
        boxRightNode.physicsBody?.friction = 0

        let boxBack = SCNBox(width: 11, height: 18, length: 1, chamferRadius: 0)
        boxBack.firstMaterial?.diffuse.contents = UIColor.blue
        let boxBackNode = SCNNode(geometry: boxBack)
        scene.rootNode.addChildNode(boxBackNode)
        boxBackNode.position = SCNVector3(x: 5.5, y: 9, z: -12.5)
        boxBackNode.physicsBody = SCNPhysicsBody.static()
        boxBackNode.physicsBody?.restitution = 1
        boxBackNode.physicsBody?.friction = 0

        let boxFront = SCNBox(width: 11, height: 18, length: 1, chamferRadius: 0)
        boxFront.firstMaterial?.diffuse.contents = UIColor.blue
        let boxFrontNode = SCNNode(geometry: boxFront)
        scene.rootNode.addChildNode(boxFrontNode)
        boxFrontNode.position = SCNVector3(x: 5.5, y: 9, z: -0.5)
        boxFrontNode.physicsBody = SCNPhysicsBody.static()
        boxFrontNode.physicsBody?.restitution = 1
        boxFrontNode.opacity = 0
        boxFrontNode.physicsBody?.friction = 0
    }
    
    //isInBounds not working rn
    @objc func handlePanning(pan: UIPanGestureRecognizer) {
        let sceneView = self.view as! SCNView
        //let touchPoint = pan.location(in: sceneView)
        let xPan = pan.velocity(in: sceneView).x
        //if isInBounds(Int((scene.rootNode.childNode(withName: "bouncer", recursively: false)?.position.z)!)) {
            scene.rootNode.childNode(withName: "bouncer", recursively: false)!.runAction(SCNAction.moveBy(x: xPan/1000, y: 0, z: 0, duration: 0.1))
        //}
        let zPan = pan.velocity(in: sceneView).y
        //if isInBounds(Int((scene.rootNode.childNode(withName: "bouncer", recursively: false)?.position.z)!)) {
            scene.rootNode.childNode(withName: "bouncer", recursively: false)!.runAction(SCNAction.moveBy(x: 0, y: 0, z: zPan/1000, duration: 0.1))
        //}
    }
    
    func isInBounds(_ coor: Int)-> Bool {
        return coor >= -7 && coor <= 7
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    //nodeA should always be ball, nodeB should always be brick
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        //print("\(contact.nodeA.name), \(contact.nodeB.name)")
        if contact.nodeB.geometry?.firstMaterial?.diffuse.contents == UIColor.purple {
            
        }
        contact.nodeB.geometry?.firstMaterial?.diffuse.contents = UIColor.black
    }
}
