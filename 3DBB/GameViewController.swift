import UIKit
import QuartzCore
import SceneKit
import Foundation

class GameViewController: UIViewController {
    let scene = SCNScene(named: "art.scnassets/ball.scn")!
    
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
        cameraNode.position = SCNVector3(x: 5.5, y: 7.5, z: 20)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 15)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        boxSetUp()
        brickSetUp()
        
        // retrieve the ball node
        let ball = scene.rootNode.childNode(withName: "ball", recursively: false)
        ball?.physicsBody?.velocity = SCNVector3(x: 5, y: -15, z: 5)

        // retrieve the SCNView
        let sceneView = self.view as! SCNView
        
        // set the scene to the view
        sceneView.scene = scene
        
        // allows the user to manipulate the camera
        sceneView.allowsCameraControl = false
        
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
    
    
    //bottom left front corner of the "room" is (0,0,0)
    func boxSetUp() {
        /*
        let boxBottom = SCNBox(width: 13, height: 1, length: 13, chamferRadius: 0.2)
        boxBottom.firstMaterial?.diffuse.contents = UIColor.white
        let boxBottomNode = SCNNode(geometry: boxBottom)
        scene.rootNode.addChildNode(boxBottomNode)
        boxBottomNode.position = SCNVector3(x: 1, y: -2, z: 1)
        boxBottomNode.physicsBody = SCNPhysicsBody.static()
        boxBottomNode.physicsBody?.restitution = 1.0
        boxBottomNode.physicsBody?.friction = 0*/
        
        let bouncerGeom = SCNPlane(width: 5, height: 5)
        bouncerGeom.firstMaterial?.isDoubleSided = true
        bouncerGeom.firstMaterial?.diffuse.contents = UIColor.green
        let bouncerNode = SCNNode(geometry: bouncerGeom)
        scene.rootNode.addChildNode(bouncerNode)
        bouncerNode.name = "bouncer"
        bouncerNode.eulerAngles = SCNVector3(x: Float(Double.pi / -2), y: 0, z: 0)
        bouncerNode.position = SCNVector3(x: 5.5, y: 0, z: -6.5)
        bouncerNode.physicsBody = SCNPhysicsBody.static()
        bouncerNode.physicsBody?.restitution = 1

        let boxTop = SCNBox(width: 13, height: 1, length: 13, chamferRadius: 0.2)
        boxTop.firstMaterial?.diffuse.contents = UIColor.white
        let boxTopNode = SCNNode(geometry: boxTop)
        scene.rootNode.addChildNode(boxTopNode)
        boxTopNode.position = SCNVector3(x: 5.5, y: 18.5, z: -6.5)
        boxTopNode.physicsBody = SCNPhysicsBody.static()
        boxTopNode.physicsBody?.restitution = 1
        boxTopNode.physicsBody?.friction = 0

        let boxLeft = SCNBox(width: 1, height: 13, length: 13, chamferRadius: 0.2)
        boxLeft.firstMaterial?.diffuse.contents = UIColor.white
        let boxLeftNode = SCNNode(geometry: boxLeft)
        scene.rootNode.addChildNode(boxLeftNode)
        boxLeftNode.position = SCNVector3(x: -0.5, y: 9, z: -6.5)
        boxLeftNode.physicsBody = SCNPhysicsBody.static()
        boxLeftNode.physicsBody?.restitution = 1
        boxLeftNode.physicsBody?.friction = 0

        let boxRight = SCNBox(width: 1, height: 13, length: 13, chamferRadius: 0.2)
        boxRight.firstMaterial?.diffuse.contents = UIColor.white
        let boxRightNode = SCNNode(geometry: boxRight)
        scene.rootNode.addChildNode(boxRightNode)
        boxRightNode.position = SCNVector3(x: 11.5, y: 9, z: -6.5)
        boxRightNode.physicsBody = SCNPhysicsBody.static()
        boxRightNode.physicsBody?.restitution = 1
        boxRightNode.physicsBody?.friction = 0

        let boxBack = SCNBox(width: 12, height: 13, length: 1, chamferRadius: 0.2)
        boxBack.firstMaterial?.diffuse.contents = UIColor.white
        let boxBackNode = SCNNode(geometry: boxBack)
        scene.rootNode.addChildNode(boxBackNode)
        boxBackNode.position = SCNVector3(x: 5.5, y: 9, z: -12.5)
        boxBackNode.physicsBody = SCNPhysicsBody.static()
        boxBackNode.physicsBody?.restitution = 1
        boxBackNode.physicsBody?.friction = 0

        let boxFront = SCNBox(width: 12, height: 13, length: 1, chamferRadius: 0.2)
        boxFront.firstMaterial?.diffuse.contents = UIColor.white
        let boxFrontNode = SCNNode(geometry: boxFront)
        scene.rootNode.addChildNode(boxFrontNode)
        boxFrontNode.position = SCNVector3(x: 5.5, y: 9, z: -0.5)
        boxFrontNode.physicsBody = SCNPhysicsBody.static()
        boxFrontNode.physicsBody?.restitution = 1
        boxFrontNode.opacity = 0
        boxFrontNode.physicsBody?.friction = 0
    }
    
    //bottom left front corner of the "room" is (0,0,0)
    func brickSetUp() {
        scene.rootNode.addChildNode(generateBrick(x: 1, y: 4, z: 12))
        scene.rootNode.addChildNode(generateBrick(x: 1.5, y: 4, z: 12))
        scene.rootNode.addChildNode(generateBrick(x: 1, y: 4, z: 11.5))
        scene.rootNode.addChildNode(generateBrick(x: 1.5, y: 4, z: 11.5))
    }
    
    func generateBrick(x: Float, y: Float, z: Float)-> SCNNode {
        let brickGeom = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0)
        brickGeom.firstMaterial?.diffuse.contents = UIColor.purple
        let newBrick = SCNNode(geometry: brickGeom)
        newBrick.physicsBody = SCNPhysicsBody.static()
        newBrick.physicsBody?.restitution = 1
        newBrick.position = SCNVector3(x: x, y: y, z: z)
        return newBrick
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

}
