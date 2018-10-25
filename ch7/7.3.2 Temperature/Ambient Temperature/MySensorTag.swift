//
//  MySensorTag.swift
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

class MySensorTag: NSObject,CBCentralManagerDelegate,CBPeripheralDelegate {
    
    var d : BLEDevice!
    var sensorsEnabled = NSMutableArray()
    
    //温度
    dynamic var tempValue : Float = 0.0
    
    init(Device device : BLEDevice) {
        super.init()
        
        self.d = device
        self.d.manager.delegate = self
        self.d.manager.connectPeripheral(self.d.p, options: nil)
        self.d.p.delegate = self
        
        self.configureSensorTag()
    }
    
    func configureSensorTag() {
        
        if self.sensorsEnabled("Ambient temperature active") || self.sensorsEnabled("IR temperature active") {
            
            // Enable Temperature sensor
            let suuid = self.d.setupData.valueForKey("IR temperature service UUID") as! String
            let sUUID = CBUUID(string: suuid)
            
            let cuuid = self.d.setupData.valueForKey("IR temperature config UUID") as! String
            let cUUID = CBUUID(string: cuuid)
            
            var buffer:[UInt8] = [0x01]
            let data = NSData(bytes: buffer, length: buffer.count)
            BLEUtility.writeCharacteristic(self.d.p, sCBUUID: sUUID, cCBUUID: cUUID, data: data)
            
            let cuuid2 = self.d.setupData.valueForKey("IR temperature data UUID") as! String
            let cUUID2 = CBUUID(string: cuuid2)
            BLEUtility.setNotificationForCharacteristic(self.d.p, sCBUUID: sUUID, cCBUUID: cUUID2, enable: true)
            
            if self.sensorsEnabled("Ambient temperature active") {
                self.sensorsEnabled.addObject("Ambient temperature")
            }
            if self.sensorsEnabled("IR temperature active") {
                self.sensorsEnabled.addObject("IR temperature")
            }
            
        }
    }
    
    func sensorsEnabled(Sensor : String) -> Bool {
        
        if let val = self.d.setupData.valueForKey(Sensor) as? String {
            if val == "1" {
                return true
            }
        }
        return false
    }
    
    // MARK: - CBCentralManager delegate function
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        NSLog("centralManagerDidUpdateState")
    }
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    // MARK: -  CBperipheral delegate functions
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        self.configureSensorTag()
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        for item in peripheral.services {
            let s = item as! CBService
            peripheral.discoverCharacteristics(nil, forService: s)
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        let cuuid = self.d.setupData.valueForKey("IR temperature data UUID") as! String
        if characteristic.UUID.UUIDString == cuuid {
            let tAmb = sensorTMP006.calcTAmb(characteristic.value)
            NSLog("温度 ： %.1f°C", tAmb)
            self.tempValue = Float(tAmb)
        }
        
        let rHVal : Float = sensorSHT21.calcPress(characteristic.value)        
    }
}
