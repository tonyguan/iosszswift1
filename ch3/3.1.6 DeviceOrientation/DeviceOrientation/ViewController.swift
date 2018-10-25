//
//  ViewController.swift
//  DeviceOrientation
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

class ViewController: UIViewController {

    @IBOutlet weak var orientationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedRotation:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
    }
    
    func receivedRotation(notification : NSNotification) {
        let device = UIDevice.currentDevice()
        
        switch device.orientation {
        case .Portrait:
            self.orientationLabel.text = "竖直向上"
        case .PortraitUpsideDown:
            self.orientationLabel.text = "竖直向下"
        case .LandscapeLeft:
            self.orientationLabel.text = "水平向左"
        case .LandscapeRight:
            self.orientationLabel.text = "水平向右"
        case .FaceUp:
            self.orientationLabel.text = "面朝上"
        case .FaceDown:
            self.orientationLabel.text = "面朝下"
        case .Unknown:
            self.orientationLabel.text = "未知"
        }
    }
}

