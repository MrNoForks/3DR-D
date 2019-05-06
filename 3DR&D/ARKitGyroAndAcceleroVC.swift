//
//  ARKitGyroAndAcceleroVC.swift
//  3DR&D
//
//  Created by boppo on 3/19/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit
import CoreMotion


class ARKitGyroAndAcceleroVC: UIViewController {

    @IBOutlet weak var lblGyro: UILabel!
    
    @IBOutlet weak var lblAccelero: UILabel!
    
    var motionManager = CMMotionManager()
    
    override func viewWillAppear(_ animated: Bool) {
        acceleroMeter()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func acceleroMeter(){
        motionManager.accelerometerUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, err) in
            if let myData = data{
//                if myData.acceleration.x > 5{
//                    print("Do something")
                print(myData.acceleration.x)
//                }
            }
        }
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
