//
//  CTWeatherInfoViewController.swift
//  CalendarTest
//
//  Created by Abhishek on 13/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class CTWeatherInfoViewController: UIViewController {

	weak var weatherInfoTableView: UITableView?
	var cityNameLabel:UILabel?
	var tempratureLabel:UILabel?
	var generalWeatherText:UILabel?
	let weatherInfoApiHelper = CTWeatherApiHelper()
	var loader:UIActivityIndicatorView?
	var errorView:UIView?
	var arrayOfWeatherInfo = [CTWeatherInfo]()

	override func viewDidLoad() {
        super.viewDidLoad()
		addAndLayoutViews()
		CTWeatherInfoTableViewCell.registerCell(inTableView: weatherInfoTableView!, withIdentifier: "CTWeatherInfoTableViewCell")
		loadWeatherInfo()
    }

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

	private func updateUIForWeatherInfoChange() {
		self.hideError()
		let todayInfo = self.arrayOfWeatherInfo.first!
		self.cityNameLabel?.text = todayInfo.cityText
		self.tempratureLabel?.text = todayInfo.highestTemperature + "°F"
		self.generalWeatherText?.text = todayInfo.weatherConditionText
		self.weatherInfoTableView?.isHidden = false
		self.weatherInfoTableView?.reloadData()
	}

	@objc func didSelectedRetryButton(sender: UIButton!) {
		self.loadWeatherInfo()
	}

	@objc func didSelectedCloseButton(sender: UIButton!) {
		self.dismiss(animated: true, completion: nil)
	}

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

	private func hideError() {
		self.errorView?.removeFromSuperview()
	}

	private func showLoader() {
		self.hideError() //hide if already shown
		self.loader = self.addLoaderView()
		self.loader?.startAnimating()
	}

	private func hideLoader() {
		self.loader?.removeFromSuperview()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

}

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
