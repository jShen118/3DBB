import UIKit
import QuartzCore
import SceneKit
import Foundation
import SwiftUI

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    let ballCategoryBitMask = 1
    var scene = GameScene()
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    
    func renderer(_ aRenderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        //DispatchQueue.main.async {self.scene.score += 1}
        //run per frame logic here
        //print("\(scene.rootNode.childNode(withName: "bouncer", recursively: false)!.physicsBody?.velocity)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceneView = self.view as! SCNView
        let uiController = UIHostingController(rootView: GameUIView(gameScene: scene))
        addChild(uiController)
        uiController.view.frame = sceneView.frame
        uiController.view.backgroundColor = UIColor.clear
        sceneView.addSubview(uiController.view)
        
        sceneView.scene = scene
        sceneView.delegate = self
        
        // allows the user to manipulate the camera
        sceneView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // configure the view
        sceneView.backgroundColor = UIColor.black
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanning(pan:)))
        sceneView.addGestureRecognizer(panGesture)
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

    
    
    //isInBounds not working rn
    @objc func handlePanning(pan: UIPanGestureRecognizer) {
        let sceneView = SCNView()
        //let touchPoint = pan.location(in: sceneView)
        let xPan = pan.velocity(in: sceneView).x
        let zPan = pan.velocity(in: sceneView).y
        //scene.rootNode.childNode(withName: "bouncer", recursively: false)!.physicsBody?.velocity = SCNVector3(x: Float(xPan), y: 0.0, z: Float(zPan))
        scene.rootNode.childNode(withName: "bouncer", recursively: false)!.runAction(SCNAction.moveBy(x: xPan/1000, y: 0, z: zPan/1000, duration: 0.1))
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = SCNView()
        
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
}
