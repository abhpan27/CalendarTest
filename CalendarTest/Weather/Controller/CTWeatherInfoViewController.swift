//
//  CTWeatherInfoViewController.swift
//  CalendarTest
//
//  Created by Abhishek on 13/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This is view controller for showing weather forcast of user's current location.
*/
class CTWeatherInfoViewController: UIViewController {

	/// Table view to show min/max temperature and general weather forcast.
	weak var weatherInfoTableView: UITableView?

	///Label for showing current name of city based on user's location.
	var cityNameLabel:UILabel?

	///Label for showing Current temperature
	var tempratureLabel:UILabel?

	///Label for showing wether condition
	var generalWeatherText:UILabel?

	///Circuler loader to show user some activity for async task
	var loader:UIActivityIndicatorView?

	///UIView which shows error with some hint to resolve the error
	var errorView:UIView?

	///Api helper, used to get data
	let weatherInfoApiHelper = CTWeatherApiHelper()

	///Array of weather info objects which includes min/mac temp, weather condition, city name, date etc
	var arrayOfWeatherInfo = [CTWeatherInfo]()

	override func viewDidLoad() {
        super.viewDidLoad()
		addAndLayoutViews()
		CTWeatherInfoTableViewCell.registerCell(inTableView: weatherInfoTableView!, withIdentifier: "CTWeatherInfoTableViewCell")
		loadWeatherInfo()
    }

	/**
	This method adds and layout all the views. Nothing is added in XIB
	*/
	private func addAndLayoutViews() {
		let separator = addTitleAndTodayWeatherViewSeparator()
		addCloseButton(above: separator)
		addTitleLabel(above: separator)
		let todayWeatherInfoContainer = addTodayWeatherView(below: separator)
		cityNameLabel = addCityNameLabel(inView: todayWeatherInfoContainer)
		tempratureLabel = addCurrTempLabel(inView: todayWeatherInfoContainer, below: cityNameLabel!)
		generalWeatherText = addWeatherInfoLabel(inView: todayWeatherInfoContainer, below: tempratureLabel!)
		weatherInfoTableView = addWeatherInfoTableView(below: todayWeatherInfoContainer)
		weatherInfoTableView?.tableFooterView = UIView()
	}


	/**
	This method loads array of CTWeatherInfo objects with help of weatherInfoApiHelper
	*/
	private func loadWeatherInfo() {
		showLoader()
		weatherInfoApiHelper.getWeatherForcast {
			[weak self]
			(error, weatherInfoList)
			in

			guard let blockSelf = self
				else{
					return
			}
			mainQueueAsync {
				blockSelf.hideLoader()
				guard error == nil
					else{
						blockSelf.showError(error: error!)
						return
				}

				if let arrayOfWeatherInfo = weatherInfoList, arrayOfWeatherInfo.count > 0 {
					blockSelf.arrayOfWeatherInfo = arrayOfWeatherInfo
					blockSelf.updateUIForWeatherInfoChange()
				}
			}
		}
	}

	/**
	This method updates UI of controller when some weather info is present.
	In includes hiding of error view if shown, hiding or loader if shown, updating city, temperature, future forcast etc.
	*/
	private func updateUIForWeatherInfoChange() {
		self.hideError()
		let todayInfo = self.arrayOfWeatherInfo.first!
		self.cityNameLabel?.text = todayInfo.cityText
		self.tempratureLabel?.text = todayInfo.highestTemperature + "°F"
		self.generalWeatherText?.text = todayInfo.weatherConditionText
		self.weatherInfoTableView?.isHidden = false
		self.weatherInfoTableView?.reloadData()
	}

	/**
	This method is action handler for tap on retry button in error view. It just tries to load weather information once again.
	*/
	@objc func didSelectedRetryButton(sender: UIButton!) {
		self.loadWeatherInfo()
	}

	/**
	This method is action handler for tap on close button.
	*/
	@objc func didSelectedCloseButton(sender: UIButton!) {
		self.dismiss(animated: true, completion: nil)
	}

	/**
	This method adds error view error text and retry button.
	Error view is added above table view with left right top bottom aligned to this controller's view.
	*/
	private func showError(error:Error) {
		self.hideError()//hide error if already shown
		var text = "Oops!\n"
		if let locationError = error as?  CTLocationManager.locationError {
			text += locationError.locationErrorDescription
		}else if let apiError = error as? CTWeatherApiHelper.weatherInfoErrors {
			text += apiError.apiErrorDescription
		}else {
			text += error.localizedDescription
		}
		self.errorView = self.addErrorView(withErrorText:text)
	}

	/**
	This method removes error view if added.
	*/
	private func hideError() {
		self.errorView?.removeFromSuperview()
	}

	/**
	This method adds a circuler loader in middle of screen.
	*/
	private func showLoader() {
		self.hideError() //hide if already shown
		self.loader = self.addLoaderView()
		self.loader?.startAnimating()
	}

	/**
	This method hides loader if shown
	*/
	private func hideLoader() {
		self.loader?.removeFromSuperview()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

}


//MARK:UITableView data source and delegate
extension CTWeatherInfoViewController:UITableViewDataSource, UITableViewDelegate {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.arrayOfWeatherInfo.count
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 45
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let weatherInfoCell = tableView.dequeueReusableCell(withIdentifier: "CTWeatherInfoTableViewCell") as! CTWeatherInfoTableViewCell
		weatherInfoCell.updateUI(withData: self.arrayOfWeatherInfo[indexPath.row])
		return weatherInfoCell
	}
}
