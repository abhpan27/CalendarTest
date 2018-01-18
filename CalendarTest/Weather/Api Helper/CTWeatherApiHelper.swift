//
//  CTWeatherApiHelper.swift
//  CalendarTest
//
//  Created by Abhishek on 13/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation


/**
This Class represents weather information for single day, Object of this class is consumed by weather view controller to create UI.
*/
final class CTWeatherInfo {

	///Weather condition on day. example - clear, sunny etc
	let weatherConditionText:String

	///Lowest temperature on date in fahrenheit
	let lowestTemperature:String

	///Highest temperature on date in fahrenheit
	let highestTemperature:String

	///Date for which this weather forcasting is done
	let dateText:String

	///City for which this weather forcasting is done
	let cityText:String

	init(weatherConditionText:String, lowestTemperature:String, highestTemperature:String, dateText:String, cityText:String) {
		self.weatherConditionText = weatherConditionText
		self.lowestTemperature = lowestTemperature
		self.highestTemperature = highestTemperature
		self.dateText = dateText
		self.cityText = cityText
	}

	/**
	This is a convience intializer to create weather info object from json response of Api.

	- Parameter weatherDict: key value pair for weather info.
	- Parameter isToday: Bool to show weather this forcasting is for today's date.
	- Parameter cityText: String for city name for which this forcasting is done.
	*/
	convenience init?(weatherDict:[String:AnyObject], isToday:Bool, cityText:String) {
		guard let weatherConditionText = weatherDict["text"] as? String
			else {
				return nil
		}

		let highTempInfoKey = isToday ? "temp" : "high"
		guard let highestTemperature = weatherDict[highTempInfoKey] as? String
			else {
			return nil
		}

		let lowTempInfoKey = isToday ? "temp" : "low"
		guard let lowestTemperature = weatherDict[lowTempInfoKey] as? String
			else {
			return nil
		}

		guard var dateText = weatherDict["date"] as? String
			else {
				return nil
		}

		dateText = isToday ? Date().displayDateText : dateText
		self.init(weatherConditionText: weatherConditionText, lowestTemperature: lowestTemperature, highestTemperature: highestTemperature, dateText: dateText, cityText:cityText)

	}
}


/**
This class usage Yahoo weather api and CLLocationManager to get today's weather information as well as some future weather forcast for user's current location.

It is based on Yahoo weather api - https://developer.yahoo.com/weather/
This class is using public weather API which has limitation of 2000 hits per day. Also attribution is not added here which should be added for real app.
*/
final class CTWeatherApiHelper {

	/**
	Enum for different kind of error encountered during loading weather information
	*/
	enum weatherInfoErrors:Error {

		/// Object of this class was deallocated by creater.
		case objectDeallocated

		///URL formed for api is invalid
		case invalidUrlCreated

		///Response from Yahoo weather api is not as expected
		case invalideApiResponse

		///Human readable error text for api errors.
		var apiErrorDescription: String {
			switch self {
			case .objectDeallocated:
				return ""
			case .invalideApiResponse:
				return "Invalid api response"
			case .invalidUrlCreated:
				return "Invalid Url created"
			}
		}
	}

	///Location manager object used to get current latitude and longitude of user
	let locationManager = CTLocationManager()

	///last data task intialted by object of this class
	var lastDataTask:URLSessionTask?


	/**
	This method fires Yahoo weather api for user's current location and convert JSON response into array of CTWeatherInfo objects.

	- Parameter completion: Completion handler called when loading weather information is completed or some error ocurred.
	- Parameter error: Any error encountered while loading weather information.
	- Parameter arrayOfWeatherInfo: Array of CTWeatherInfo objects which can be used to create UI.
	*/
	func getWeatherForcast(completion:@escaping (_ error:Error?, _ arrayOfWeatherInfo:[CTWeatherInfo]?) -> ()) {
		//if already fired api then cancel that
		self.lastDataTask?.cancel()

		//get user's current location
		self.locationManager.getCurrentLocation {
			[weak self]
			(error, location)
			in

			guard let blockSelf = self
				else {
					completion(weatherInfoErrors.objectDeallocated, nil)
					return
			}

			guard error == nil
				else {
					//failed to get location
					completion(error!, nil)
					return
			}

			//got user's current location succesfully, not get URL for user's latitue and longitude
			guard let url = blockSelf.getUrlForWeatherAPI(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
				else {
					//url creation failed
					completion(weatherInfoErrors.invalidUrlCreated, nil)
					return
			}

			// Got URL, Now fire Yahoo weather api
			blockSelf.lastDataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
				guard error == nil
					else {
						//error in api
						completion(error!, nil)
						return
				}

				guard let rawData = data
					else {
						//no data recived from api
						completion(weatherInfoErrors.invalideApiResponse, nil)
						return
				}

				do {
					let jsonDict = try JSONSerialization.jsonObject(with: rawData, options: []) as! [String:AnyObject]
					//convert json into array of weather info
					let arrayOfWeatherInfoObject = blockSelf.arrayOfWeatherInfoObject(jsonDict: jsonDict)
					if arrayOfWeatherInfoObject.count > 0 {
						completion(nil, arrayOfWeatherInfoObject)
					}else {
						//this json struture was same as expected
						completion(weatherInfoErrors.invalideApiResponse, nil)
					}
				}catch  {
					//failed to parse json recived from api
					completion(weatherInfoErrors.invalideApiResponse, nil)
				}
			}
			blockSelf.lastDataTask?.resume()
		}
	}

