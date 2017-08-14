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

class OnboardViewController2: UIViewController, StoryboardBased, Weftable {

    @IBOutlet weak var toLoginButton: UIButton!

    private let weftSubject = PublishSubject<Weft>()
    lazy var weft: Observable<Weft> = {
        return self.weftSubject.asObservable()
    }()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.toLoginButton.rx.tap.subscribe(onNext: { [unowned self] (_) in
            self.weftSubject.onNext(DemoWeft.serverComplete)
        }).disposed(by: self.disposeBag)
    }

    deinit {
        print ("--->>> \(self) DEALLOCATING")
    }

}
