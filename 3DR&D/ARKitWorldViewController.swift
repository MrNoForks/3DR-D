//
//  ARKitWorldViewController.swift
//  3DR&D
//
//  Created by boppo on 3/5/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit
import ARKit

class ARKitWorldViewController: UIViewController,ARSCNViewDelegate {
    
    @IBOutlet var sceneView : ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self
        
        //Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        //Create a new scene
      //  let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let scene = SCNScene()
        
        //MARK:- directly adding a Node
        let earthNode = EarthNode()
        earthNode.position = SCNVector3(x:0,y:0,z:-1)
        
        scene.rootNode.addChildNode(earthNode)
        
        // MARK:- Particle System
        //creating a Particle System //SceneKitParticleSystem1
        let stars =  SCNParticleSystem(named: "smkey.scnp", inDirectory: nil)!        
        
        let starsnode = SCNNode()
        starsnode.position = SCNVector3(x: -1, y: -2, z: 0)
        starsnode.addParticleSystem(stars)
    
        //adding a Particle System in scene
       // scene.rootNode.addParticleSystem(stars)
        scene.rootNode.addChildNode(starsnode)
        
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //create a session Configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        sceneView.session.pause()
    }

    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //recording first touch
        let touch = touches.first
        
        // getting location of touch
        let location = touch?.location(in: sceneView)
        
        //MARK:- searches for anchor at touched coordinate in ARScene "hitTest(position,type)"
        // gets the AR anchor available in the sceneView
        let hitResults = sceneView.hitTest(location!, types: .featurePoint)
        
        //Checking if we have HitResult
        if let hitTestResult = hitResults.first{
            
            // to get coordinate to place object we use transform
            let transform = hitTestResult.worldTransform
            
            // getting position from worldTransform
            let position = SCNVector3(x: transform.columns.3.x,y: transform.columns.3.y,z: transform.columns.3.z)
            
            let newEarth = EarthNode()
            newEarth.position = position
            print("detected")
            sceneView.scene.rootNode.addChildNode(newEarth)
        }
        else{
            print("not detected")
        }
    }
    
    
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        print("i am updated")
//    }

    // MARK:- rotating model according to camera
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        // rotating model according to camera
//        guard let frame = self.sceneView.session.currentFrame else{return}
//        arNode.eulerAngles.y = frame.camera.eulerAngles.y
//    }

}
