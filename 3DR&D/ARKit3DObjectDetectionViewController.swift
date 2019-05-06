//
//  ARKit3DObjectDetectionViewController.swift
//  3DR&D
//
//  Created by boppo on 3/7/19.
//  Copyright © 2019 boppo. All rights reserved.
//
// we scan an object using apple app demo https://developer.apple.com/documentation/arkit/scanning_and_detecting_3d_objects


import UIKit
import ARKit

class ARKit3DObjectDetectionViewController: UIViewController,ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        //Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        //Create a new scene
        let scene = SCNScene(named: "GameScene.scn")!
        
        //set scene to SceneView's scene
        sceneView.scene = scene
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //create a session Configuration
        let configuration = ARWorldTrackingConfiguration()
        
        
        guard let trackedObjects = ARReferenceObject.referenceObjects(inGroupNamed: "AR3DObjectBottle", bundle: Bundle.main) else{print("No object Found"); return}
        
        //Object Detection
        configuration.detectionObjects = trackedObjects
        
        
        //Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //pause session when view is on background
        sceneView.session.pause()
    }
    
    // Called when an anchor is found
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        var node : SCNNode?
        print("Anchor Found")
        if let objectAnchor = anchor as? ARObjectAnchor{
            
            node = SCNNode()
            
            //creating a plane
            let plane = SCNPlane(width: CGFloat(objectAnchor.referenceObject.extent.x * 0.8), height: CGFloat(objectAnchor.referenceObject.extent.y * 0.5))
            
            //corner radius for plane
            plane.cornerRadius = plane.width / 8
            
            //adding spriteKit in Scene
            guard let spriteKitScene = SKScene(fileNamed: "Bottle") else{ print("spriteKitScene Not Found"); return node }
            
            //assigning plane with spriteKitScene as a texture
            plane.firstMaterial?.diffuse.contents = spriteKitScene
            
            // to make other side of scene same too we use double Sided
            plane.firstMaterial?.isDoubleSided = true
            
            plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.position = SCNVector3(x: objectAnchor.referenceObject.center.x, y: objectAnchor.referenceObject.center.y + 0.35, z: objectAnchor.referenceObject.center.z)
            
           // planeNode.eulerAngles.y = -.pi/2
            
            node?.addChildNode(planeNode)
            
        }
        
        return node
    }
    
}
