//
//  CTLocationManager.swift
//  CalendarTest
//
//  Created by Abhishek on 13/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation
import CoreLocation

/**
This class is responsible for getting user's current location
*/
class  CTLocationManager:NSObject, CLLocationManagerDelegate {

	///Location manager object
	let locationHelper = CLLocationManager()

	///Completion handler to call when location is available or there is some error
	var currentCompletion:((_ error:Error?, _ currentLocation:CLLocation?) -> Void)?

	///Error objects encountered while fetching location
	enum locationError:Error {

		///Location is turned off
		case locationServiceDisabled

		///User has not given us permission to use location
		case permissionDenied

		///Human readable description for error. It also provide some error resolution tips
		var locationErrorDescription: String {
			switch self {
			case .locationServiceDisabled:
				return "Location service disabled, please enable from settings and retry"
			case .permissionDenied:
				return "Location service permission denided, Please provide location service permisssion from settings and retry"
			}
		}
	}

	/**
	This method gets the location persmission from user(if not already taken) and tries to get current location of user.

	- Parameter Completion: completion handler which will be called when location is fetched or some error ocurred
	- Parameter error: Error during location fetch.
	- Parameter currentLocation: CLLocation object for user's current location
	*/
	final func getCurrentLocation(withCompletion:@escaping (_ error:Error?, _ currentLocation:CLLocation?) -> Void) {
		self.currentCompletion = withCompletion
		//try getting location service permission. It will show alert only for first time
		self.locationHelper.requestWhenInUseAuthorization()
		self.locationHelper.delegate = self
		self.locationHelper.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		self.locationHelper.startUpdatingLocation()
	}

	/**
	This method checks if location service is disabled or location service permission is not provided.
	It calls completion handler accordingly
	*/
	private func checkForLocationAuthorization() {
		if !CLLocationManager.locationServicesEnabled() {
			self.currentCompletion!(locationError.locationServiceDisabled, nil)
			self.currentCompletion = nil
			return
		}

		if CLLocationManager.authorizationStatus() == .denied {
			self.currentCompletion!(locationError.permissionDenied, nil)
			self.currentCompletion = nil
			return
		}
	}


	//MARK: Location manager delegate
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		self.locationHelper.stopUpdatingLocation()
		self.checkForLocationAuthorization()
		//if error is not related to permission or location service
		self.locationHelper.delegate = nil
		self.currentCompletion?(error, nil)
	}

	//got location
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		//stop more location update, one is enough
		self.locationHelper.stopUpdatingLocation()
		self.locationHelper.delegate = nil
		self.currentCompletion?(nil, manager.location!)
	}
}
