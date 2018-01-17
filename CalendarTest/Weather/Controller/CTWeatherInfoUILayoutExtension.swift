//
//  CTWeatherInfoUILayoutExtension.swift
//  CalendarTest
//
//  Created by Abhishek on 13/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This is an extension to CTWeatherInfoViewController
All subview add and layout related code is here.
*/
extension CTWeatherInfoViewController {

	/**
	This methods adds error view. Error view contains one label and one retry button.

	Error view is top, left, bottom, right align to view of this controller.
	error label is added vertically and horizontally centered in error view
	Retry button is added horizontally centered to error view and below error label.

	- Returns: UIView which contains error label and retry button.
	*/
	 final func addErrorView(withErrorText:String) -> UIView {
		//add error view first
		let errorView = UIView()
		errorView.backgroundColor = UIColor.white
		self.view.addFittingSubview(subView: errorView)


		//now add error label in error view
		let errorLabel = UILabel()
		errorView.addSubview(errorLabel)
		errorLabel.numberOfLines = 0
		errorLabel.textColor = UIColor.gray
		errorLabel.text = withErrorText
		errorLabel.textAlignment = .center
		errorLabel.translatesAutoresizingMaskIntoConstraints = false

		//constraints for error label
		let left = NSLayoutConstraint(item: errorLabel, attribute: .left, relatedBy: .equal, toItem: errorView, attribute: .left, multiplier: 1.0, constant: 20)
		let centerX = NSLayoutConstraint(item: errorLabel, attribute: .centerX, relatedBy: .equal, toItem: errorView, attribute: .centerX, multiplier: 1.0, constant: 0)
		let centerY = NSLayoutConstraint(item: errorLabel, attribute: .centerY, relatedBy: .equal, toItem: errorView, attribute: .centerY, multiplier: 1.0, constant: 0)
		NSLayoutConstraint.activate([left, centerY, centerX])

		//now add retry button below error label
		let retryButton = UIButton()
		errorView.addSubview(retryButton)
		retryButton.setTitle("Retry", for: .normal)
		retryButton.setTitleColor(UIColor.white, for: .normal)
		retryButton.backgroundColor = UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0)
		retryButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
		retryButton.addTarget(self, action: #selector(CTWeatherInfoViewController.didSelectedRetryButton(sender:))  , for: .touchUpInside)
		retryButton.translatesAutoresizingMaskIntoConstraints = false

		// constraints for retry button
		let height = NSLayoutConstraint(item: retryButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 45)
		let buttonCenterX = NSLayoutConstraint(item: retryButton, attribute: .centerX, relatedBy: .equal, toItem: errorView, attribute: .centerX, multiplier: 1.0, constant: 1.0)
		let top = NSLayoutConstraint(item: retryButton, attribute: .top, relatedBy: .equal, toItem: errorLabel, attribute: .bottom, multiplier: 1.0, constant: 15)
		NSLayoutConstraint.activate([height, buttonCenterX, top])
		retryButton.layoutIfNeeded()
		retryButton.layer.cornerRadius = retryButton.frame.height / 2

		//bring error view to front to hide all other views
		self.view.bringSubview(toFront: errorView)

		//also keep reference of error view.
		return errorView
	}

	/**
	This methods adds a animating circuler loader in center of view of this controller
	*/
	final func addLoaderView() -> UIActivityIndicatorView {
		let activityIndicator = UIActivityIndicatorView()
		self.view.addSubview(activityIndicator)
		activityIndicator.activityIndicatorViewStyle = .gray
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false

		let centerX = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
		let centerY = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0)

