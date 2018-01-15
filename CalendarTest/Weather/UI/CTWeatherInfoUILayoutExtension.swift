//
//  CTWeatherInfoUILayoutExtension.swift
//  CalendarTest
//
//  Created by Abhishek on 13/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

extension CTWeatherInfoViewController {

	 final func addErrorView(withErrorText:String) -> UIView {
		let errorView = UIView()
		errorView.backgroundColor = UIColor.white
		self.view.addFittingSubview(subView: errorView)

		let errorLabel = UILabel()
		errorLabel.numberOfLines = 0
		errorLabel.textColor = UIColor.gray
		errorLabel.text = withErrorText
		errorLabel.textAlignment = .center
		errorView.addSubview(errorLabel)
		errorLabel.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: errorLabel, attribute: .left, relatedBy: .equal, toItem: errorView, attribute: .left, multiplier: 1.0, constant: 20)
		let centerX = NSLayoutConstraint(item: errorLabel, attribute: .centerX, relatedBy: .equal, toItem: errorView, attribute: .centerX, multiplier: 1.0, constant: 0)
		let centerY = NSLayoutConstraint(item: errorLabel, attribute: .centerY, relatedBy: .equal, toItem: errorView, attribute: .centerY, multiplier: 1.0, constant: 0)
		NSLayoutConstraint.activate([left, centerY, centerX])

