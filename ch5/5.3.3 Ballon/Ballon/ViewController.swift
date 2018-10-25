//
//  ViewController.swift
//  Ballon
//
//  Created by 关东升 on 15/2/7.
//  本书网站：http://www.51work6.com
//  智捷课堂在线课堂：http://www.zhijieketang.com/
//  智捷课堂微信公共号：zhijieketang
//  作者微博：@tony_关东升
//  QQ：569418560 邮箱：eorient@sina.com
//  QQ交流群：162030268
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetMedium
        
        let captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        captureVideoPreviewLayer.frame = CGRectMake(0,0,320,568)
        
        let camScaleup : CGFloat = 1.8
        captureVideoPreviewLayer.setAffineTransform(CGAffineTransformMakeScale(camScaleup, camScaleup))
        self.view.layer.addSublayer(captureVideoPreviewLayer)
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var err : NSError? = nil
        let input : AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &err)
        
        if (input != nil && err == nil) {
            session.addInput(input as! AVCaptureInput)
            
            let stillImageOutput = AVCaptureStillImageOutput()
            let outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            stillImageOutput.outputSettings = outputSettings
            session.addOutput(stillImageOutput)
            session.startRunning()
        }
        
        // 创建执行动画的Image View对象
        let imageView = UIImageView(frame: self.view.frame)
        
        var array1 = [AnyObject]()
        var array2 = [AnyObject]()
        
        for var i = 10; i <= 40; i++ {
            let fileName1 = String(format: "100%i.png", i)
            let img1 = UIImage(named: fileName1)
            array1.append(img1!)
            
            let fileName2 = String(format: "100%i.png", (50-i))
            let img2 = UIImage(named: fileName2)
            array2.append(img2!)
        }
        
        array1 += array2
        
        imageView.animationImages = array1
        imageView.animationDuration = 1.75
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
        
        self.view.addSubview(imageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

