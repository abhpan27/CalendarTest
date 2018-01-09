//
//  CTCentralContainerViewController.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class CTCentralContainerViewController: UIViewController {

	let topBar:CTTopBarOnCentralView
	let calendarViewController:CTCalendarViewController

	init(minimumCalData:[[CTCellUIData]], minimumAgendaViewData:[CTAgendaViewRowUIData]) {
		self.topBar = CTTopBarOnCentralView()
		self.calendarViewController = CTCalendarViewController(minimumCalData: minimumCalData)
		super.init(nibName: "CTCentralContainerViewController", bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		addAndLayoutViews()
    }

	private func addAndLayoutViews() {
		addAndLayoutTopBar()
		addAndLayoutCalendarView()
	}
}
