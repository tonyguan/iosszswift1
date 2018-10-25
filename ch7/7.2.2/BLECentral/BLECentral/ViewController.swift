//
//  ViewController.swift
//  BLECentral
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

let TRANSFER_SERVICE_UUID           = "D63D44E5-E798-4EA5-A1C0-3F9EEEC2CDEB"
let TRANSFER_CHARACTERISTIC_UUID    = "1652CAD2-6B0D-4D34-96A0-75058E606A98"

class ViewController: UIViewController,CBCentralManagerDelegate, CBPeripheralDelegate {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var scanLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    var centralManager : CBCentralManager!
    var discoveredPeripheral : CBPeripheral!
    var data : NSMutableData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置CBCentralManager
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // 保存接收数据
        self.data = NSMutableData()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.centralManager.stopScan()
        self.activityIndicatorView.stopAnimating()
        NSLog("扫描停止")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** 通过制定的128位的UUID，扫描外设
    */
    func scan() {
        
        let uuids = [CBUUID(string: TRANSFER_SERVICE_UUID)]
        let opt = [CBCentralManagerScanOptionAllowDuplicatesKey : true]
        self.centralManager.scanForPeripheralsWithServices(uuids, options: opt)
        
        self.activityIndicatorView.startAnimating()
        self.scanLabel.hidden = false
    }
    
    /** 停止扫描
    */
    func stop() {
        self.centralManager.stopScan()
        self.activityIndicatorView.stopAnimating()
        self.scanLabel.hidden = true
        self.textView.text = ""
        NSLog("扫描停止")
    }
    
    
    //MARK： --实现CBCentralManagerDelegate委托协议
    
    //设置CBCentralManager
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        if central.state != .PoweredOn {
            return
        }
        //开始扫描
        self.scan()
    }
    
    //发现外设
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        //过滤信号强度范围
        if RSSI.integerValue > -15 || RSSI.integerValue < -35 {
            return
        }
        
        if self.discoveredPeripheral != peripheral {
            self.discoveredPeripheral = peripheral
            
            NSLog("连接外设 %@", peripheral)
            self.centralManager.connectPeripheral(peripheral, options: nil)
        }
    }
    
    //连接外设成功
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        NSLog("外设已连接")
        self.stop()
        NSLog("扫描停止")
        self.data.length  = 0
        
        peripheral.delegate = self
        
        let uuids = [CBUUID(string: TRANSFER_SERVICE_UUID)]
        peripheral.discoverServices(uuids)
    }
    
    //连接外设失败
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        NSLog("连接失败 %@. (%@)", peripheral, error.localizedDescription)
        self.cleanup()
    }
    
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        NSLog("外设已经断开")
        
        self.discoveredPeripheral = nil
        //外设已经断开情况下,重新扫描。
        self.scan()
    }
    
    
    
    //MARK： --实现CBPeripheralDelegate委托协议
    
    /** 服务被发现
    */
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        if error != nil {
            NSLog("服务被发现失败 %@.", error.localizedDescription)
            self.cleanup()
            return
        }
        
        //发现特征
        for item in peripheral.services {
            let service = item as! CBService
            let uuids = [CBUUID(string: TRANSFER_CHARACTERISTIC_UUID)]
            peripheral.discoverCharacteristics(uuids, forService: service)
        }
    }
    
    /** 特征被发现
    */
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        if error != nil {
            NSLog("发现特征错误 %@.", error.localizedDescription)
            self.cleanup()
            return
        }
        
        //发现特征
        for item in service.characteristics {
            let characteristic = item as! CBCharacteristic
            if characteristic.UUID.UUIDString == TRANSFER_CHARACTERISTIC_UUID {
                //预定特征通知
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
            }
        }
    }
    
    /** 读取数据
    */
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        if error != nil {
            NSLog("读取数据错误 %@.", error.localizedDescription)
            return
        }
        
        let stringFromData = NSString(data: characteristic.value, encoding: NSUTF8StringEncoding)
        
        //判断是否为数据结束
        if stringFromData == "EOM" {
            //显示数据
            self.textView.text = NSString(data: self.data, encoding: NSUTF8StringEncoding) as! String
            // 取消特征预定
            peripheral.setNotifyValue(false, forCharacteristic: characteristic)
            //断开外设
            self.centralManager.cancelPeripheralConnection(peripheral)
        }
        // 接收数据追加到data属性中
        self.data.appendData(characteristic.value)
    }
    
    //特征通知状态变化
    func peripheral(peripheral: CBPeripheral!, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if error != nil {
            NSLog("特征通知状态变化错误 %@.", error.localizedDescription)
            return
        }
        
        // 如果没有特征传输过来则退出
        if characteristic.UUID.UUIDString != TRANSFER_CHARACTERISTIC_UUID {
            return
        }
        
        
        if characteristic.isNotifying {// 特征通知已经开始
            NSLog("特征通知已经开始 %@", characteristic)
        } else {// 特征通知已经停止
            NSLog("特征通知已经停止 %@", characteristic)
            self.centralManager.cancelPeripheralConnection(peripheral)
        }
        
    }
    
    /** 清除方法
    */
    func cleanup() {
        
        // 如果没有连接则退出
        if self.discoveredPeripheral.state != .Connected {
            return
        }
        
        // 判断是否已经预定了特征
        if self.discoveredPeripheral.services != nil {
            for item1 in self.discoveredPeripheral.services {
                let service = item1 as! CBService
                if service.characteristics != nil {
                    for item2 in service.characteristics {
                        let characteristic = item2  as! CBCharacteristic
                        if  characteristic.UUID.UUIDString == TRANSFER_CHARACTERISTIC_UUID {
                            if characteristic.isNotifying {
                                //停止接收特征通知
                                self.discoveredPeripheral.setNotifyValue(false, forCharacteristic: characteristic)
                                //断开与外设连接
                                self.centralManager.cancelPeripheralConnection(self.discoveredPeripheral)
                                return
                            }
                        }
                    }
                }
            }
        }
        
        //断开与外设连接
        self.centralManager.cancelPeripheralConnection(self.discoveredPeripheral)
    }
}

