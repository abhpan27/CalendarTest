//
//  CTAppRootViewController.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This class is parent of all the UI elements created in app. Based on app states this class loads different UI elements.(view controller and views)
*/
class CTAppRootViewController: UIViewController {

	///Outlet to label drawn in center of screen. This label is used to show different feedback to user untill calendar and agenda view is loaded.
	@IBOutlet weak var centerInfoLabel: UILabel!

	///Container of calendar view and agenda view.
	var centralContainerViewController:CTCentralContainerViewController!

	//local app state, on change of app state, UI is updated
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

	/**
	Sets view's background color and centerInfoLabel's font and color
	*/
	private func setupUI() {
		view.backgroundColor = UIColor(red: 0, green: 119/255, blue: 189/255, alpha: 1.0)
		centerInfoLabel.textColor = UIColor.white
		centerInfoLabel.font = CTFont.systemFont(ofSize: 18, weight: .Bold)
		centerInfoLabel.text = "Calendar Test"
	}

	/**
	Shows message in center of screen.
	 - Parameter message: Message to show.
	*/
	private func showMessage(message:String) {
		centerInfoLabel.text = message
	}

	/**
	Shows Error in alert control.
	- Parameter errorText: Subtitle for alert.
	- Parameter errorTitle: title for alert.
	*/
	private func showError(errorText:String, errorTitle:String) {
		let alert = UIAlertController(title: errorTitle, message: errorText, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
		present(alert, animated: true, completion: nil)
	}

	/**
	Loads central container. Which will contain calendar view, aganeda view and top bar.
	*/
	private func showCenterContainer() {
		centralContainerViewController = CTCentralContainerViewController()
		centralContainerViewController?.modalTransitionStyle = .crossDissolve
		present(self.centralContainerViewController, animated: true, completion: nil)
	}

	/**
	Updates UI for reflecting current app state. This methods can be used to intiate different kind of UI flow. Like onboaring flow, error resolution flow etc. Currently it is limited to showing different kind of texts and launching container controller.
	*/
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
