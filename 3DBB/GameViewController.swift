import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
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
        
        // retrieve the ship node
        let ball = scene.rootNode.childNode(withName: "ball", recursively: false)
        ball?.physicsBody?.velocity = SCNVector3(x: 10, y: -30, z: 10)
        
        let boxBottom = SCNBox(width: 13, height: 1, length: 13, chamferRadius: 0.2)
        boxBottom.firstMaterial?.diffuse.contents = UIColor.white
        let boxBottomNode = SCNNode(geometry: boxBottom)
        scene.rootNode.addChildNode(boxBottomNode)
        boxBottomNode.position = SCNVector3(x: 1, y: -2, z: 1)
        boxBottomNode.physicsBody = SCNPhysicsBody.static()
        boxBottomNode.physicsBody?.restitution = 1.0
        boxBottomNode.physicsBody?.friction = 0

        let boxTop = SCNBox(width: 13, height: 1, length: 13, chamferRadius: 0.2)
        boxTop.firstMaterial?.diffuse.contents = UIColor.white
        let boxTopNode = SCNNode(geometry: boxTop)
        scene.rootNode.addChildNode(boxTopNode)
        boxTopNode.position = SCNVector3(x: 1, y: 12, z: 1)
        boxTopNode.physicsBody = SCNPhysicsBody.static()
        boxTopNode.physicsBody?.restitution = 1.0
        boxTopNode.physicsBody?.friction = 0

        let boxLeft = SCNBox(width: 1, height: 13, length: 13, chamferRadius: 0.2)
        boxLeft.firstMaterial?.diffuse.contents = UIColor.white
        let boxLeftNode = SCNNode(geometry: boxLeft)
        scene.rootNode.addChildNode(boxLeftNode)
        boxLeftNode.position = SCNVector3(x: -5, y: 5, z: 1)
        boxLeftNode.physicsBody = SCNPhysicsBody.static()
        boxLeftNode.physicsBody?.restitution = 1.0
        boxLeftNode.physicsBody?.friction = 0

        let boxRight = SCNBox(width: 1, height: 13, length: 13, chamferRadius: 0.2)
        boxRight.firstMaterial?.diffuse.contents = UIColor.white
        let boxRightNode = SCNNode(geometry: boxRight)
        scene.rootNode.addChildNode(boxRightNode)
        boxRightNode.position = SCNVector3(x: 7, y: 5, z: 1)
        boxRightNode.physicsBody = SCNPhysicsBody.static()
        boxRightNode.physicsBody?.restitution = 1.0
        boxRightNode.physicsBody?.friction = 0

        let boxBack = SCNBox(width: 12, height: 13, length: 1, chamferRadius: 0.2)
        boxBack.firstMaterial?.diffuse.contents = UIColor.white
        let boxBackNode = SCNNode(geometry: boxBack)
        scene.rootNode.addChildNode(boxBackNode)
        boxBackNode.position = SCNVector3(x: 1, y: 5, z: -5)
        boxBackNode.physicsBody = SCNPhysicsBody.static()
        boxBackNode.physicsBody?.restitution = 1.0
        boxBackNode.physicsBody?.friction = 0

        let boxFront = SCNBox(width: 12, height: 13, length: 1, chamferRadius: 0.2)
        boxFront.firstMaterial?.diffuse.contents = UIColor.white
        let boxFrontNode = SCNNode(geometry: boxFront)
        scene.rootNode.addChildNode(boxFrontNode)
        boxFrontNode.position = SCNVector3(x: 1, y: 5, z: 7)
        boxFrontNode.physicsBody = SCNPhysicsBody.static()
        boxFrontNode.physicsBody?.restitution = 1.0
        boxFrontNode.opacity = 0.4
        boxFrontNode.physicsBody?.friction = 0

        // animate the 3d object
       //room.physicsBody?.applyForce(SCNVector3(x: 0, y: 20, z: 0), asImpulse: true) //room.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
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
