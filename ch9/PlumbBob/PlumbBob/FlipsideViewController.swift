//
//  FlipsideViewController.swift
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

class FlipsideViewController: UIViewController {

    var imageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        if screenHeight > 480 {
            //iPhone 5设备
            let img = UIImage(named: "about-bg-iphone5.png")
            self.imageView = UIImageView(image: img)
            self.imageView.frame = CGRectMake(0,44,320,524)
        } else {
            let img = UIImage(named: "about-bg.png")
            self.imageView = UIImageView(image: img)
            self.imageView.frame = CGRectMake(0,44,320,436)
        }
        self.view.addSubview(self.imageView)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
