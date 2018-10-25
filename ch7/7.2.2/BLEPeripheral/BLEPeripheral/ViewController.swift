//
//  ViewController.swift
//  BLEPeripheral
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

let TRANSFER_SERVICE_UUID = "D63D44E5-E798-4EA5-A1C0-3F9EEEC2CDEB"
let TRANSFER_CHARACTERISTIC_UUID = "1652CAD2-6B0D-4D34-96A0-75058E606A98"
let NOTIFY_MTU = 20

class ViewController: UIViewController,CBPeripheralManagerDelegate {

    @IBOutlet weak var textView: UITextView!
    
    var  peripheralManager : CBPeripheralManager!
    var transferCharacteristic : CBMutableCharacteristic!
    var dataToSend : NSData!
    var sendDataIndex = -1
    
    //发送数据结束标识
    var sendingEOM = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置CBPeripheralManager
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.peripheralManager.stopAdvertising()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func valueChanged(sender: AnyObject) {
        
        let advertisingSwitch = sender as! UISwitch
        
        if advertisingSwitch.on {
            // 开始广播
            let uuids = [CBUUID(string: TRANSFER_SERVICE_UUID)]
            let data = [CBAdvertisementDataServiceUUIDsKey : uuids]
            self.peripheralManager.startAdvertising(data)
        } else {
            self.peripheralManager.stopAdvertising()
        }

    }
    
    //MARK: --实现CBPeripheralManagerDelegate委托协议
    
    //设置CBPeripheralManager
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if peripheral.state != .PoweredOn {
            return
        }
        NSLog("BLE打开")
        // 初始化特征
        let uuidChar = CBUUID(string: TRANSFER_CHARACTERISTIC_UUID)
        self.transferCharacteristic = CBMutableCharacteristic(type: uuidChar, properties: .Notify, value: nil, permissions: .Readable)
        
        // 初始化服务
        let uuidService = CBUUID(string: TRANSFER_SERVICE_UUID)
        let transferService = CBMutableService(type: uuidService, primary: true)
        
        // 添加特征到服务
        transferService.characteristics = [self.transferCharacteristic]
        //发布服务与特征
        self.peripheralManager.addService(transferService)
        
    }
    
    //添加服务
    func peripheralManager(peripheral: CBPeripheralManager!, didAddService service: CBService!, error: NSError!) {
        NSLog("添加服务" )
        
        if error != nil {
            NSLog("添加服务失败: %@", error.localizedDescription)
        }
    }
    
    //发送数据
    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didSubscribeToCharacteristic characteristic: CBCharacteristic!) {
        NSLog("中心已经预定了特征")
        self.dataToSend = self.textView.text.dataUsingEncoding(NSUTF8StringEncoding)
        self.sendDataIndex = 0
        self.sendData()
    }

    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic!) {
        NSLog("中心没有从特征预定")
    }
    
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager!) {
        self.sendData()
    }
    
    //发送数据
    func sendData() {

        
        if sendingEOM {
            let didSend = self.peripheralManager.updateValue("EOM".dataUsingEncoding(NSUTF8StringEncoding), forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil)
            if didSend {
                sendingEOM = false
                NSLog("Sent: EOM")
            }
            return
        }
        
        if self.sendDataIndex >= self.dataToSend.length {
            return
        }
        
        
        var didSend = true
        
        while didSend {
            
            var amountToSend = self.dataToSend.length - self.sendDataIndex
            
            if amountToSend > NOTIFY_MTU {
                amountToSend = NOTIFY_MTU
            }
            
            let chunk = NSData(bytes: self.dataToSend.bytes + self.sendDataIndex,
                length : amountToSend)
            
            //发送数据
            didSend = self.peripheralManager.updateValue(chunk, forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil)
            
            if !didSend {
                return
            }
            
            if let stringFromData = NSString(data: chunk, encoding: NSUTF8StringEncoding) {
                NSLog("Sent: %@", stringFromData)
            }
            
            self.sendDataIndex += amountToSend
            
            if self.sendDataIndex >= self.dataToSend.length {
                
                sendingEOM = true
                
                let eomSent = self.peripheralManager.updateValue("EOM".dataUsingEncoding(NSUTF8StringEncoding), forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil)
                
                if eomSent {
                    sendingEOM = false
                    NSLog("Sent: EOM")
                }
                return
            }
        }
    }
}

