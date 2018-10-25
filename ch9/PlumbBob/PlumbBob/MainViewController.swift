//
//  MainViewController.swift
//  PlumbBob
//
//  Created by 关东升 on 15/2/8.
//  本书网站：http://www.51work6.com
//  智捷课堂在线课堂：http://www.zhijieketang.com/
//  智捷课堂微信公共号：zhijieketang
//  作者微博：@tony_关东升
//  QQ：569418560 邮箱：eorient@sina.com
//  QQ交流群：162030268
//

import UIKit
import CoreMotion
import AVFoundation

let kAccelerometerFrequency = 40.0

class MainViewController: UIViewController {

    var motionManager : CMMotionManager!
    
    var plumbBobView : UIImageView!
    
    @IBOutlet weak var btnInfo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetMedium
        let captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)

        if (screenHeight > 480) {
            //iPhone 5设备
            captureVideoPreviewLayer.frame = CGRectMake(0,0,320,500)
        } else {
            captureVideoPreviewLayer.frame = CGRectMake(0,0,320,450)
        }
        
        let camScaleup : CGFloat = 1.5
        captureVideoPreviewLayer.setAffineTransform(CGAffineTransformMakeScale(camScaleup, camScaleup))
        self.view.layer.insertSublayer(captureVideoPreviewLayer, below: self.btnInfo.layer)
        
        let device =  AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error : NSError? = nil
        let input : AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(device, error:&error)
        
        if (input != nil && error == nil) {
            session.addInput(input as! AVCaptureInput)
            
            let stillImageOutput = AVCaptureStillImageOutput()
            let outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            stillImageOutput.outputSettings = outputSettings
            session.addOutput(stillImageOutput)
            session.startRunning()
        }
        
        // 设置PlumBob视图
        let image = UIImage(named: "PlumbBob.png")
        self.plumbBobView = UIImageView(image: image)
        self.plumbBobView.layer.anchorPoint = CGPointMake(0.5, 0.0)
    
        
        if screenHeight > 480 {
            //iPhone 5设备
            self.plumbBobView.frame = CGRectMake(self.view.frame.size.width / 2 - 20, 0, 40, 500)
        } else {
        	self.plumbBobView.frame = CGRectMake(self.view.frame.size.width / 2 - 20, 0, 40, 450)
        }
        self.view.addSubview(self.plumbBobView)
        
        
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = 1.0 / kAccelerometerFrequency
        
        if self.motionManager.accelerometerAvailable {
            
            self.motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (accelerometerData, error) -> Void in
                if error != nil {
                    self.motionManager.stopAccelerometerUpdates()
                } else {
                    self.rotatePlumbStringToDegree(-accelerometerData.acceleration.x * 30.0)
                }
            })

        } else {
            NSLog("加速度计不可用")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func rotatePlumbStringToDegree(positionInDegrees : Double) {
        self.plumbBobView.layer.removeAllAnimations()
        var rotationTransform : CATransform3D = CATransform3DIdentity
        rotationTransform = CATransform3DRotate(rotationTransform, degreesToRadians(positionInDegrees), 0.0, 0.0, 1.0)
        self.plumbBobView.layer.transform = rotationTransform
    }

    //把度转换为弧度
    func degreesToRadians(degrees : Double) -> CGFloat {
        return CGFloat(degrees * M_PI / 180.0)
    }
}

