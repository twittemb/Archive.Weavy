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

class DashboardViewController1: UIViewController, StoryboardBased, Weftable {

    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var onBoardingButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    private let weftSubject = PublishSubject<Weft>()
    lazy var weft: Observable<Weft> = {
        return self.weftSubject.asObservable()
    }()

    let disposeBag = DisposeBag()
    var applicationWoolBag: ApplicationWoolBag!

    static func instantiate (withApplicationWoolBag applicationWoolBag: ApplicationWoolBag) -> DashboardViewController1 {
        let viewController = DashboardViewController1.instantiate()
        viewController.applicationWoolBag = applicationWoolBag
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // use the ApplicationWoolBag
        self.applicationWoolBag.describe()

        // Do any additional setup after loading the view.
        self.actionButton.rx.tap.subscribe(onNext: { [unowned self] (_) in
            self.weftSubject.onNext(DemoWeft.needTheMovieDetail(withMovieTitle: "First Contact"))
        }).disposed(by: self.disposeBag)

        self.onBoardingButton.rx.tap.subscribe(onNext: { [unowned self] (_) in
            self.weftSubject.onNext(DemoWeft.needToOnboard)
        }).disposed(by: self.disposeBag)

        self.loginButton.rx.tap.subscribe(onNext: { [unowned self] (_) in
            self.weftSubject.onNext(DemoWeft.needToLogin)
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
