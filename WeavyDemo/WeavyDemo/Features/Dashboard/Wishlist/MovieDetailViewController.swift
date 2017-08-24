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

class MovieDetailViewController: UIViewController, StoryboardBased, Weftable {

    @IBOutlet weak var castButton: UIButton!
    @IBOutlet weak var castButton2: UIButton!
    @IBOutlet weak var castButton3: UIButton!
    @IBOutlet weak var castButton4: UIButton!
    @IBOutlet weak var castButton5: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        var buttonObservables = [Observable<Void>]()
        buttonObservables.append(castButton.rx.tap.asObservable())
        buttonObservables.append(castButton2.rx.tap.asObservable())
        buttonObservables.append(castButton3.rx.tap.asObservable())
        buttonObservables.append(castButton4.rx.tap.asObservable())
        buttonObservables.append(castButton5.rx.tap.asObservable())

        Observable.merge(buttonObservables).subscribe(onNext: { [unowned self] (_) in
            self.weftSubject.onNext(DemoWeft.castPicked(withId: 1))
        }).disposed(by: self.disposeBag)
    }

}
