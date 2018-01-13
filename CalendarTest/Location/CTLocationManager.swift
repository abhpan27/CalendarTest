//
//  CTLocationManager.swift
//  CalendarTest
//
//  Created by Abhishek on 13/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation
import CoreLocation

class  CTLocationManager:NSObject, CLLocationManagerDelegate {

	let locationHelper = CLLocationManager()
	var currentCompletion:((_ error:Error?, _ currentLocation:CLLocation?) -> Void)?

	var isLocationEnabled:Bool {
		if CLLocationManager.locationServicesEnabled() {
			switch(CLLocationManager.authorizationStatus()) {
			case .notDetermined, .restricted, .denied:
				return false
			case .authorizedAlways, .authorizedWhenInUse:
				return true
			}
		} else {
			return false
		}
	}

	enum locationError:Error {
		case locationServiceDisabled
		case permissionDenied

		var locationErrorDescription: String {
			switch self {
			case .locationServiceDisabled:
				return "Location service disabled, please enable from settings and retry"
			case .permissionDenied:
				return "Location service permission denided, Please provide location service permisssion from settings and retry"
			}
		}
	}

	final func getCurrentLocation(withCompletion:@escaping (_ error:Error?, _ currentLocation:CLLocation?) -> Void) {
		self.currentCompletion = withCompletion
		self.locationHelper.requestWhenInUseAuthorization()
		if !CLLocationManager.locationServicesEnabled() {
			currentCompletion!(locationError.locationServiceDisabled, nil)
			return
		}
		if CLLocationManager.authorizationStatus() == .denied {
			currentCompletion!(locationError.permissionDenied, nil)
			return
		}

		locationHelper.delegate = self
		locationHelper.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		locationHelper.startUpdatingLocation()
	}


	//MARK: Location manager delegate
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		self.locationHelper.stopUpdatingLocation()
		self.locationHelper.delegate = nil
		self.currentCompletion?(error, nil)
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		self.locationHelper.stopUpdatingLocation()
		self.locationHelper.delegate = nil
		Swift.print("Got location")
		self.currentCompletion?(nil, manager.location!)
	}
}
