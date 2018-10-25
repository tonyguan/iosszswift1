//
//  ViewController.swift
//  Compass
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
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager!
    
    @IBOutlet weak var plateImage: UIImageView!
    
    //地磁北方向
    @IBOutlet weak var magneticHeadingLabel: UILabel!
    //地理北方向
    @IBOutlet weak var trueHeadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        if CLLocationManager.headingAvailable() {
            self.locationManager.startUpdatingHeading()
        } else {
            NSLog("不能获得航向数据。")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.locationManager.stopUpdatingHeading()
        self.locationManager.delegate = nil
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        
        let device = UIDevice.currentDevice()
        
        if newHeading.headingAccuracy > 0 {
            
            let magneticHeading = self.heading(newHeading.magneticHeading, fromOrientation: device.orientation)
            let trueHeading = self.heading(newHeading.trueHeading, fromOrientation: device.orientation)
            
            self.magneticHeadingLabel.text = String(format: "%.2f", magneticHeading)
            self.trueHeadingLabel.text = String(format: "%.2f", trueHeading)
            
            let heading = -1.0 * M_PI * newHeading.magneticHeading / 180.0
            
            self.plateImage.transform = CGAffineTransformMakeRotation(CGFloat(heading))
        }
    }
    
    func locationManagerShouldDisplayHeadingCalibration(manager: CLLocationManager!) -> Bool {
        return true
    }
    
    func heading(heading : Double,fromOrientation orientation : UIDeviceOrientation) -> Double {
        var realHeading = heading
        
        switch orientation {
        case .Portrait:
            NSLog("Portrait")
        case .PortraitUpsideDown:
            NSLog("PortraitUpsideDown")
            realHeading -= 180
        case .LandscapeLeft:
            NSLog("LandscapeLeft")
            realHeading += 90.0
        case .LandscapeRight:
            NSLog("LandscapeRight")
            realHeading -= 90.0
        default:
            NSLog("default")
        }
        
        if realHeading > 360.0 {
            realHeading -= 360
        } else if realHeading < 0.0 {
            realHeading += 360
        }
        
        return realHeading
    }
    
}

