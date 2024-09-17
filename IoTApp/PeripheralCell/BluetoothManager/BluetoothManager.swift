//
//  BluetoothManager.swift
//  Tanta
//
//  Created by Daniel Jermaine on 08/08/2024.
//
import Foundation
import CoreBluetooth
import UIKit

protocol BluetoothListener {
    func logo(devices:[CBPeripheral])
}
class BluetoothViewModel: NSObject, ObservableObject, CBPeripheralDelegate, CBCentralManagerDelegate {

    static let shared = BluetoothViewModel()
    var delegate:BluetoothListener?
    private var centralManager: CBCentralManager!
    private var connectedPeripheral1: CBPeripheral?
    private var connectedPeripheral2: CBPeripheral?
     var connectedPeripherals: [CBPeripheral] = []
    private var characteristic: CBCharacteristic?
    @Published var devices: [CBPeripheral] = []
    var peripheralArr:[String: CBPeripheral] = [:]
    var getAllNearByBLE:[String] = []
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)

    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
          startScanning()
        default:
            print("Bluetooth state: \(central.state.rawValue)")
        }
    }

  func startScanning() {
      if centralManager.state == .poweredOn {
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
//            Stop scanning after 10 seconds
          DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
             self?.stopScanning()
          }
      }
  }

  func stopScanning() {
      centralManager.stopScan()
      // Optionally restart scanning after a delay
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
          self?.startScanning()
      }
  }
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
    DispatchQueue.main.async { [weak self] in
      if !self!.devices.contains(where: { $0.identifier == peripheral.identifier }) {
        if let name = peripheral.name, !name.isEmpty {
          self?.devices.append(peripheral)
            self?.delegate?.logo(devices: self?.devices ?? [])
        }
      }
    }
  }


    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

        print("Connected to peripheral: \(String(describing: peripheral.name))")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
      self.delegate?.logo(devices: self.devices )
    }

    func connectToPeripheral1(peripheral: CBPeripheral) {
        if let connectedPeripheral = connectedPeripheral1 {
            centralManager.cancelPeripheralConnection(connectedPeripheral)
        }
        connectedPeripheral1 = peripheral
        connectedPeripherals.append(peripheral)
        centralManager.connect(peripheral, options: nil)
    }

    func connectToPeripheral2(peripheral: CBPeripheral) {
        if let connectedPeripheral = connectedPeripheral2 {
            centralManager.cancelPeripheralConnection(connectedPeripheral)
        }
        connectedPeripheral2 = peripheral
        connectedPeripherals.append(peripheral)
        centralManager.connect(peripheral, options: nil)

    }

  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    print(peripheral.name ??  peripheral.identifier)
  }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        guard let characteristic = service.characteristics?.first(where: { $0.properties.contains(.write) }) else {
            print("No characteristic with write property found.")
            return
        }
        self.characteristic = characteristic
    }

    // Optional: Disconnect from peripherals
    func disconnectFromPeripheral1() {
        if let peripheral = connectedPeripheral1 {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }

    func disconnectFromPeripheral2() {
        if let peripheral = connectedPeripheral2 {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
}
