//
//  ViewController.swift
//  Project22_Detect-a-Beacon
//
//  Created by Tyler Edwards on 9/16/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var circle: UIView!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        circle.layer.cornerRadius = 128
        circle.layer.borderWidth = 1
        circle.layer.borderColor = UIColor.white.cgColor
        circle.backgroundColor = .clear
        circle.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        //Deprecated: locationManager?.startRangingBeacons(in: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: beaconRegion.uuid, major: beaconRegion.major!.uint16Value, minor: beaconRegion.minor!.uint16Value))
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.circle.transform = .identity
                
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.circle.transform = CGAffineTransform(scaleX: 0, y: 0)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let ac = UIAlertController(title: "Beacon Found", message: "\(region.identifier) is somewhere nearby.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        //TODO: Set a bool to prevent this continually showing up? Was this intended to be done in the didRange: method?
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }

}