	/**
	This method creates query for getting weather forecast. It uses latitude longitude to find Woied(Where On Earth IDentifier).

	- Parameter latitude: Latitude of user's location.
	- Parameter longitude: Longitude of user's location.
	- Returns: Query which can be used for yahoo weather api.
	*/
	private func getWoiedQueryString(latitude:Double, longitude:Double) -> String {
		let query = "select * from weather.forecast where woeid in (SELECT woeid FROM geo.places WHERE text=\"(\(latitude),\(longitude))\")"
		return query
	}

	/**
	This method creates URL object which can be used for Yahoo weather api.

	- Parameter latitude: Latitude of user's location.
	- Parameter longitude: Longitude of user's location.
	- Returns: URL object for Yahoo weather api. It can be nil if Woeid query can't be created.
	*/
	private func getUrlForWeatherAPI(latitude:Double, longitude:Double) -> URL? {
		let woeidString = self.getWoiedQueryString(latitude: latitude, longitude: longitude)

		//query params
		let woeidQueryParam = URLQueryItem(name: "q", value: woeidString)
		let formateQueryParam = URLQueryItem(name: "format", value: "json")

		//end point of api
		let endPointString = "https://query.yahooapis.com/v1/public/yql"
		var urlcomponents = URLComponents(string: endPointString)

		//add query in end point
		urlcomponents?.queryItems = [woeidQueryParam, formateQueryParam]
		return urlcomponents?.url
	}

	/**
	This method converts JSON response from api into array of CTWeatherInfo objects which can be used for creating UI.
	- Parameter jsonDict: Json dictonary recived from API.
	- Returns: Array of CTWeatherInfo objects.
	- Note: Json parsing here is based on sample response given here - https://developer.yahoo.com/weather/
	*/
	private func arrayOfWeatherInfoObject(jsonDict:[String:AnyObject]) -> [CTWeatherInfo] {
		var weatherInfoObjects = [CTWeatherInfo]()
		guard let queryDict = jsonDict["query"] as? [String:AnyObject]
			else {
				return weatherInfoObjects
		}

		guard let results = queryDict["results"] as? [String:AnyObject]
			else {
				return weatherInfoObjects
		}

		guard let channels = results["channel"] as? [String:AnyObject]
			else {
				return weatherInfoObjects
		}

		guard let locationInfo = channels["location"] as? [String:AnyObject]
			else {
				return weatherInfoObjects
		}

		guard let city = locationInfo["city"] as? String
			else {
			return weatherInfoObjects
		}

		guard let weatherInfoItem = channels["item"] as? [String:AnyObject]
			else {
				return weatherInfoObjects
		}

		guard let todayCondition = weatherInfoItem["condition"] as? [String:AnyObject]
			else {
				return weatherInfoObjects
		}

		//today's info
		if let todayWeatherInfo = CTWeatherInfo(weatherDict: todayCondition, isToday: true, cityText: city) {
			weatherInfoObjects.append(todayWeatherInfo)
		}

		//future forcasting
		guard let futureForcasts = weatherInfoItem["forecast"] as? [[String:AnyObject]]
			else {
				return weatherInfoObjects
		}

		for forecast in futureForcasts {
			if let weatherInfo = CTWeatherInfo(weatherDict: forecast, isToday: false, cityText: city) {
				weatherInfoObjects.append(weatherInfo)
			}
		}

		return weatherInfoObjects
	}
}
