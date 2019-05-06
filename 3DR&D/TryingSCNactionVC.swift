//
//  TryingSCNactionVC.swift
//  3DR&D
//
//  Created by boppo on 4/1/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit
import ARKit
class TryingSCNactionVC: UIViewController {
    var sceneView : ARSCNView!
    
    var sphereNode : SCNNode!
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = ARSCNView()
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showWorldOrigin]
        
        let sphereShape = SCNSphere(radius: 0.2)
        // diffusing image to geometry i.e. with diffuse image
        sphereShape.firstMaterial?.diffuse.contents = UIImage(named: "Diffuse")
        
        // specular to geometry i.e. with specular image
        sphereShape.firstMaterial?.specular.contents = UIImage(named: "Specular")
        
        // normal to geometry i.e. with Normal image
        sphereShape.firstMaterial?.normal.contents = UIImage(named: "Normal")
        
        // emission to geometry i.e. with emission image
        sphereShape.firstMaterial?.emission.contents = UIImage(named: "Emission")
        
        // changing the shineness of the Reflection
        sphereShape.firstMaterial?.shininess = 50
        
        sphereNode = SCNNode(geometry: sphereShape)
        sphereNode.position = SCNVector3(x: 0, y: 0, z: -0.5)
        //MARK:- SCNActions
        let moveUp = SCNAction.moveBy(x: 0, y: 2, z: -0.5, duration: 2.5)
        let moveDown = SCNAction.moveBy(x: 0, y: -2, z: -0.5, duration: 2.5)
        let hoverSequence = SCNAction.sequence([moveUp,moveDown])
        let rotate = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 5.0)
        let rotateAndHover = SCNAction.group([rotate,hoverSequence])
        
        // repeating action in a loop
        let repeatAction = SCNAction.repeatForever(rotateAndHover)
        
        //adding action to Node
        sphereNode.runAction(repeatAction)
        
        
        sceneView.scene.rootNode.addChildNode(sphereNode)
        
        view = sceneView

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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        let location = touch?.location(in: sceneView)
        
        let hitResults = sceneView.hitTest(location!, types: .featurePoint)
        
        if let hitResult = hitResults.first{
            let transform = hitResult.worldTransform
            
            //MARK:- SCNTransactions
            let position = SCNVector3(x: transform.columns.3.x, y: transform.columns.3.y, z: transform.columns.3.z)
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 2
            sphereNode.position = position
            SCNTransaction.commit()
        }
        else{
            debugPrint("not detected")
        }
        
    }
    

}
