//
//  ViewController.swift
//  Teslameter
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
    
    @IBOutlet weak var magnitude: UILabel!
    
    var motionManager : CMMotionManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.motionManager = CMMotionManager()
        self.motionManager.magnetometerUpdateInterval = 1/30
        
        
        if self.motionManager.magnetometerAvailable {
            self.motionManager.startMagnetometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (magnetometerData, error) -> Void in
                
                if (error != nil) {
                    self.motionManager.stopMagnetometerUpdates()
                } else {
                    let newHeading = magnetometerData.magneticField
                    
                    NSLog("x = %.2f", newHeading.x)
                    self.xLabel.text = String(format: "%.2f", newHeading.x)
                    self.xBar.progress = abs(Float(newHeading.x) / 100.0)
                    
                    NSLog("y = %.2f", newHeading.y)
                    self.yLabel.text = String(format: "%.2f", newHeading.y)
                    self.yBar.progress = abs(Float(newHeading.y) / 100.0)
                    
                    NSLog("z = %.2f", newHeading.z)
                    self.zLabel.text = String(format: "%.2f", newHeading.z)
                    self.zBar.progress = abs(Float(newHeading.z) / 100.0)
                    
                    let magnitude = sqrt(newHeading.x * newHeading.x
                        + newHeading.y * newHeading.y
                        + newHeading.z * newHeading.z)
                    
                    self.magnitude.text = String(format: "%.2f", magnitude)
                }
            })
            
        } else {
            NSLog("磁力计不可用.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.motionManager.stopMagnetometerUpdates()
    }

}

