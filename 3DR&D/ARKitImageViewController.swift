//
//  ARKitImageViewController.swift
//  3DR&D
//
//  Created by boppo on 3/6/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit
import ARKit

class ARKitImageViewController: UIViewController,ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        sceneView.delegate = self
        
        sceneView.showsStatistics = true
        
        // Create a new empty scene
        let scene = SCNScene()
        
        // Create a new scene with model already
        //  let scene = SCNScene(named: "ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // let configuration = ARImageTrackingConfiguration()
        
        //trackedImages is for getting reference image for image detection
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ARPhotos", bundle: Bundle.main)else{print("No images available");return}
        
        //A set of images for ARKit to attempt to detect in the user's environment.
        configuration.detectionImages = trackedImages
        
        //The maximum number of detection images to simultaneously track movement for.
        configuration.maximumNumberOfTrackedImages = 1
        
        // Run the view's session
        sceneView.session.run(configuration)
        // sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
         // Pause the view's session
        sceneView.session.pause()
    }
    
    //       Override to create and configure nodes for anchors added to the view's session.
    // called when we are finding an anchor or ARKit finds an anchor  (i.e. when a new plane is detected an new anchor is added)
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        var node : SCNNode?
        
        if let imageAnchor = anchor as? ARImageAnchor{
            
            //setting an SCNNode()
            node = SCNNode()
            
            //adding a overlay of plane on reference image
            // replacing the image used for reference with a plane
            // and getting size of real world image using imageAnchor
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(CGFloat(0.5))
            
            // creating a node of plane geometry we specified above
            let planeNode = SCNNode(geometry: plane)
            
//            //MARK:- Rotating a Plane x =1 as we wan to rotate only x
//            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
             // rotating plane to match angle of original image
            planeNode.eulerAngles.x = -.pi/2
            
            //MARK:- Adding .dae Model
            
            let virtualObjectModel = ModelLoader()
            
            virtualObjectModel.loadModel(modelName: "model_id_1.dae")
            
            //setting position of virtualObject
            virtualObjectModel.position = SCNVector3(x: 0, y: 0, z: 0.15)
            
            //scaling Virtual Object
            virtualObjectModel.scale = SCNVector3(x: 0.0025, y: 0.0025, z: 0.0025)
            
            
            //Creating an action to Scale model
            let appearanceAction = SCNAction.scale(to: CGFloat(virtualObjectModel.scale.x+virtualObjectModel.scale.x), duration: 5)
            
            appearanceAction.timingMode = .easeOut
            virtualObjectModel.runAction(appearanceAction)
            
            // adding virtualObjectModel on planeNode
            planeNode.addChildNode(virtualObjectModel)
            
            //adding plane node
            node?.addChildNode(planeNode)
        }
        
        return node
    }
}
