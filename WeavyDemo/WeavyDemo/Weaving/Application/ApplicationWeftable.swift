//
//  ApplicationWeftable.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-07-26.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import RxSwift
import Weavy

class ApplicationWeftable: Weftable {

    let disposeBag = DisposeBag()

    private let weftSubject = BehaviorSubject<Weft>(value: DemoWeft.needTheDashboard)
    lazy var weft: Observable<Weft> = {
        return self.weftSubject.asObservable()
    }()

    init() {
        self.weftSubject.onNext(DemoWeft.needTheDashboard)

        Observable<Int>.interval(10, scheduler: MainScheduler.instance).subscribe(onNext: { (_) in
            // for the purpose of the example, want to login every 10s
            self.weftSubject.onNext(DemoWeft.needToLogin)
        }).disposed(by: self.disposeBag)
    }

}
