//
//  SceneViewController.swift
//  3DR&D
//
//  Created by boppo on 3/5/19.
//  Copyright © 2019 boppo. All rights reserved.
//

//We cant see the object in the seen for 2 reason:-
/*
 1. As there is no light object turns out to be Black(as there is no light that shines on it)
 2. Camera might not be positioned accurately(camera is in the center and the node ) so we are not able to see the object
 */

/*
 we have a SCNView in that
 SCNView.scene we add a scene
 this scene is used to add Nodes(i.e has nodes which we want to display(light,node,camera) (SCNNode))
 
 */

/* 
 Diffuse :- Tells which color should apply where
 Specular:- Tells where reflections should happen(more reflection where it is white & less reflection where it is black)
 Normal:- Buffs on surface of objetcs //i.e. topography(the arrangement of the natural and artificial physical features of an area.) of object
 Emission :- Tells where the objects emits light from
 */

import UIKit
import SceneKit

class SceneViewController: UIViewController {

 //   @IBOutlet var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        
        
        //MARK:- Setting SCNview.camera property with SCNCamera
        
        //adding a camera in SceneKit . First creating a node and then initializing its camera property with SCNCamera object
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        // Setting camera position
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        
        //adding camera to scene i.e. SceneNode()
        scene.rootNode.addChildNode(cameraNode)
        
        
        
        // MARK:- Adding Light for the Object(not compulsory)
        
        //creating lightNode i.e. SCNNode() and then adding light property to it by SCNLight()
        let lightNode = SCNNode()
        
        lightNode.light = SCNLight()
        
        // Setting type of light you want
        lightNode.light?.type = .omni
        
        // Setting lightNode position
        lightNode.position = SCNVector3(x: 0,y : 10,z : 2)
        
        //adding LightNode to Scne
        scene.rootNode.addChildNode(lightNode)
        
        
        
        // MARK:- Particle System
        //creating a Particle System
        let stars =  SCNParticleSystem(named: "SceneKitParticleSystem.scnp", inDirectory: nil)!
        
        //adding a Particle System in scene
        scene.rootNode.addParticleSystem(stars)
        
        
        
        
        // MARK:- Adding created Node by Us
        
        //creating object of Created Node
        let earthNode = EarthNode()

        //adding Created Node in scene
        scene.rootNode.addChildNode(earthNode)
        
        
        
        
        
        //MARK:- Setting SCNview.scene property with SCNScene
        
        //Setting SceneView scene property with SCNScene object
        let sceneView = self.view as! SCNView
        sceneView.scene = scene
        
        sceneView.showsStatistics = true
        sceneView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        // for accessing camera property of SceneView
        sceneView.allowsCameraControl = true
        
        
        // Do any additional setup after loading the view.
    }
    
    //Hidding Status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
