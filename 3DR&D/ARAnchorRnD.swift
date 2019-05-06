//
//  ARAnchorRnD.swift
//  3DR&D
//
//  Created by boppo on 3/29/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit
import ARKit
class ARAnchorRnD: UIViewController,ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var virtualObjectNode = ModelLoader()
    
    let smokeyNode = SCNNode()
    
    var tempAnchor : ARAnchor?
    
    @IBOutlet weak var changePositionButton: UIButton!
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
        virtualObjectNode.loadModel(modelName: "UFO_4.dae", positionX: 0, positionY: 0, positionZ: 0 , modelSize: 0.05, appearanceAnimation: true, withDuration: 5)
        
        sceneView.bringSubviewToFront(changePositionButton)
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
            
            tempAnchor = ARAnchor(transform: imageAnchor.transform)
            
            
            //            node = SCNNode()
            //
            //            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            //
            //            plane.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(CGFloat(0.5))
            //
            //            let planeNode = SCNNode(geometry: plane)
            //
            //            planeNode.eulerAngles.x = -.pi/2
            //
            //            planeNode.addChildNode(virtualObjectNode)
            //
            //            smokeyNode.removeFromParentNode()
            //
            //            node?.addChildNode(planeNode)
            print("added image anchor")
            sceneView.session.add(anchor: tempAnchor!)
        }
        else{
            node = SCNNode()
            //
            //            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            //
            //            plane.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(CGFloat(0.5))
            //
            //            let planeNode = SCNNode(geometry: plane)
            
            virtualObjectNode.eulerAngles.x = -.pi/2
            
            //    node?.addChildNode(virtualObjectNode)
            
            smokeyNode.removeFromParentNode()
            
            node?.addChildNode(virtualObjectNode)
            
            
            print("added")
        }
        
        
        
        return node
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
                guard let pointOfView = sceneView.pointOfView else { return}
        
                let transform = pointOfView.transform
        //
                virtualObjectNode.position = SCNVector3(x: -transform.m31*2 , y: 0 , z: -transform.m33)
        
    }
    
    @IBAction func changePositionButton(_ sender: UIButton) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        let materials = virtualObjectNode.geometry?.firstMaterial
        materials?.diffuse.contents = UIColor.white
        SCNTransaction.commit()
        
        let action = SCNAction.moveBy(x: 0, y: -0.8, z: 0, duration: 0.5)
        virtualObjectNode.runAction(action)
    }
    
}
