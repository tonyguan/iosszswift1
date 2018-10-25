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

//定义FilterTypes枚举类型
public enum FilterTypes : Int {
    case NONE = 0
    case LOW_PASS_FILTER = 1
    case HIGH_PASS_FILTER  = 2
}

//定义过滤因子常量
let FILTER_FACTOR  = 0.1

class ViewController: UIViewController {
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    @IBOutlet weak var xBar: UIProgressView!
    @IBOutlet weak var yBar: UIProgressView!
    @IBOutlet weak var zBar: UIProgressView!
    
    var filteredAccelX : UIAccelerationValue = 0.0
    var filteredAccelY : UIAccelerationValue = 0.0
    var filteredAccelZ : UIAccelerationValue = 0.0
    
    @IBOutlet weak var filterControl: UISegmentedControl!
    
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
                        
                        let acceleration = accelerometerData.acceleration
                        
                        //低通滤波
                        let lowPassFilteredX = (acceleration.x * FILTER_FACTOR) +
                            (self.filteredAccelX * (1.0 - FILTER_FACTOR))
                        let lowPassFilteredY = (acceleration.y * FILTER_FACTOR) +
                            (self.filteredAccelY * (1.0 - FILTER_FACTOR))
                        let lowPassFilteredZ = (acceleration.z * FILTER_FACTOR) +
                            (self.filteredAccelZ * (1.0 - FILTER_FACTOR))
                        
                        //高通滤波
                        let highPassFilteredX = acceleration.x - lowPassFilteredX
                        let highPassFilteredY = acceleration.y - lowPassFilteredY
                        let highPassFilteredZ = acceleration.z - lowPassFilteredZ
                        
                        if let filterType = FilterTypes(rawValue: self.filterControl.selectedSegmentIndex) {
                            switch filterType {
                            case .NONE:
                                self.filteredAccelX = acceleration.x
                                self.filteredAccelY = acceleration.y
                                self.filteredAccelZ = acceleration.z
                            case .LOW_PASS_FILTER:
                                self.filteredAccelX = lowPassFilteredX
                                self.filteredAccelY = lowPassFilteredY
                                self.filteredAccelZ = lowPassFilteredZ
                            case .HIGH_PASS_FILTER:
                                self.filteredAccelX = highPassFilteredX
                                self.filteredAccelY = highPassFilteredY
                                self.filteredAccelZ = highPassFilteredZ
                            }
                        }
                        
                        NSLog("x = %f", self.filteredAccelX)
                        self.xLabel.text = String(format: "%f", self.filteredAccelX)
                        self.xBar.progress = abs(Float(self.filteredAccelX))
                        
                        NSLog("y = %f", self.filteredAccelY)
                        self.yLabel.text = String(format: "%f", self.filteredAccelY)
                        self.yBar.progress = abs(Float(self.filteredAccelY))
                        
                        NSLog("z = %f", self.filteredAccelZ)
                        self.zLabel.text = String(format: "%f", self.filteredAccelZ)
                        self.zBar.progress = abs(Float(self.filteredAccelZ))
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

