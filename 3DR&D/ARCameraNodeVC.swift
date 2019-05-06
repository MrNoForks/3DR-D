//
//  ARCameraNodeVC.swift
//  3DR&D
//
//  Created by boppo on 3/20/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit
import ARKit

class ARCameraNodeVC: UIViewController,ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
     let newEarth = EarthNode()
    
    var newNode = ModelLoader()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        let scene = SCNScene()
        
        sceneView.scene = scene
        
      //  sceneView.debugOptions = .showWorldOrigin
        
       
        //newEarth.position = SCNVector3(x: 0, y: 0, z: -1)
        
        newNode.loadModel()
        
        newNode.position = SCNVector3(x: 0, y: 0, z: -1)
        
       // sceneView.scene.rootNode.camera = camera
        
     
        
        //sceneView.scene.rootNode.addChildNode(newEarth)
        
        sceneView.scene.rootNode.addChildNode(newNode)
        // Do any additional setup after loading the view.
        
          sceneView.scene.rootNode.position = SCNVector3(x: 0, y: 0, z: -2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        
        sceneView.session.run(configuration)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//     sceneView.scene.rootNode.position = SCNVector3(0, 0,1)
       // sceneView.session.pause()
        
//                    guard let frame = sceneView.session.currentFrame else {return}
//                    guard let cameraState = sceneView.session.currentFrame else{return}
//                    switch cameraState.camera.trackingState {
//
//                    case .normal:
//                        sceneView.session.run(ARWorldTrackingConfiguration(), options: .resetTracking)
//                    default:
//                        break
//
//                    }
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else { return }
         let transform = pointOfView.transform
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        //sceneView.scene.rootNode.position = SCNVector3(transform.m41, transform.m42, transform.m43)
       // newEarth.position = SCNVector3(x:  transform.m41 * 5, y:  transform.m42 * 2, z: -1)
        newNode.position = SCNVector3(x:  transform.m41 * 5, y:  transform.m42 * 2, z: -1)
        print(location)

    }
    
}
