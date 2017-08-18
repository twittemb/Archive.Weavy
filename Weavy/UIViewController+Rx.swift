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
    public var viewDidLoad: ControlEvent<Void> {
        let source = self.sentMessage(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }

    public var viewWillAppear: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    public var viewDidAppear: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    public var firstTimeViewDidAppear: Single<Bool> {
        return self.sentMessage(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }.take(1).asSingle()
    }

    public var viewWillDisappear: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    public var viewDidDisappear: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    public var viewWillLayoutSubviews: ControlEvent<Void> {
        let source = self.sentMessage(#selector(Base.viewWillLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }
    public var viewDidLayoutSubviews: ControlEvent<Void> {
        let source = self.sentMessage(#selector(Base.viewDidLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }

    public var willMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.sentMessage(#selector(Base.willMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }

    public var didMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.sentMessage(#selector(Base.didMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }

    public var didReceiveMemoryWarning: ControlEvent<Void> {
        let source = self.sentMessage(#selector(Base.didReceiveMemoryWarning)).map { _ in }
        return ControlEvent(events: source)
    }

    public var dismiss: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.dismiss)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    public var dismissInHierarchy: Observable<Void> {
        var sources = [Observable<Void>]()

        sources.append(self.base.rx.dismiss.map { _ in return Void() })
        sources.append(self.base.rx.didMoveToParentViewController.filter { $0 == nil }.map { _ in return Void() })

        if let parent = self.base.parent {
            sources.append(parent.rx.dismiss.map { _ in return Void() })
            sources.append(parent.rx.didMoveToParentViewController.filter { $0 == nil }.map { _ in return Void() })
        }

        return Observable.merge(sources)
    }

    public var displayed: Observable<Bool> {
        let viewDidAppearObservable = self.base.rx.viewDidAppear.map { _ in true }
        let viewWillDisappearObservable = self.base.rx.viewWillDisappear.map { _ in false }
        return Observable<Bool>.merge(viewDidAppearObservable, viewWillDisappearObservable)
    }
}
