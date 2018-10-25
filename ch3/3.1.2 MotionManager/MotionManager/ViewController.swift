//
//  ViewController.swift
//  Accelerometer
//
//  Created by 关东升 on 15/2/6.
//  本书网站：http://www.51work6.com
//  智捷课堂在线课堂：http://www.zhijieketang.com/
//  智捷课堂微信公共号：zhijieketang
//  作者微博：@tony_关东升
//  QQ：569418560 邮箱：eorient@sina.com
//  QQ交流群：162030268
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    @IBOutlet weak var xBar: UIProgressView!
    @IBOutlet weak var yBar: UIProgressView!
    @IBOutlet weak var zBar: UIProgressView!
    
    var motionManager  : CMMotionManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = 0.1
        
        if self.motionManager.accelerometerAvailable {
            self.motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(),
            withHandler: { (accelerometerData, error) -> Void in
                
                if error != nil {
                    self.motionManager.stopAccelerometerUpdates()
                } else {
                    NSLog("x = %f", accelerometerData.acceleration.x)
                    self.xLabel.text = String(format: "%f", accelerometerData.acceleration.x)
                    self.xBar.progress = abs(Float(accelerometerData.acceleration.x))
                    
                    NSLog("y = %f", accelerometerData.acceleration.y)
                    self.yLabel.text = String(format: "%f", accelerometerData.acceleration.y)
                    self.yBar.progress = abs(Float(accelerometerData.acceleration.y))
                    
                    NSLog("z = %f", accelerometerData.acceleration.z)
                    self.zLabel.text = String(format: "%f", accelerometerData.acceleration.z)
                    self.zBar.progress = abs(Float(accelerometerData.acceleration.z))
                }
            })
        } else {
            NSLog("Accelerometer is not available.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.motionManager.stopAccelerometerUpdates()
    }
}

