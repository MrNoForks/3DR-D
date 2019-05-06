//
//  ARKitPlaneViewController.swift
//  3DR&D
//
//  Created by boppo on 3/5/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARKitPlaneViewController: UIViewController,ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    
    // for ARPlane
    var planeGeometry : SCNPlane!
    
//    // for storing unique ID's of plane that detected
//    let planeIdentifiers = [UUID]()
    
    // for storing all records of ARArchors
    var anchors = [ARAnchor]()
    
    // for Light Node
    var sceneLight : SCNLight!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set view's delegate
        sceneView.delegate = self
        
        // show statistics such as fps & timing
        sceneView.showsStatistics = true
        
        //disable automatic addition of light as we are adding our own light
        sceneView.autoenablesDefaultLighting = false
        
        let scene = SCNScene()
        
        //creating SCNLight
        
        sceneLight = SCNLight()
        sceneLight.type = .omni
        
        let lightNode = SCNNode()
        lightNode.light = sceneLight
        lightNode.position = SCNVector3(x : 0, y : 10, z : 2)
        
        //setting Sceneview Scene
        sceneView.scene = scene
        
        //adding LightNode
        sceneView.scene.rootNode.addChildNode(lightNode)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        // Create a Session Configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //for plane detection
        configuration.planeDetection = .horizontal
        
        // for light estimation
        configuration.isLightEstimationEnabled = true
        
        //run the view's session
        sceneView.session.run(configuration)
        //   sceneView.session.run(configuration, options: .resetTracking)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // as light estimation couldnt update automatically we have to add it
    // updateAtTime updates at interval where we can continuosly perform updates
    // update intensity of light
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let estimate = self.sceneView.session.currentFrame?.lightEstimate{
            sceneLight.intensity = estimate.ambientIntensity
        }
    }
    
    // called when we are finding an anchor or ARKit finds an anchor  (i.e. when a new plane is detected an new anchor is added)
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
       // print("found new anchor")
        var node : SCNNode?
        
        // checking is found anchor is an ARPlane Anchor
        if let planeAnchor = anchor as? ARPlaneAnchor{
            
            //setting an SCNNode()
            node = SCNNode()
            
            // creating an Plane (extent == > length) //cmd+extent for summary
            planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            // apply a color to Plane
            planeGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(CGFloat(0.5))
            
            //creating a Planenode with Planegeometry
            let planeNode = SCNNode(geometry: planeGeometry)
            
             // since we are using scenekit here for plane our plane is vertical we declare y=0 and will rotate the planeNode around x axis with 90 degree
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
            
            //MARK:- Rotating a Plane x =1 as we wan to rotate only x
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
            //updating the material
            updateMaterial()
            
            //adding planeNode to node
            node?.addChildNode(planeNode)
            
            // appending found anchor to list of anchor
            anchors.append(planeAnchor)
        }
        return node
    }
    
    
    // to take care of updates of anchors i.e. moving along table
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        //print("i am updated")
        //checking if we got an  planeAnchor
        if let planeAnchor = anchor as? ARPlaneAnchor{
            
            //checking if our anchor already contains this PlaneAnchor
            if anchors.contains(planeAnchor){
                
                //checking if already put a plane in the node
                if node.childNodes.count > 0 {
                    
                    // if we have the plane we get the plane
                    let planeNode = node.childNodes.first!
                    
                    // after getting the plane we update its position
                    planeNode.position = SCNVector3(x:planeAnchor.center.x,y:0,z:planeAnchor.center.z)
                    
                    // after updating position we will change the plane's geometry
                    
                    // checking if the geomtry is castable as SCNPlane
                    if let plane = planeNode.geometry as? SCNPlane{
                        plane.width = CGFloat(planeAnchor.extent.x)
                        plane.height = CGFloat(planeAnchor.extent.z)
                        
                        //updating the material
                        updateMaterial()
                    }
                    
                    // by this can update the detected surface of ARScene but we still require to update materials
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: sceneView)
        addNodeAtLocation(location: location!)
    }
    

    
    func updateMaterial(){
        let material = self.planeGeometry.materials.first!
        
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(self.planeGeometry.width), Float(self.planeGeometry.height), 1)
    }
    
    func addNodeAtLocation(location : CGPoint){
        guard anchors.count > 0 else {print("anchors are not created yet"); return }
        
        //existingPlaneUsingExtent to tap on whole extent(size) of plane
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        
        if hitResults.count > 0 {
            let result = hitResults.first!
            // y+0.15 for model to be up 0.15
            let newLocation = SCNVector3(x: result.worldTransform.columns.3.x, y: result.worldTransform.columns.3.y + 0.15, z: result.worldTransform.columns.3.z)
            
            let earthNode = EarthNode()
            earthNode.position = newLocation
            print("touched")
            sceneView.scene.rootNode.addChildNode(earthNode)
        }
    }
    
}
