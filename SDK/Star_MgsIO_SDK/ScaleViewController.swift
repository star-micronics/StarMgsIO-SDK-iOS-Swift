//
//  ScaleViewController.swift
//  StarMgsIO_SDK_iOS_Swift
//
//  Created by Star Micronics on 2023/07/24.
//

import UIKit

class ScaleViewController: UIViewController,STARScaleDelegate{
    var scale:STARScale?
    var scaleData:STARScaleData?
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dataTypeLabel: UILabel!
    @IBOutlet weak var comparatorResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(scale != nil){
            statusLabel.text="Status: Connecting"
        }else{
            self.dismiss(animated:true,completion:nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }

    func scale(_ scale: STARScale!, didRead scaleData: STARScaleData!, error: Error!) {
        if(error != nil){
            return;
        }
        let weight = scaleData.weight
        let unit:String = unitDict[scaleData.unit] ?? "-"
        let weightText = String(weight)+"["+unit+"]"
        weightLabel.text = weightText
        
        let status:String = statusDict[scaleData.status] ?? "-"
        statusLabel.text = "Status: "+status
        
        let dataType:String = dataTypeDict[scaleData.dataType] ?? "-"
        dataTypeLabel.text = "DataType: "+dataType
        
        if(scale.scaleType == STARScaleType_ENUM.MGS){
            let comparatorResult:String = comparatorResultDict[scaleData.comparatorResult] ?? "-"
            comparatorResultLabel.text = "ComparatorResult: " + comparatorResult
        }else{
            comparatorResultLabel.text = ""
        }
        
    }
    
    @IBOutlet weak var zeroPointButton: UIButton!
    
    @IBAction func zeroPointButtonPushed(_ sender: UIButton) {
        zeroPointButton.isEnabled = false
        scale!.update(STARScaleSetting.zeroPointAdjustment)
    }
    
    func scale(_ scale: STARScale!, didUpdate setting: STARScaleSetting, error: Error!) {
        if(error != nil){
            let alert = UIAlertController(title:"Failed",message:error!.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title:"OK",style:.default)
            alert.addAction(action)
            present(alert,animated:true)
        }else{
            NSLog("Success", "\(self)::\(#function)")
        }
        zeroPointButton.isEnabled = true
    }
    
    @IBAction func backButtonPushed(_ sender: UIButton) {
        if(scale != nil){
            STARDeviceManager.shared().disconnectScale(scale!)
        }
        self.dismiss(animated: true, completion: nil)
        
    }

    
    var unitDict:Dictionary<STARUnit , String> = [
        STARUnit.invalid: "Invalid",
        STARUnit.MG: "mg",
        STARUnit.G: "g",
        STARUnit.KG: "kg",
        STARUnit.CT: "ct",
        STARUnit.MOM: "mom",
        STARUnit.OZ: "oz",
        STARUnit.LB: "lb",
        STARUnit.OZT: "ozt",
        STARUnit.DWT: "dwt",
        STARUnit.GN: "gr",
        STARUnit.TLH: "tl",
        STARUnit.TLS: "tl",
        STARUnit.TLT: "tl",
        STARUnit.TO: "tola",
        STARUnit.MSG: "msg",
        STARUnit.BAT: "bht",
        STARUnit.PCS: "PCS",
        STARUnit.percent: "%",
        STARUnit.coefficient: "MUL",
    ]
    
    let comparatorResultDict:Dictionary<STARComparatorResult,String> = [
        STARComparatorResult.invalid: "Invalid",
        STARComparatorResult.shortage: "Shortage",
        STARComparatorResult.proper: "OK",
        STARComparatorResult.over: "Over",
    ]
    
    let dataTypeDict:Dictionary<STARDataType,String> = [
        STARDataType.invalid: "Invalid",
        STARDataType.netNotTared: "NetNotTared",
        STARDataType.net: "Net",
        STARDataType.tare: "Tare",
        STARDataType.presetTare: "PresetTare",
        STARDataType.total: "Total",
        STARDataType.unit: "Unit",
        STARDataType.gross: "Gross",
        
    ]
    
    let statusDict:Dictionary<STARStatus , String> = [
        STARStatus.invalid:"Invalid",
        STARStatus.stable:"Stable",
        STARStatus.unstable:"Unstable",
        STARStatus.error:"Error",
    ]
    
}
