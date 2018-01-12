//
//  CTAppRootViewController.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit


class CTAppRootViewController: UIViewController {

	@IBOutlet weak var centerInfoLabel: UILabel!
	var centralContainerViewController:CTCentralContainerViewController!

	var appDataState:AppDataState {
		didSet{
			if oldValue != appDataState {
				self.changeAppUIState()
			}
		}
	}

	init(appDataState:AppDataState) {
		self.appDataState = appDataState
		super.init(nibName: "CTAppRootViewController", bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
		changeAppUIState()
    }

	private func setupUI() {
		view.backgroundColor = UIColor(red: 0, green: 119/255, blue: 189/255, alpha: 1.0)
		centerInfoLabel.textColor = UIColor.white
		centerInfoLabel.font = CTFont.systemFont(ofSize: 18, weight: .Bold)
		centerInfoLabel.text = "Calendar Test"
	}

	private func showMessage(message:String) {
		centerInfoLabel.text = message
	}

	private func showError(errorText:String, errorTitle:String) {
		let alert = UIAlertController(title: errorTitle, message: errorText, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
		present(alert, animated: true, completion: nil)
	}

	private func showCenterContainer() {
		centralContainerViewController = CTCentralContainerViewController()
		centralContainerViewController?.modalTransitionStyle = .crossDissolve
		present(self.centralContainerViewController, animated: true, completion: nil)
	}

	private func changeAppUIState() {
		switch self.appDataState {
		case .creatingDummyData:
			showMessage(message: "Just a sec.\n Creating static app data...")
		case .finishedDummyDataCreation:
			showCenterContainer()
		case .creatingDummyAppDataFailed:
			showError(errorText: "Dummy data creation failed.\n Please try reinstalling app", errorTitle: "Oops!")
		case .intialization:
			showMessage(message: "Calendar Test")
		case .persistentStoreFailed:
			showMessage(message: "Calendar Test")
			showError(errorText: "App data creation failed.\n Please try reinstalling app", errorTitle: "Oops!")
		}
	}

}
