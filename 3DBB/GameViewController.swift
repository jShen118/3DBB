import UIKit
import QuartzCore
import SceneKit
import Foundation

class GameViewController: UIViewController {
    let scene = SCNScene(named: "art.scnassets/ship.scn")!
    var bouncer: SCNNode
    
    required init(coder decoder: NSCoder) {
        let bouncerGeom = SCNPlane(width: 5, height: 5)
        bouncerGeom.firstMaterial?.isDoubleSided = true
        bouncerGeom.firstMaterial?.diffuse.contents = UIColor.green
        let bouncerNode = SCNNode(geometry: bouncerGeom)
        self.bouncer = bouncerNode
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
        cameraNode.position = SCNVector3(x: 1, y: 5, z: 20)
        
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
        
        // retrieve the ship node
        let ball = scene.rootNode.childNode(withName: "ball", recursively: false)
        //ball?.physicsBody?.restitution = 1.1
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
    
    @objc func handlePanning(pan: UIPanGestureRecognizer) {
        let sceneView = self.view as! SCNView
        //let touchPoint = pan.location(in: sceneView)
        let xPan = pan.velocity(in: sceneView).x
        scene.rootNode.childNode(withName: "bouncer", recursively: false)!.runAction(SCNAction.moveBy(x: xPan/1000, y: 0, z: 0, duration: 0.1))
        let zPan = pan.velocity(in: sceneView).y
        scene.rootNode.childNode(withName: "bouncer", recursively: false)!.runAction(SCNAction.moveBy(x: 0, y: 0, z: zPan/1000, duration: 0.1))
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
    
    
    func boxSetUp() {
        /*
        let boxBottom = SCNBox(width: 13, height: 1, length: 13, chamferRadius: 0.2)
        boxBottom.firstMaterial?.diffuse.contents = UIColor.blue
        let boxBottomNode = SCNNode(geometry: boxBottom)
        scene.rootNode.addChildNode(boxBottomNode)
        boxBottomNode.position = SCNVector3(x: 1, y: -2, z: 1)
        boxBottomNode.physicsBody = SCNPhysicsBody.static()
        boxBottomNode.physicsBody?.restitution = 1.0
        boxBottomNode.physicsBody?.friction = 0*/
        
        
        scene.rootNode.addChildNode(bouncer)
        bouncer.name = "bouncer"
        bouncer.eulerAngles = SCNVector3(x: Float(Double.pi / -2), y: 0, z: 0)
        bouncer.position = SCNVector3(x: 1, y: -2, z: 1)
        bouncer.physicsBody = SCNPhysicsBody.static()
        bouncer.physicsBody?.restitution = 1

        let boxTop = SCNBox(width: 13, height: 1, length: 13, chamferRadius: 0.2)
        boxTop.firstMaterial?.diffuse.contents = UIColor.blue
        let boxTopNode = SCNNode(geometry: boxTop)
        scene.rootNode.addChildNode(boxTopNode)
        boxTopNode.position = SCNVector3(x: 1, y: 12, z: 1)
        boxTopNode.physicsBody = SCNPhysicsBody.static()
        boxTopNode.physicsBody?.restitution = 1
        boxTopNode.physicsBody?.friction = 0

        let boxLeft = SCNBox(width: 1, height: 13, length: 13, chamferRadius: 0.2)
        boxLeft.firstMaterial?.diffuse.contents = UIColor.blue
        let boxLeftNode = SCNNode(geometry: boxLeft)
        scene.rootNode.addChildNode(boxLeftNode)
        boxLeftNode.position = SCNVector3(x: -5, y: 5, z: 1)
        boxLeftNode.physicsBody = SCNPhysicsBody.static()
        boxLeftNode.physicsBody?.restitution = 1
        boxLeftNode.physicsBody?.friction = 0

        let boxRight = SCNBox(width: 1, height: 13, length: 13, chamferRadius: 0.2)
        boxRight.firstMaterial?.diffuse.contents = UIColor.blue
        let boxRightNode = SCNNode(geometry: boxRight)
        scene.rootNode.addChildNode(boxRightNode)
        boxRightNode.position = SCNVector3(x: 7, y: 5, z: 1)
        boxRightNode.physicsBody = SCNPhysicsBody.static()
        boxRightNode.physicsBody?.restitution = 1
        boxRightNode.physicsBody?.friction = 0

        let boxBack = SCNBox(width: 12, height: 13, length: 1, chamferRadius: 0.2)
        boxBack.firstMaterial?.diffuse.contents = UIColor.blue
        let boxBackNode = SCNNode(geometry: boxBack)
        scene.rootNode.addChildNode(boxBackNode)
        boxBackNode.position = SCNVector3(x: 1, y: 5, z: -5)
        boxBackNode.physicsBody = SCNPhysicsBody.static()
        boxBackNode.physicsBody?.restitution = 1
        boxBackNode.physicsBody?.friction = 0

        let boxFront = SCNBox(width: 12, height: 13, length: 1, chamferRadius: 0.2)
        boxFront.firstMaterial?.diffuse.contents = UIColor.blue
        let boxFrontNode = SCNNode(geometry: boxFront)
        scene.rootNode.addChildNode(boxFrontNode)
        boxFrontNode.position = SCNVector3(x: 1, y: 5, z: 7)
        boxFrontNode.physicsBody = SCNPhysicsBody.static()
        boxFrontNode.physicsBody?.restitution = 1
        boxFrontNode.opacity = 0
        boxFrontNode.physicsBody?.friction = 0
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
