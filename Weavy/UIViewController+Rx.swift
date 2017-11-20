//
//  File.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-29.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {

    /// Rx observable, triggered when the view has appeared for the first time
    public var firstTimeViewDidAppear: Single<Void> {
        return self.sentMessage(#selector(Base.viewDidAppear)).map { _ in return Void() }.take(1).asSingle()
    }

    /// Rx observable, triggered when the view is being dismissed
    public var dismissed: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.dismiss)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    /// Rx observable, triggered when the view appearance state changes
    public var displayed: Observable<Bool> {
        let viewDidAppearObservable = self.sentMessage(#selector(Base.viewDidAppear)).map { _ in true }
        let viewWillDisappearObservable = self.sentMessage(#selector(Base.viewWillDisappear)).map { _ in false }
        return Observable<Bool>.merge(viewDidAppearObservable, viewWillDisappearObservable)
    }
}
