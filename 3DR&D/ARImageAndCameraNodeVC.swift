//
//  ARImageAndCameraNodeVC.swift
//  3DR&D
//
//  Created by boppo on 3/26/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit
import ARKit

class ARImageAndCameraNodeVC: UIViewController,ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var virtualObjectNode = ModelLoader()
    
    let smokeyNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        sceneView.showsStatistics = true
        
     //   sceneView.debugOptions = .showWorldOrigin
        
        let scene = SCNScene()
        
        // MARK:- Particle System
        //creating a Particle System //SceneKitParticleSystem1
        let smokey =  SCNParticleSystem(named: "smkey.scnp", inDirectory: nil)!        
        
        smokeyNode.position = SCNVector3(x: -1, y: -1, z: 0)
        smokeyNode.addParticleSystem(smokey)
        
        //adding a Particle System in scene
        // scene.rootNode.addParticleSystem(stars)
        scene.rootNode.addChildNode(smokeyNode)
        
        sceneView.scene = scene
        //0.005
        virtualObjectNode.loadModel(modelName: "UFO_4.dae", positionX: 0, positionY: 0, positionZ: 0.15, modelSize: 0.05, appearanceAnimation: true, withDuration: 5)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ARPhotos", bundle: Bundle.main) else {print("No images available"); return}
        
        configuration.detectionImages = trackedImages
        
        configuration.maximumNumberOfTrackedImages = 1
        
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        var node : SCNNode?
        
        if let imageAnchor = anchor as? ARImageAnchor{
            
            node = SCNNode()
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
           //plane.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(CGFloat(0.5))
            
            plane.firstMaterial?.diffuse.contents = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -.pi/2            
            
            planeNode.addChildNode(virtualObjectNode)
          
            smokeyNode.removeFromParentNode()

            node?.addChildNode(planeNode)
            
        }
        
    
        
        return node
    }

    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else { return}
        
        let transform = pointOfView.transform
        
//        virtualObjectNode.position = SCNVector3(x: transform.m41 * 2.5, y: transform.m42 * 2, z: 0.15)
       virtualObjectNode.position = SCNVector3(x: transform.m31 * -2, y: transform.m32 * -2, z: 0.2)
    }

}
