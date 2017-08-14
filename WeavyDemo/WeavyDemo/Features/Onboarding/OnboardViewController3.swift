//
//  DashboardViewController2.swift
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

class OnboardViewController3: UIViewController, StoryboardBased, Weftable {

    @IBOutlet weak var finishOnboardingButton: UIButton!

    private let weftSubject = PublishSubject<Weft>()
    lazy var weft: Observable<Weft> = {
        return self.weftSubject.asObservable()
    }()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.finishOnboardingButton.rx.tap.subscribe(onNext: { [unowned self] (_) in
            self.weftSubject.onNext(DemoWeft.loginComplete)
        }).disposed(by: self.disposeBag)
    }

    deinit {
        print ("--->>> \(self) DEALLOCATING")
    }

}
