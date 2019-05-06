//
//  ARImageAndCameraNodewithRotationVC.swift
//  3DR&D
//
//  Created by boppo on 3/28/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit
import ARKit
import CoreMotion
class ARImageAndCameraNodewithRotationVC: UIViewController,ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView : ARSCNView!
    
    var virtualObjectNode = ModelLoader()
    
    var motionManager = CMMotionManager()
    
    @IBOutlet weak var positionButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         gyroMeter()
        
        let scene = SCNScene()
        
        sceneView.showsStatistics = true
        
      //  sceneView.debugOptions = .showWorldOrigin
        
       
        
        virtualObjectNode.loadModel(modelName: "dino.dae", positionX: 0, positionY: 0, positionZ: -0.7, modelSize: 0.05, appearanceAnimation: true, withDuration: 5)
        
        scene.rootNode.addChildNode(virtualObjectNode)
        
         sceneView.scene = scene
        
        sceneView.delegate = self
        
        view.bringSubviewToFront(positionButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    override func viewWillDisappear(_ animated: Bool) {
        sceneView.session.pause()
    }
    
    
    func gyroMeter(){
        motionManager.gyroUpdateInterval = 0.2
        
        motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
            if let myData = data{
              //  print("myData.rotationRate.x \(myData.rotationRate.x)")
            }
        }
        
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
    //   print("myData.rotationRate.x \(motionManager.gyroData?.rotationRate.y)")
        
        guard let pointOfView = sceneView.pointOfView else { return}

        let transform = pointOfView.transform
//
//      //  print(transform.m31)
//
        virtualObjectNode.position = SCNVector3(x: transform.m31 * -2, y: transform.m32 * -2, z: -1)
        
       // virtualObjectNode.position = SCNVector3(x: transform.m41 * 2.5, y: transform.m42 * 2, z: -0.7)
    }
    
    @IBAction func changePositionBtn(_ sender: UIButton) {
          guard let pointOfView = sceneView.pointOfView else { return}
        
        let transform = pointOfView.transform
        
        //  print(transform.m31)
        
        virtualObjectNode.position = SCNVector3(x: transform.m31 * -2, y: transform.m32 * -2, z: -1)
    }
    
    
}
