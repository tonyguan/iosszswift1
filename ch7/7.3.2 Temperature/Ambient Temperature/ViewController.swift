//
//  ViewController.swift
//  Ambient Temperature
//
//  Created by 关东升 on 15/2/10.
//  本书网站：http://www.51work6.com
//  智捷课堂在线课堂：http://www.zhijieketang.com/
//  智捷课堂微信公共号：zhijieketang
//  作者微博：@tony_关东升
//  QQ：569418560 邮箱：eorient@sina.com
//  QQ交流群：162030268
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var lblTemp: UILabel!
    
    var m : CBCentralManager!
    var peripheral : CBPeripheral!
    var sensorTags = NSMutableArray()
    var tag : MySensorTag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.m = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showTemp(sender: AnyObject) {
        
        let p = self.sensorTags.lastObject as! CBPeripheral
        
        let d = BLEDevice()
        d.p = p
        d.manager = self.m
        d.setupData = self.makeSensorTagConfiguration()
        
        self.tag = MySensorTag(Device: d)
        //注册self为观察者，观察MySensorTag的tempValue属性的变化
        self.tag.addObserver(self, forKeyPath: "tempValue", options: .New, context: nil)
        
        self.btnShow.enabled = false
    }
    
    // MARK: - 观察MySensorTag中温度变化
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject,
        change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
            
            let valueObj = change[NSKeyValueChangeNewKey] as! NSNumber
            let value  = valueObj.floatValue
            let s = String(format: "环境温度：   %.1f°C", value)
            self.lblTemp.text = s
            
    }
    
    
    func makeSensorTagConfiguration() -> NSMutableDictionary {
        var d = NSMutableDictionary()
        d.setValue("1", forKey: "Ambient temperature active")
        d.setValue("1", forKey: "IR temperature active")
        d.setValue("F000AA00-0451-4000-B000-000000000000", forKey: "IR temperature service UUID")
        d.setValue("F000AA01-0451-4000-B000-000000000000", forKey: "IR temperature data UUID")
        d.setValue("F000AA02-0451-4000-B000-000000000000", forKey: "IR temperature config UUID")
        
        return d
    }
    
    // MARK: - CBCentralManager delegate
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        if central.state != .PoweredOn {
            let state = String(format: "CoreBluetooth return state: %d",central.state.rawValue)
            let alertView = UIAlertView(title: "BLE not supported !",
                message: state,
                delegate: nil,
                cancelButtonTitle: "OK")
            alertView.show()
        } else {
            central.scanForPeripheralsWithServices(nil, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        NSLog("Found a BLE Device : %@",peripheral)
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        central.connectPeripheral(peripheral, options: nil)
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        peripheral.discoverServices(nil)
    }
    
    // MARK: --CBPeripheral delegate
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        
        NSLog("Services scanned !")
        self.m.cancelPeripheralConnection(peripheral)
        
        for item in peripheral.services {
            let s = item as! CBService
            NSLog("Service found : %@",s.UUID)
            if s.UUID.UUIDString == "F000AA00-0451-4000-B000-000000000000" {
                NSLog("This is a SensorTag !")
                self.btnShow.enabled = true
                if !self.sensorTags.containsObject(peripheral) {
                    self.sensorTags.addObject(peripheral)
                }
            }
        }
    }

}

