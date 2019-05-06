//
//  ARKitRnDViewController.swift
//  3DR&D
//
//  Created by boppo on 3/7/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit
import ARKit

class ARKitRnDViewController: UIViewController,ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!

 //   var anchor : ARAnchor?
    
    var anchorFound : Int?
    
    var virtualObjectNode : SCNNode!
    
 //   var i : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        let scene = SCNScene()
        
        sceneView.scene = scene
        
        virtualObjectNode = virtualModelLoader()
    }
    
    func virtualModelLoader() -> SCNNode{
        let virtualObject  = ModelLoader()
        
        virtualObject.loadModel(modelName: "model_id_1.dae")
        
        virtualObject.position = SCNVector3(x: 0, y: 0, z: 0.3)
        
        virtualObject.scale = SCNVector3(x : 0.0025, y : 0.0025,z : 0.0025)
        
        return virtualObject
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ARPhotos", bundle: Bundle.main) else{ print("Image not found"); return}
        
        configuration.detectionImages = trackedImages
        
        configuration.maximumNumberOfTrackedImages = 1
        
        sceneView.session.run(configuration)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        sceneView.session.pause()
    }
    
    //image anchor  found
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        var node : SCNNode?
        
        if let imageAnchor = anchor as? ARImageAnchor{
            
            node = SCNNode()
            
            // MARK:- Particle System
            //creating a Particle System //SceneKitParticleSystem1
            let smokey =  SCNParticleSystem(named: "smkey.scnp", inDirectory: nil)!
            
            let smokeyNode = SCNNode()
            smokeyNode.position = SCNVector3(x: -1, y: -1, z: 0)
            smokeyNode.addParticleSystem(smokey)
            
            //adding a Particle System in scene
            // scene.rootNode.addParticleSystem(stars)
            sceneView.scene.rootNode.addChildNode(smokeyNode)
            
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -.pi/2
            
            
            
            let appearanceAction = SCNAction.scale(to : CGFloat(virtualObjectNode.scale.x+virtualObjectNode.scale.x), duration: 5)
            
            //  virtualObject.runAction(appearanceAction)
            
            virtualObjectNode.runAction(appearanceAction) {
                smokeyNode.removeFromParentNode()
            }
            
            planeNode.addChildNode(virtualObjectNode)
            
            node?.addChildNode(planeNode)
            
        }
        
        //self.anchor = anchor
        anchorFound = 1
        return node
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // rotating model according to camera
        //        guard let frame = self.sceneView.session.currentFrame else{return}
        //        arNode.eulerAngles.y = frame.camera.eulerAngles.y
        guard let cameraState = sceneView.session.currentFrame else{return}
        switch cameraState.camera.trackingState {
        case .normal:
            print("boll beta")
            if anchorFound != nil  {
                guard let camera = sceneView.pointOfView else { return }
                //   print(sceneView.isNode(arNode!, insideFrustumOf: camera))
                if !sceneView.isNode(virtualObjectNode, insideFrustumOf: camera){
                    respawnAtNewPosition()
                }
            }
            
        default:
            print("auu kya???")
        }

        
    }
    
    
    func respawnAtNewPosition(){
        
        // remove virtualNode
        virtualObjectNode.removeFromParentNode()
        
        sceneView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking,.removeExistingAnchors])
        virtualObjectNode.position = SCNVector3(x: 0, y: 0, z: -1)
        
        sceneView.scene.rootNode.addChildNode(virtualObjectNode)
    }
    
    @IBAction func btnResetPress(_ sender: UIButton) {
        respawnAtNewPosition()
        
        //        let currentDateTime = Date()
        //
        //        let formatter = DateFormatter()
        //        formatter.timeStyle = .medium
        //
        //        let nxtTime = Date()
        //        nxtTime.addingTimeInterval(300)
        //
        //
        //        if formatter.string(from: currentDateTime)>formatter.string(from: nxtTime){
        //            stop = 1
        //        }
        
    }

}

