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

    /// Rx observable, triggered when the view has loaded
    public var viewDidLoad: ControlEvent<Void> {
        let source = self.sentMessage(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }

    /// Rx observable, triggered when the view will appear
    public var viewWillAppear: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    /// Rx observable, triggered when the view has appeared
    public var viewDidAppear: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    /// Rx observable, triggered when the view has appeared for the first time
    public var firstTimeViewDidAppear: Single<Bool> {
        return self.sentMessage(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }.take(1).asSingle()
    }

    /// Rx observable, triggered when the view will disappear
    public var viewWillDisappear: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    /// Rx observable, triggered when the view has disappeared
    public var viewDidDisappear: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    /// Rx observable, triggered when the view will layout its subviews
    public var viewWillLayoutSubviews: ControlEvent<Void> {
        let source = self.sentMessage(#selector(Base.viewWillLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }

    /// Rx observable, triggered when the view did layout its subviews
    public var viewDidLayoutSubviews: ControlEvent<Void> {
        let source = self.sentMessage(#selector(Base.viewDidLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }

    /// Rx observable, triggered when the view will move to a parent ViewController
    public var willMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.sentMessage(#selector(Base.willMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }

    /// Rx observable, triggered when the view has moved to a parent ViewController
    public var didMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.sentMessage(#selector(Base.didMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }

    /// Rx observable, triggered when the view has received a memory warning
    public var didReceiveMemoryWarning: ControlEvent<Void> {
        let source = self.sentMessage(#selector(Base.didReceiveMemoryWarning)).map { _ in }
        return ControlEvent(events: source)
    }

    /// Rx observable, triggered when the view is being dismissed
    public var dismissed: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.dismiss)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    /// Rx observable, triggered when the view or its parent view is being dismissed
    public var dismissedInHierarchy: Observable<Void> {
        var sources = [Observable<Void>]()

        sources.append(self.base.rx.dismissed.map { _ in return Void() })
        sources.append(self.base.rx.willMoveToParentViewController.filter { $0 == nil }.map { _ in return Void() })

        if let parent = self.base.parent {
            sources.append(parent.rx.dismissed.map { _ in return Void() })
            sources.append(parent.rx.willMoveToParentViewController.filter { $0 == nil }.map { _ in return Void() })
        }

        return Observable.merge(sources)
    }

    /// Rx observable, triggered when the view appearance state changes
    public var displayed: Observable<Bool> {
        let viewDidAppearObservable = self.base.rx.viewDidAppear.map { _ in true }
        let viewWillDisappearObservable = self.base.rx.viewWillDisappear.map { _ in false }
        return Observable<Bool>.merge(viewDidAppearObservable, viewWillDisappearObservable)
    }
}
