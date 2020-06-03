import UIKit
import QuartzCore
import SceneKit
import Foundation
import SwiftUI

class GameViewController: UIViewController {
    let ballCategoryBitMask = 1
    let scene = GameScene()
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
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
