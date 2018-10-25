//
//  ViewController.swift
//  TapGestureRecognizer
//
//  Created by 关东升 on 15/2/4.
//  本书网站：http://www.51work6.com
//  智捷课堂在线课堂：http://www.zhijieketang.com/
//  智捷课堂微信公共号：zhijieketang
//  作者微博：@tony_关东升
//  QQ：569418560 邮箱：eorient@sina.com
//  QQ交流群：162030268
//

import UIKit

class ViewController: UIViewController {
 
    var boolTrashEmptyFlag = false //垃圾桶空标志 false 桶满,true 桶空
    
    var imageTrashFull : UIImage!
    var imageTrashEmpty : UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = NSBundle.mainBundle()
        let imageTrashFullPath = bundle.pathForResource("Blend Trash Full", ofType: "png")
        let imageTrashEmptyPath = bundle.pathForResource("Blend Trash Empty", ofType: "png")
        
        self.imageTrashFull = UIImage(contentsOfFile: imageTrashFullPath!)
        
        self.imageTrashEmpty = UIImage(contentsOfFile: imageTrashEmptyPath!)
        
        self.imageView.image = self.imageTrashFull
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "foundTap:")
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        self.imageView.addGestureRecognizer(tapRecognizer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func foundTap(paramSender : UITapGestureRecognizer) {
        NSLog("tap")
        if boolTrashEmptyFlag {
            self.imageView.image = self.imageTrashFull
            boolTrashEmptyFlag = false
        } else {
            self.imageView.image = self.imageTrashEmpty
            boolTrashEmptyFlag = true
        }
    }


}

