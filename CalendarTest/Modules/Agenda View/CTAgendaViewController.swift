//
//  CTAgendaViewController.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

protocol CTAgendaViewControllerProtocol:NSObjectProtocol {

}

class CTAgendaViewController: UIViewController {

	@IBOutlet weak var agendaTableView: UITableView!
	weak var delegate:CTAgendaViewControllerProtocol?
	let listUIHelper = CTAgendaListUIHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
		listUIHelper.registerCells(inTableView: agendaTableView)
		loadEventForFirstLaunch()
    }

	private func loadEventForFirstLaunch() {
		listUIHelper.loadOnFirstLaunch { (error) in
			guard error == nil
				else{
					return
			}
			runInMainQueue {
				self.agendaTableView.reloadData()
			}
		}
	}

}

extension CTAgendaViewController:UITableViewDelegate {

}

extension CTAgendaViewController:UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return self.listUIHelper.numberOfSections()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.listUIHelper.numberOfRowsInSection(section: section)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return self.listUIHelper.cellForRow(indexPath: indexPath, inTableView: tableView)
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.listUIHelper.heightForRow(atIndexPath: indexPath)
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return self.listUIHelper.sectionHeaderFor(forSection: section, inTabelView: tableView)
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}

	
}
