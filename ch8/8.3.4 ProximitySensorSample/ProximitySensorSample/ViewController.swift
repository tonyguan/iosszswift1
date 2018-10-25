//
//  ViewController.swift
//  ProximitySensorSample
//
//  Created by 关东升 on 15/2/9.
//  本书网站：http://www.51work6.com
//  智捷课堂在线课堂：http://www.zhijieketang.com/
//  智捷课堂微信公共号：zhijieketang
//  作者微博：@tony_关东升
//  QQ：569418560 邮箱：eorient@sina.com
//  QQ交流群：162030268
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imageTrashFull : UIImage!
    var imageTrashEmpty : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let bundle = NSBundle.mainBundle()
        let imageTrashFullPath = bundle.pathForResource("Blend Trash Full", ofType: "png")
        let imageTrashEmptyPath = bundle.pathForResource("Blend Trash Empty", ofType: "png")
        
        self.imageTrashFull = UIImage(contentsOfFile: imageTrashFullPath!)
        
        self.imageTrashEmpty = UIImage(contentsOfFile: imageTrashEmptyPath!)
        
        self.imageView.image = self.imageTrashFull
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let device = UIDevice.currentDevice()
        //开启接近传感器
        device.proximityMonitoringEnabled = true
        
        //设置通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "proximityDidChange:",
            name: UIDeviceProximityStateDidChangeNotification,
            object: device)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let device = UIDevice.currentDevice()
        
        //注销通知
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceProximityStateDidChangeNotification, object: device)
        
        device.proximityMonitoringEnabled = false
    
    }
    
    func proximityDidChange( notification : NSNotification) {
        if UIDevice.currentDevice().proximityState == true {
            NSLog("用户接近")
            self.imageView.image = self.imageTrashEmpty
        } else {
            NSLog("用户离开")
            self.imageView.image = self.imageTrashFull
        }
    }
}

