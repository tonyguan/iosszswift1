//
//  ViewController.swift
//  AudioRecorder
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
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var label: UILabel!
    
    var recorder : AVAudioRecorder!
    var player : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func documentsDirectory() -> String {
        let  paths: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0] as! String
    }
    
    @IBAction func record(sender: AnyObject) {
        let filePath = String(format: "%@/rec_audio.caf", self.documentsDirectory())
        let fileUrl = NSURL(fileURLWithPath: filePath)
        
        var error : NSError? = nil
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord, error: &error)
        AVAudioSession.sharedInstance().setActive(true, error: &error)
        
        var settings = [String : Int]()
        settings[AVFormatIDKey] = kAudioFormatLinearPCM
        settings[AVSampleRateKey] = 44100
        settings[AVNumberOfChannelsKey] = 1
        settings[AVLinearPCMBitDepthKey] = 16
        settings[AVLinearPCMIsBigEndianKey] = 0//false
        settings[AVLinearPCMIsFloatKey] = 0//false
        
        self.recorder = AVAudioRecorder(URL: fileUrl, settings: settings, error: &error)
        
        self.recorder.delegate = self
        
        self.recorder.record()
        self.label.text = "录制中..."
    }
    
    @IBAction func stop(sender: AnyObject) {
        
        self.label.text = "停止..."
        
        if self.recorder != nil && self.recorder.recording {
            self.recorder.stop()
            self.recorder.delegate = self
            self.recorder = nil
        }
        
    }
    
    @IBAction func play(sender: AnyObject) {
        
        if self.recorder != nil && self.recorder.recording {
            self.recorder.stop()
        }

        let filePath = String(format: "%@/rec_audio.caf", self.documentsDirectory())
        let fileUrl = NSURL(fileURLWithPath: filePath)
        
        var error : NSError? = nil
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: &error)
        AVAudioSession.sharedInstance().setActive(true, error : &error)
        self.player = AVAudioPlayer(contentsOfURL: fileUrl, error: &error)
        
        if error != nil {
            NSLog("%@", error!.description)
        } else {
            self.player.play()
            self.label.text = "播放..."
        }
    }
    
}

