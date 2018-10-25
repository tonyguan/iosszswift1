//
//  ViewController.swift
//  MusicPlayer
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

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var player : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filePath = NSBundle.mainBundle().pathForResource("test", ofType: "caf")
        let fileURL = NSURL(fileURLWithPath: filePath!)
        
        var error : NSError? = nil
        self.player = AVAudioPlayer(contentsOfURL: fileURL, error: &error)
        self.player.delegate = self
        
        if error != nil {
            NSLog("%@",error!.description)
        } else {
            self.player.prepareToPlay()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSound(sender: AnyObject) {
        
        if self.player != nil {
            self.player.play()
        }
        
    }
    
    @IBAction func pauseSound(sender: AnyObject) {
        
        if self.player != nil {
            self.player.pause()
        }
    }
    
    @IBAction func stopSound(sender: AnyObject) {
        
        if self.player != nil {
            self.player.stop()
            self.player.currentTime = 0
        }
        
    }
    
    // MARK: --实现AVAudioPlayerDelegate协议方法
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        NSLog("播放完成。")
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        NSLog("播放错误发生: %@", error.localizedDescription)
    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer!, withOptions flags: Int) {
        NSLog("中断返回。")
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer!) {
        NSLog("播放中断。");
    }
    
}

