//
//  CTWeatherApiHelper.swift
//  CalendarTest
//
//  Created by Abhishek on 13/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

final class CTWeatherInfo {

	let weatherConditionText:String
	let lowestTemperature:String
	let highestTemperature:String
	let dateText:String
	let cityText:String

	init(weatherConditionText:String, lowestTemperature:String, highestTemperature:String, dateText:String, cityText:String) {
		self.weatherConditionText = weatherConditionText
		self.lowestTemperature = lowestTemperature
		self.highestTemperature = highestTemperature
		self.dateText = dateText
		self.cityText = cityText
	}

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

final class CTWeatherApiHelper {

	enum weatherInfoErrors:Error {
		case objectDeallocated
		case invalidUrlCreated
		case invalideApiResponse

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

	let locationManager = CTLocationManager()
	var lastDataTask:URLSessionTask?

	func getWeatherForcast(completion:@escaping (_ error:Error?, _ arrayOfWeatherInfo:[CTWeatherInfo]?) -> ()) {
		self.lastDataTask?.cancel()
		locationManager.getCurrentLocation {
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
					completion(error!, nil)
					return
			}

			guard let url = blockSelf.getUrlForWeatherAPI(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
				else {
					completion(weatherInfoErrors.invalidUrlCreated, nil)
					return
			}

			blockSelf.lastDataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
				guard error == nil
					else {
						completion(error!, nil)
						return
				}

				guard let rawData = data
					else {
						completion(weatherInfoErrors.invalideApiResponse, nil)
						return
				}

				do {
					let jsonDict = try JSONSerialization.jsonObject(with: rawData, options: []) as! [String:AnyObject]
					let arrayOfWeatherInfoObject = blockSelf.arrayOfWeatherInfoObject(jsonDict: jsonDict)
					if arrayOfWeatherInfoObject.count > 0 {
						completion(nil, arrayOfWeatherInfoObject)
					}else {
						completion(weatherInfoErrors.invalideApiResponse, nil)
					}
				}catch  {
					completion(weatherInfoErrors.invalideApiResponse, nil)
				}
			}
			blockSelf.lastDataTask?.resume()
		}
	}

	private func getWoiedQueryString(latitude:Double, longitude:Double) -> String {
		let query = "select * from weather.forecast where woeid in (SELECT woeid FROM geo.places WHERE text=\"(\(latitude),\(longitude))\")"
		return query
	}

	private func getUrlForWeatherAPI(latitude:Double, longitude:Double) -> URL? {
		let woeidString = self.getWoiedQueryString(latitude: latitude, longitude: longitude)
		let woeidQueryParam = URLQueryItem(name: "q", value: woeidString)
		let formateQueryParam = URLQueryItem(name: "format", value: "json")
		let endPointString = "https://query.yahooapis.com/v1/public/yql"
		var urlcomponents = URLComponents(string: endPointString)
		urlcomponents?.queryItems = [woeidQueryParam, formateQueryParam]
		return urlcomponents?.url
	}

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

		if let todayWeatherInfo = CTWeatherInfo(weatherDict: todayCondition, isToday: true, cityText: city) {
			weatherInfoObjects.append(todayWeatherInfo)
		}

		//future forcast
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
