//
//  UIWindow+Presentable.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-09-11.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import RxSwift
import UIKit

extension UIWindow: Presentable {

    /// Rx Observable (Single trait) triggered when this UIWindow is displayed for the first time
    public var rxFirstTimeVisible: Single<Void> {
        return self.rx.windowDidAppear
    }

    /// Rx Observable that triggers a bool indicating if the current UIWindow is being displayed
    public var rxVisible: Observable<Bool> {
        return self.rx.windowDidAppear.asObservable().map { true }
    }

    /// Rx Observable (Single trait) triggered when this UIWindow is dismissed
    public var rxDismissed: Single<Void> {
        return Single.never()
    }

}
