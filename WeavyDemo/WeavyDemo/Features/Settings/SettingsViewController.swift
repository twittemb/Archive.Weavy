//
//  DashboardViewController1.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-07-26.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import UIKit
import Reusable
import Weavy
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController, StoryboardBased, Weftable {

    @IBOutlet weak var proceedButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.proceedButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.weftSubject.onNext(DemoWeft.apiKeyIsComplete)
        }).disposed(by: self.disposeBag)

    }

}
