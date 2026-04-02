//
//  LocationManager.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 02/04/2026.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var currentAddress: String = "Đang tìm vị trí..."
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Dừng cập nhật liên tục để tiết kiệm pin
        manager.stopUpdatingLocation()
        
        // Dịch ngược toạ độ thành địa chỉ thật
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { pls, _ in
            if let place = pls?.first {
                let street = place.thoroughfare ?? place.subLocality ?? place.name ?? ""
                let city = place.locality ?? place.subAdministrativeArea ?? place.administrativeArea ?? ""
                
                DispatchQueue.main.async {
                    if !street.isEmpty && !city.isEmpty {
                        self.currentAddress = "\(street), \(city)"
                    } else if !city.isEmpty {
                        self.currentAddress = city
                    } else {
                        self.currentAddress = "Vị trí không xác định"
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.currentAddress = "Vị trí không thể xác định"
        }
    }
    
    // Nếu người dùng cấp quyền hoặc đổi quyền thì thử load lại
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        } else if manager.authorizationStatus == .denied {
            self.currentAddress = "Bị từ chối vị trí"
        }
    }
}
