//
//  ARKitRnD2ViewController.swift
//  3DR&D
//
//  Created by boppo on 3/14/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit
import ARKit
import CoreMotion

class ARKitRnD2ViewController: UIViewController,ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var i = 0
    
    //   var anchor : ARAnchor?
    weak var currentModelNode : SCNNode?
    //    var anchorFound : Int?
    
    var virtualObjectNode : SCNNode!
    
    var smokeyNode : SCNNode?
    
    var motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        let scene = SCNScene()
        
        sceneView.showsStatistics = true
        
       
        
        let cameraSCNNode = SCNNode()
        
        cameraSCNNode.camera = SCNCamera()
        
        
        cameraSCNNode.position = SCNVector3(0.3,0.3,0.3)
        
        sceneView.scene.rootNode.addChildNode(cameraSCNNode)
        
      //  sceneView.allowsCameraControl = true
        
        sceneView.scene = scene
        
        if let smokey = SCNParticleSystem(named: "smkey.scnp", inDirectory: nil){
            smokeyNode = SCNNode()
            smokeyNode!.position =  SCNVector3(x: -1, y: -1, z: 0)
            smokeyNode!.addParticleSystem(smokey)
            
            sceneView.scene.rootNode.addChildNode(smokeyNode!)
        }
        
        virtualObjectNode = virtualModelLoader()
        
     //   acceleroMeter()
        
        
        //        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        //        sceneView.addGestureRecognizer(gestureRecognizer)
    }
    
    
    func acceleroMeter(){
        motionManager.accelerometerUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, err) in
            if let myData = data{
                //                if myData.acceleration.x > 5{
                //                    print("Do something")
                var x : Double!
                switch UIDevice.current.orientation {
                case .portrait : x = myData.acceleration.x
                case .portraitUpsideDown : x = myData.acceleration.x
                case .landscapeLeft : x = myData.acceleration.y
                case .landscapeRight : x = myData.acceleration.y
                    
                    //                case .portrait : x = abs(myData.acceleration.x) > 0.2 ? 0.2*(myData.acceleration.x < 0 ? -1 : 1) :myData.acceleration.x
                    //                case .portraitUpsideDown : x = abs(myData.acceleration.x) > 0.2 ? 0.2*(myData.acceleration.x < 0 ? -1 : 1) :myData.acceleration.x
                    //                case .landscapeLeft : x = abs(myData.acceleration.y) > 0.2 ? 0.2*(myData.acceleration.y < 0 ? -1 : 1) :myData.acceleration.y
                //                case .landscapeRight : x = abs(myData.acceleration.y) > 0.2 ? 0.2*(myData.acceleration.y < 0 ? -1 : 1) :myData.acceleration.y
                default : x = 0
                }
          //      x = abs(Double(self.currentModelNode?.position.x ?? 0) + x) > 0.3 ? 0.3*(myData.acceleration.x < 0 ? 1 : -1) : myData.acceleration.x
                self.currentModelNode?.position = SCNVector3(x,0,0.3)
                //                }
                print(self.currentModelNode?.position.x)
            }
        }
    }
    
    
    
    //    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
    ////        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
    ////
    ////
    ////            let sceneView = gestureRecognizer.view as! ARSCNView
    ////            let touchLocation = gestureRecognizer.location(in: sceneView)
    ////            let hitTestResult = sceneView.hitTest(touchLocation, options: [:])
    ////
    ////
    ////            if !hitTestResult.isEmpty {
    ////
    ////                print("hit result")
    ////
    ////                guard let hitTestResult = hitTestResult.first else {
    ////                    return
    ////                }
    ////
    ////                currentModelNode?.position.x = hitTestResult.localCoordinates.x
    ////                currentModelNode?.position.y = hitTestResult.localCoordinates.y
    ////
    ////            }
    ////        }
    //
    //    }
    
    func virtualModelLoader() -> SCNNode{
        let virtualObject = ModelLoader()
        
        virtualObject.loadModel(modelName: "model_id_1.dae")
        
        virtualObject.position = SCNVector3(x: 0, y: 0, z: 0.3)
        
        virtualObject.scale = SCNVector3(x: 0.0025, y: 0.0025, z: 0.0025)
        
        return virtualObject
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ARPhotos", bundle: Bundle.main) else { print("Image not found"); return }
        
        configuration.detectionImages = trackedImages
        
        configuration.maximumNumberOfTrackedImages = 0
        
        sceneView.session.run(configuration)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        var node : SCNNode?
        
        //anchorFound = 1
        
        if let imageAnchor = anchor as? ARImageAnchor{
            
            
            
            node = SCNNode()
            
            //            let smokey = SCNParticleSystem(named: "smkey.scnp", inDirectory: nil)!
            //            let smokeyNode = SCNNode()
            //            smokeyNode.position =  SCNVector3(x: -1, y: -1, z: 0)
            //            smokeyNode.addParticleSystem(smokey)
            //
            //            sceneView.scene.rootNode.addChildNode(smokeyNode)
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -.pi/2
            
            let appearanceAction = SCNAction.scale(to: (CGFloat(virtualObjectNode.scale.x + virtualObjectNode.scale.x)), duration: 5)
            
            virtualObjectNode.runAction(appearanceAction) {
                self.smokeyNode?.removeFromParentNode()
            }
            
            
            // for keeping tracking of VirtualObjectNode
            currentModelNode = virtualObjectNode
            
            planeNode.addChildNode(virtualObjectNode)
            
            
            
            node?.addChildNode(planeNode)
            
            //constraints node to a view at one position
            //virtualObjectNode.constraints = [SCNLookAtConstraint(target: sceneView.pointOfView)]
        }

        return node
    }
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        //        if currentModelNode != nil{
        //
        //
        //            guard let frame = sceneView.session.currentFrame else {return}
        //            guard let cameraState = sceneView.session.currentFrame else{return}
        //            switch cameraState.camera.trackingState {
        //
        //            case .normal:
        //
        //                // virtualObjectNode?.eulerAngles.x = frame.camera.eulerAngles.x
        //                currentModelNode?.eulerAngles.y = frame.camera.eulerAngles.y
        //                //  virtualObjectNode?.eulerAngles.z = frame.camera.eulerAngles.z
        //                //  virtualObjectNode?.eulerAngles = frame.camera.eulerAngles
        //                i+=1
        //                print("updated \(i)")
        //            default:
        //                break
        //
        //            }
        //        }
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    
}
