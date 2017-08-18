//
//  OnboardingWeftable.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-07-27.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import RxSwift
import Weavy

class OnboardingWeftable: Weftable {

    let disposeBag = DisposeBag()

    private let weftSubject = BehaviorSubject<Weft>(value: DemoWeft.needToOnboard)
    lazy var weft: Observable<Weft> = {
        return self.weftSubject.asObservable()
    }()

    init() {
    }

}
