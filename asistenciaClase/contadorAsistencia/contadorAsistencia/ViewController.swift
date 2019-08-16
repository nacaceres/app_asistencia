//
//  ViewController.swift
//  contadorAsistencia
//
//  Created by Nicolas Caceres on 8/13/19.
//  Copyright © 2019 Nicolas Caceres. All rights reserved.
//

import UIKit
import CoreBluetooth
class ViewController: UIViewController {
    var centralManager: CBCentralManager!
    var respuesta = ""{
        didSet{
            asistencia.numberOfLines = 0
            asistencia.lineBreakMode = NSLineBreakMode.byWordWrapping
            asistencia.text=respuesta}
    }
    override func viewDidLoad() {
        discover.hidesWhenStopped = true;
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        // Do any additional setup after loading the view.
    }


    @IBAction func helloWorld(_ sender: UIButton) {
        centralManager.scanForPeripherals(withServices: nil)
        discover.hidesWhenStopped = false;
        discover.startAnimating();
    }
    
    @IBAction func asisti(_ sender: UIButton) {
        let fecha = Date()
        let calendar = Calendar.current
        let mes = (calendar.component(.month, from: fecha)) - 1
        let fechaURL = "\(calendar.component(.day, from: fecha))-\(mes)-\(calendar.component(.year, from: fecha))"
        let url = URL(string: "https://firestore.googleapis.com/v1/projects/attendancelistapp/databases/(default)/documents/attendance/\(fechaURL)/students/201630692")!
        print(url)
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            DispatchQueue.main.async {
            self.respuesta=String(data: data, encoding: .utf8)!
                  }
        }
        task.resume()
    }
    

    @IBOutlet weak var discover: UIActivityIndicatorView!
    @IBOutlet weak var asistencia: UILabel!
    
    
}
extension ViewController: CBCentralManagerDelegate { //esto
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
        }
        
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print(peripheral)
        
    }
    
}


