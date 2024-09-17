//
//  PeripheralVC.swift
//  IoTApp
//
//  Created by Daniel Jermaine on 08/08/2024.
//

import UIKit
import CoreBluetooth

class PeripheralVC: UIViewController,BluetoothListener {
    
    var devices: [CBPeripheral] = []
    var bluetoothViewModel = BluetoothViewModel()
    @IBOutlet weak var peripheralTblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothViewModel.delegate = self
        peripheralTblView.register(UINib(nibName: "PeripheralCell", bundle: nil), forCellReuseIdentifier: "PeripheralCell")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func scanBtnTap(_ sender: Any) {
        bluetoothViewModel.startScanning()
    }
    func logo(devices: [CBPeripheral]) {
        self.devices = devices
        peripheralTblView.reloadData()
    }
}


extension PeripheralVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bluetoothViewModel.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeripheralCell") as! PeripheralCell
        if bluetoothViewModel.connectedPeripherals.contains(devices[indexPath.row]){
            cell.statusLbl.text = "connected"
        }else{
            cell.statusLbl.text = "Disconnected"
        }
        cell.peripheralNameLbl.text = devices[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bluetoothViewModel.connectToPeripheral1(peripheral: devices[indexPath.row])
    }
    
}
