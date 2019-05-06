//
//  ARKitRandomSpawnerViewController.swift
//  3DR&D
//
//  Created by boppo on 3/5/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit
import ARKit

class ARKitRandomSpawnerViewController: UIViewController,ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var counterLabel: UILabel!
    
    var counter : Int = 0 {
        didSet{
            counterLabel.text = "\(counter)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.run(configuration)
        //   sceneView.session.run(configuration, options: .resetTracking)
        
        addObject()
    }
    override func viewDidDisappear(_ animated: Bool) {
        sceneView.session.pause()
    }
    
    //MARK:- For adding Object in Scene
    func addObject(){
        let model = ModelLoader()
        model.loadModel()
        
        let xPos = randomPosition(lower: -1.5, upper: 1.5)
        let yPos = randomPosition(lower: -1.5, upper: 1.5)
        
        // z = -1 so object is away from person
        model.position = SCNVector3(x: xPos, y: yPos, z: -1)
        
        sceneView.scene.rootNode.addChildNode(model)
    }
    
    //MARK:- For generating Random position
    func randomPosition(lower : Float , upper : Float) -> Float{
        return Float(arc4random())/Float(UInt32.max) * (lower - upper) + upper
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        //recording first touch
        let touch = touches.first
        
        // getting location of touch
        let location = touch?.location(in: sceneView)
        
        //MARK:- searches for object at touched coordinate in ARScene "hitTest(position,options)"
        let hitResults = sceneView.hitTest(location!, options: nil)
        
        if let hitResult = hitResults.first {
            let node = hitResult.node
            print("holla")
            if node.name == "ARShip"{
                
                // remove the node from ParentNode
                node.removeFromParentNode()
                
                //removes all nodes from ParentNode
               // removeAllNodesFromRootNodes()
                
                counter += 1
                addObject()
            }
        }
    }
    
    //MARK:- "By me" removes all nodes from ParentNode
    func removeAllNodesFromRootNodes(){
        sceneView.scene.rootNode.enumerateChildNodes{
            (node,stop) in
            // node is current child being evaluated
            // Set *stop to true in the block to abort further processing of the child node subtree.
            node.removeFromParentNode()
        }
    }
}