		let retryButton = UIButton()
		retryButton.setTitle("Retry", for: .normal)
		retryButton.setTitleColor(UIColor.white, for: .normal)
		retryButton.backgroundColor = UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0)
		retryButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
		errorView.addSubview(retryButton)
		retryButton.addTarget(self, action: #selector(CTWeatherInfoViewController.didSelectedRetryButton(sender:))  , for: .touchUpInside)

		retryButton.translatesAutoresizingMaskIntoConstraints = false
		let height = NSLayoutConstraint(item: retryButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 45)
		let buttonCenterX = NSLayoutConstraint(item: retryButton, attribute: .centerX, relatedBy: .equal, toItem: errorView, attribute: .centerX, multiplier: 1.0, constant: 1.0)
		let top = NSLayoutConstraint(item: retryButton, attribute: .top, relatedBy: .equal, toItem: errorLabel, attribute: .bottom, multiplier: 1.0, constant: 15)
		NSLayoutConstraint.activate([height, buttonCenterX, top])
		retryButton.layoutIfNeeded()
		retryButton.layer.cornerRadius = retryButton.frame.height / 2

		self.view.bringSubview(toFront: errorView)
		return errorView
	}

	final func addLoaderView() -> UIActivityIndicatorView {
		let activityIndicator = UIActivityIndicatorView()
		activityIndicator.activityIndicatorViewStyle = .gray
		self.view.addSubview(activityIndicator)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false

		let centerX = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
		let centerY = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0)

		NSLayoutConstraint.activate([centerX, centerY])
		self.view.bringSubview(toFront: activityIndicator)
		return activityIndicator
	}

	func addTitleAndTodayWeatherViewSeparator() -> UIView {
		let separator = UIView()
		separator.backgroundColor = UIColor(red: 242/255, green: 244/255, blue: 242/255, alpha: 1.0)
		separator.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(separator)

		let left = NSLayoutConstraint(item: separator, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: separator, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: UIApplication.shared.statusBarFrame.height + 45)
		let height = NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1)

		NSLayoutConstraint.activate([left, right, top, height])
		return separator
	}

	func addCloseButton(above:UIView) {
		let closeButton = UIButton()
		closeButton.setTitle("×", for: .normal)
		closeButton.titleLabel?.font = CTFont.systemFont(ofSize: 28, weight: .SemiBold)
		closeButton.setTitleColor(UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0), for: .normal)
		self.view.addSubview(closeButton)
		closeButton.translatesAutoresizingMaskIntoConstraints = false
		closeButton.addTarget(self, action: #selector(CTWeatherInfoViewController.didSelectedCloseButton(sender:)), for: .touchUpInside)

		let left = NSLayoutConstraint(item: closeButton, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let bottom = NSLayoutConstraint(item: closeButton, attribute: .bottom, relatedBy: .equal, toItem: above, attribute: .bottom, multiplier: 1.0, constant: 0)
		let width = NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
		let height =  NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
		NSLayoutConstraint.activate([left, height, bottom, width])
	}

	func addTitleLabel(above:UIView) {
		let weatherTitleLabel = UILabel()
		weatherTitleLabel.textColor = UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0)
		weatherTitleLabel.font = CTFont.systemFont(ofSize: 22, weight: .Medium)
		weatherTitleLabel.text = "Weather"
		weatherTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(weatherTitleLabel)
		let centerX = NSLayoutConstraint(item: weatherTitleLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
		let bottom = NSLayoutConstraint(item: weatherTitleLabel, attribute: .bottom, relatedBy: .equal, toItem: above, attribute: .bottom, multiplier: 1.0, constant: -5)
		NSLayoutConstraint.activate([centerX, bottom])
	}

	func addTodayWeatherView(below:UIView) -> UIView {
		let todayInfoContainerView = UIView()
		todayInfoContainerView.backgroundColor = UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0)
		self.view.addSubview(todayInfoContainerView)
		todayInfoContainerView.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: todayInfoContainerView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: todayInfoContainerView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: todayInfoContainerView, attribute: .top, relatedBy: .equal, toItem: below, attribute: .bottom, multiplier: 1.0, constant: 0)
		let height = NSLayoutConstraint(item: todayInfoContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 150)

		NSLayoutConstraint.activate([left, right, top, height])
		return todayInfoContainerView
	}

	func addCityNameLabel(inView:UIView) -> UILabel {
		let cityNameLabel = UILabel()
		cityNameLabel.textColor = UIColor.white
		cityNameLabel.font = CTFont.systemFont(ofSize: 14, weight: .Regular)
		cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
		inView.addSubview(cityNameLabel)

		let centerX = NSLayoutConstraint(item: cityNameLabel, attribute: .centerX, relatedBy: .equal, toItem: inView, attribute: .centerX, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: cityNameLabel, attribute: .top, relatedBy: .equal, toItem: inView, attribute: .top, multiplier: 1.0, constant: 25)
		NSLayoutConstraint.activate([centerX, top])

		return cityNameLabel
	}

	func addCurrTempLabel(inView:UIView, below:UILabel) -> UILabel {
		let currTempLabel = UILabel()
		currTempLabel.textColor = UIColor.white
		currTempLabel.font = CTFont.systemFont(ofSize: 40, weight: .SemiBold)
		currTempLabel.translatesAutoresizingMaskIntoConstraints = false
		inView.addSubview(currTempLabel)

		let centerX = NSLayoutConstraint(item: currTempLabel, attribute: .centerX, relatedBy: .equal, toItem: inView, attribute: .centerX, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: currTempLabel, attribute: .top, relatedBy: .equal, toItem: below, attribute: .bottom, multiplier: 1.0, constant: 8)
		NSLayoutConstraint.activate([centerX, top])
		return currTempLabel
	}

	func addWeatherInfoLabel(inView:UIView, below:UILabel) -> UILabel {
		let weatherInfoLabel = UILabel()
		weatherInfoLabel.textColor = UIColor.white
		weatherInfoLabel.font = CTFont.systemFont(ofSize: 14, weight: .Regular)
		weatherInfoLabel.translatesAutoresizingMaskIntoConstraints = false
		inView.addSubview(weatherInfoLabel)

		let centerX = NSLayoutConstraint(item: weatherInfoLabel, attribute: .centerX, relatedBy: .equal, toItem: inView, attribute: .centerX, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: weatherInfoLabel, attribute: .top, relatedBy: .equal, toItem: below, attribute: .bottom, multiplier: 1.0, constant: 8)
		NSLayoutConstraint.activate([centerX, top])
		return weatherInfoLabel
	}

	func addWeatherInfoTableView(below:UIView) -> UITableView {
		let tableView = UITableView()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(tableView)

		let left = NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: below, attribute: .bottom, multiplier: 1.0, constant: 0)
		let bottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)

		NSLayoutConstraint.activate([left, right, top, bottom])
		return tableView
	}

}
