//
//  TableViewController.swift
//  StarMgsIO_SDK_iOS_Swift
//
//  Created by Star Micronics on 2023/07/24.
//

import UIKit
import CoreBluetooth


class ScanViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate,CBCentralManagerDelegate, STARDeviceManagerDelegate{
    var contents:Array<STARScale> = []
    var centralManager:CBCentralManager!
    
    @IBOutlet weak var scanTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        STARDeviceManager.shared().delegate = self;
        
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        centralManager = CBCentralManager(delegate: self, queue: queue, options: [CBCentralManagerOptionShowPowerAlertKey : true])
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        contents=[]
        scanTableView.reloadData()
        if (centralManager.state == CBManagerState.poweredOn) {
            STARDeviceManager.shared().scanForScales()
        }
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            STARDeviceManager.shared().scanForScales()
            return
            
        default:
            STARDeviceManager.shared().stopScan()
            contents.removeAll()
            DispatchQueue.main.async {
                self.scanTableView.reloadData()
            }
        }
    }
        
    func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView:UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let name = contents[indexPath.row].name ?? ""
        let identifier = contents[indexPath.row].identifier ?? ""
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoveredScaleCell",for: indexPath)as! DiscoveredScaleCell
        cell.create(title:name,subtitle:identifier)
        return cell
    }
    
    var selectedScale:STARScale!
    var connectedScale:STARScale!
    var scaleView:ScaleViewController?
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        selectedScale=contents[indexPath.row]
        STARDeviceManager.shared().connect(selectedScale)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConnectScale" {
            scaleView = segue.destination as? ScaleViewController
            scaleView?.scale=connectedScale
            scaleView?.scale?.delegate = scaleView
        }
    }

  func openScaleView(){
        STARDeviceManager.shared().stopScan()
        performSegue(withIdentifier: "ConnectScale", sender: nil)
    }
    

    func manager(_ manager: STARDeviceManager, didDiscover scale: STARScale?, error: Error?) {
        if(error != nil){
            let alert = UIAlertController(title:"Failed",message:error!.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title:"OK",style:.default)
            alert.addAction(action)
            present(alert,animated:true)
            return;
        }
        
        if(scale != nil){
            contents.append(scale!)
            DispatchQueue.main.async {
                self.scanTableView.reloadData()
            }
        }
    }

    func manager(_ manager: STARDeviceManager, didConnect scale: STARScale?, error: Error?) {
        if(error != nil){
            if(scaleView != nil){
                scaleView?.dismiss(animated:true,completion:nil)
            }
            let alert = UIAlertController(title:"Failed to Connect",message:error!.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title:"OK",style:.default)
            alert.addAction(action)
            present(alert,animated:true)
            NSLog(error!.localizedDescription)
            return;
        }
        connectedScale = scale
        openScaleView()
    }
    

    func manager(_ manager: STARDeviceManager, didDisconnectScale scale: STARScale?, error: Error?) {
        scaleView?.dismiss(animated:true,completion:nil)
        if(error != nil){
            NSLog(error!.localizedDescription)
        }
    }
    

    @IBAction func manualButtonTapped(_ sender: Any){
        var alertTextField: UITextField?
        
        let alert = UIAlertController(
            title: "Input Scale Identifier",
            message:nil,
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                alertTextField = textField
            })
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default) { _ in
                    let uuid = alertTextField?.text
                    if(uuid != nil){
                        STARDeviceManager.shared().connectScale(withIdentifier: uuid!);
                    }
                }
        )
              self.present(alert, animated: true, completion: nil)
    }
}
