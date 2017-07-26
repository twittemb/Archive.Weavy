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

class DashboardViewController2: UIViewController, StoryboardBased, Weftable {

    @IBOutlet weak var settingsButton: UIButton!

    private let weftSubject = PublishSubject<Weft>()
    lazy var weft: Observable<Weft> = {
        return self.weftSubject.asObservable()
    }()

    let disposeBag = DisposeBag()

    var movieTitle: String? {
        didSet {
            self.title = movieTitle
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.settingsButton.rx.tap.subscribe(onNext: { [unowned self] (_) in
            self.weftSubject.onNext(DemoWeft.needTheSettings)
        }).disposed(by: self.disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print ("--->>> VIEW \(self) WILL APPEAR")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        print ("--->>> VIEW \(self) WILL DISAPPEAR")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print ("--->>> VIEW \(self) DID APPEAR")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        print ("--->>> VIEW \(self) DID DISAPPEAR")
    }

    deinit {
        print ("--->>> \(self) DEALLOCATING")
    }

}
