//
//  EarthNode.swift
//  3DR&D
//
//  Created by boppo on 3/5/19.
//  Copyright © 2019 boppo. All rights reserved.
//

/*
 Diffuse :- Tells which color should apply where
 Specular:- Tells where reflections should happen(more reflection where it is white & less reflection where it is black)
 Normal:- Buffs on surface of objetcs //i.e. topography(the arrangement of the natural and artificial physical features of an area.) of object
 Emission :- Tells where the objects emits light from
 */

import ARKit


// Creating Your Own Node
class EarthNode: SCNNode {
    
    
    override init() {
        super.init()
        
        //creating a sphere
        //self.geometry = SCNSphere()
        
        //with radius
        self.geometry = SCNSphere(radius: 0.2)
        
        // diffusing color to geometry i.e. with blue color
        //   self.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        // diffusing image to geometry i.e. with diffuse image
        self.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Diffuse")
        
        // specular to geometry i.e. with specular image
        self.geometry?.firstMaterial?.specular.contents = UIImage(named: "Specular")
        
        // normal to geometry i.e. with Normal image
        self.geometry?.firstMaterial?.normal.contents = UIImage(named: "Normal")
        
        // emission to geometry i.e. with emission image
        self.geometry?.firstMaterial?.emission.contents = UIImage(named: "Emission")
        
        // changing the shineness of the Reflection
        self.geometry?.firstMaterial?.shininess = 50
        
        //MARK:- Adding a Rotation Action To an Object
        
        /* Double.pi gives a pi value(pi is in radian ,1pi =180 degrees , so divide pi by 180,
        we get value for 1 degree by it then we multiply it by 360 to rotate 360 degrees
         
         around(we specify around which axis we want to rotate it around)
         duration (with how much time)
         */
        let action = SCNAction.rotate(by: CGFloat(360*(Double.pi / 180)), around: SCNVector3(x:0, y:1, z:0), duration: 8)
        
        // repeating action in a loop
        let repeatAction = SCNAction.repeatForever(action)
        
        //adding action to Node
        self.runAction(repeatAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}