		NSLayoutConstraint.activate([centerX, centerY])
		self.view.bringSubview(toFront: activityIndicator)
		return activityIndicator
	}

	/**
	This methods adds a 1pt separator line between title of view, and view which contains today's weather information.
	 - Returns: UIView that can be used as separator.
	*/
	func addTitleAndTodayWeatherViewSeparator() -> UIView {
		let separator = UIView()
		self.view.addSubview(separator)
		separator.backgroundColor = UIColor(red: 242/255, green: 244/255, blue: 242/255, alpha: 1.0)
		separator.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: separator, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: separator, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: UIApplication.shared.statusBarFrame.height + 45)  // used UIApplication.shared.statusBarFrame.height to avoid clipping in iPhone X
		let height = NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1)

		NSLayoutConstraint.activate([left, right, top, height])
		return separator
	}

	/**
	This method adds close button on top left corner of view.

	button will be left aligned to view of this controller.
	Bottom aligned to top of separator
	width = 50
	height = 40

	- Parameter above: UIView object. Bottom of button will be aligned to top of this view.
	*/
	func addCloseButton(above:UIView) {
		let closeButton = UIButton()
		self.view.addSubview(closeButton)
		closeButton.setTitle("×", for: .normal)
		closeButton.titleLabel?.font = CTFont.systemFont(ofSize: 28, weight: .SemiBold)
		closeButton.setTitleColor(UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0), for: .normal)
		closeButton.addTarget(self, action: #selector(CTWeatherInfoViewController.didSelectedCloseButton(sender:)), for: .touchUpInside)
		closeButton.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: closeButton, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let bottom = NSLayoutConstraint(item: closeButton, attribute: .bottom, relatedBy: .equal, toItem: above, attribute: .bottom, multiplier: 1.0, constant: 0)
		let width = NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
		let height =  NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
		NSLayoutConstraint.activate([left, height, bottom, width])
	}

	/**
	This method adds a label with text "Weather" on top of view.

	Label will be center alined to view of this controller.
	In Y Direction - Bottom of label - 5pt gap - top of separator

	- Parameter above: UIView object. Bottom of UILabel will 5pt above this view.
	*/
	func addTitleLabel(above:UIView) {
		let weatherTitleLabel = UILabel()
		self.view.addSubview(weatherTitleLabel)
		weatherTitleLabel.textColor = UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0)
		weatherTitleLabel.font = CTFont.systemFont(ofSize: 22, weight: .Medium)
		weatherTitleLabel.text = "Weather"
		weatherTitleLabel.translatesAutoresizingMaskIntoConstraints = false

		let centerX = NSLayoutConstraint(item: weatherTitleLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
		let bottom = NSLayoutConstraint(item: weatherTitleLabel, attribute: .bottom, relatedBy: .equal, toItem: above, attribute: .bottom, multiplier: 1.0, constant: -5)
		NSLayoutConstraint.activate([centerX, bottom])
	}

	/**
	This method adds a View with blue background. This view shows today's date temperature, current city and weather condition.

	This view will be left and right aligned to view of this controller and top aligned to bottom of separator
	Height will be 150pt

	- Parameter below: UIView object bottom of which will be aligned to top of this view.
	- Returns: A UIView object which holds city, temperature and weather condition with blue background.
	*/
	func addTodayWeatherView(below:UIView) -> UIView {
		let todayInfoContainerView = UIView()
		self.view.addSubview(todayInfoContainerView)
		todayInfoContainerView.backgroundColor = UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0)
		todayInfoContainerView.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: todayInfoContainerView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: todayInfoContainerView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: todayInfoContainerView, attribute: .top, relatedBy: .equal, toItem: below, attribute: .bottom, multiplier: 1.0, constant: 0)
		let height = NSLayoutConstraint(item: todayInfoContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 150)

		NSLayoutConstraint.activate([left, right, top, height])
		return todayInfoContainerView
	}

	/**
	This method adds lable to show current city name.

	This label will be center aligned to inView and top of this label will be 25 pt below inView

	- Parameter inView: View in which this label will be added.
	- Returns: A UIlabel object.
	*/
	func addCityNameLabel(inView:UIView) -> UILabel {
		let cityNameLabel = UILabel()
		inView.addSubview(cityNameLabel)
		cityNameLabel.textColor = UIColor.white
		cityNameLabel.font = CTFont.systemFont(ofSize: 14, weight: .Regular)
		cityNameLabel.translatesAutoresizingMaskIntoConstraints = false

		let centerX = NSLayoutConstraint(item: cityNameLabel, attribute: .centerX, relatedBy: .equal, toItem: inView, attribute: .centerX, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: cityNameLabel, attribute: .top, relatedBy: .equal, toItem: inView, attribute: .top, multiplier: 1.0, constant: 25)
		NSLayoutConstraint.activate([centerX, top])

		return cityNameLabel
	}


	/**
	This method adds lable to show current temperature at user's location.

	This label will be center aligned to inView and top of this label will be 8pt below city label

	- Parameter inView: View in which this label will be added.
	- Parameter below: A UILabel object below which this label will be added.
	- Returns: A UIlabel object.
	*/
	func addCurrTempLabel(inView:UIView, below:UILabel) -> UILabel {
		let currTempLabel = UILabel()
		inView.addSubview(currTempLabel)
		currTempLabel.textColor = UIColor.white
		currTempLabel.font = CTFont.systemFont(ofSize: 40, weight: .SemiBold)
		currTempLabel.translatesAutoresizingMaskIntoConstraints = false

		let centerX = NSLayoutConstraint(item: currTempLabel, attribute: .centerX, relatedBy: .equal, toItem: inView, attribute: .centerX, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: currTempLabel, attribute: .top, relatedBy: .equal, toItem: below, attribute: .bottom, multiplier: 1.0, constant: 8)
		NSLayoutConstraint.activate([centerX, top])
		return currTempLabel
	}


	/**
	This method adds lable to show current weather condition at user's location.

	This label will be center aligned to inView and top of this label will be 8pt below temperature label

	- Parameter inView: View in which this label will be added.
	- Parameter below: A UILabel object below which this label will be added.
	- Returns: A UIlabel object.
	*/
	func addWeatherInfoLabel(inView:UIView, below:UILabel) -> UILabel {
		let weatherInfoLabel = UILabel()
		inView.addSubview(weatherInfoLabel)
		weatherInfoLabel.textColor = UIColor.white
		weatherInfoLabel.font = CTFont.systemFont(ofSize: 14, weight: .Regular)
		weatherInfoLabel.translatesAutoresizingMaskIntoConstraints = false

		let centerX = NSLayoutConstraint(item: weatherInfoLabel, attribute: .centerX, relatedBy: .equal, toItem: inView, attribute: .centerX, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: weatherInfoLabel, attribute: .top, relatedBy: .equal, toItem: below, attribute: .bottom, multiplier: 1.0, constant: 8)
		NSLayoutConstraint.activate([centerX, top])
		return weatherInfoLabel
	}

	/**
	This method adds UITableView to show future weather forecasting.

	This table view is left, right and bottom aligned to view of this controller
	And it is top aligned to bottom of view (in blue color) which holds today's weather info

	- Parameter below: A UIView object below which this TableView will be added.
	- Returns: A UITableView object.
	*/
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
