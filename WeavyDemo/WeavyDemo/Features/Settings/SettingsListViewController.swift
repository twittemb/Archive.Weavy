//
//  SettingsListViewController.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-11-13.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import UIKit
import Reusable
import Weavy

class SettingsListViewController: UITableViewController, StoryboardBased, Weftable {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.selectRow(at: IndexPath(row: 0, section: 0),
                                 animated: false,
                                 scrollPosition: UITableViewScrollPosition.none)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.weftSubject.onNext(DemoWeft.apiKey)
        case 1:
            self.weftSubject.onNext(DemoWeft.about)
        default:
            return
        }
    }

}
