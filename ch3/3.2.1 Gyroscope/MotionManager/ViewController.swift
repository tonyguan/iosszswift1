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
        self.motionManager.gyroUpdateInterval = 0.1
        
        if self.motionManager.gyroAvailable {
            self.motionManager.startGyroUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (gyroData, error) -> Void in
      
                if error != nil {
                    self.motionManager.stopGyroUpdates()
                } else {
                    
                    let rotate = gyroData.rotationRate
                    
                    NSLog("x = %f", rotate.x)
                    self.xLabel.text = String(format: "%f", rotate.x)
                    self.xBar.progress = abs(Float(rotate.x))
                    
                    NSLog("y = %f", rotate.y)
                    self.yLabel.text = String(format: "%f", rotate.y)
                    self.yBar.progress = abs(Float(rotate.y))
                    
                    NSLog("z = %f", rotate.z)
                    self.zLabel.text = String(format: "%f", rotate.z)
                    self.zBar.progress = abs(Float(rotate.z))
                    
                }
            })
        } else {
            NSLog("Gyroscope is not available.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.motionManager.stopGyroUpdates()
    }
}

