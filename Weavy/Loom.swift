//
//  Loom.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-25.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

public class Loom {

    private var window: UIWindow!
    private let disposeBag = DisposeBag()
    private let stitches = PublishSubject<(Warp, Stitch)>()
    private var presentingViewController: UIViewController?

    required public init (fromRootWindow window: UIWindow) {

        self.window = window

        self.stitches.subscribe(onNext: { [unowned self] (warp, stitch) in

            if stitch.presentationStyle == .dismiss {
                self.presentingViewController = self.presentingViewController?.presentingViewController
                self.presentingViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
                return
            }

            if let presentable = stitch.presentable as? UIViewController {

                if let weftable = stitch.weftable {

                    presentable.rx.firstTimeViewDidAppear.subscribe(onSuccess: { [unowned self, unowned presentable] (_) in

                        weftable.weft
                            .pausable(presentable.rx.displayed.startWith(true))
                            .takeUntil(presentable.rx.dismissInHierarchy)
                            .asDriver(onErrorJustReturn: warp.initialWeft).drive(onNext: { [unowned self] (weft) in
                                self.weave(withWarp: warp, withWeft: weft)
                            }).disposed(by: self.disposeBag)
                    }).disposed(by: self.disposeBag)
                }

                self.present(viewController: presentable, withPresentationStyle: stitch.presentationStyle)

            }

        }).disposed(by: self.disposeBag)
    }

    public func weave (withWarp warp: Warp) {
        self.weave(withWarp: warp, withWeft: warp.initialWeft)
    }

    private func weave (withWarp warp: Warp, withWeft weft: Weft, withPresentationStyle presentationStyle: PresentationStyle? = nil) {
        // find the stitch according to the warp and weft we are processing
        var stitch = warp.knit(withWeft: weft, usingWoolBag: warp.woolBag)

        // if we have a forcedPresentationStyle, it means that we come (previous recursive call) from a Stitch that is
        // a redirection to another Warp ... this is the original stitch PresentationStyle that really matters
        if let forcedPresentationStyle = presentationStyle {
            stitch.presentationStyle = forcedPresentationStyle
        }

        if let linkedWarp = stitch.linkedWarp {
            // stitch can be a "link" to a another warp
            self.weave(withWarp: linkedWarp, withWeft: linkedWarp.initialWeft, withPresentationStyle: stitch.presentationStyle)
        } else {
            // stitch is a UIViewController to present
            self.stitches.onNext((warp, stitch))
        }
    }

    private func present (viewController: UIViewController, withPresentationStyle presentationStyle: PresentationStyle) {
        self.willNavigate(to: viewController, withPresentationStyle: presentationStyle.rawValue)

        switch presentationStyle {
        case .root:
            self.window.rootViewController = viewController
            self.presentingViewController = viewController
            break
        case .show:
            self.presentingViewController?.show(viewController, sender: nil)
            self.didNavigate(to: viewController, withPresentationStyle: presentationStyle.rawValue)
            break
        case .popup:
            // if uncomment viewDidDisappear event won't be triggered anymore for popup presenting VCs
            // and pausable mecanism won't work anymore
            //                    presentable.modalPresentationStyle = .overFullScreen
            //                    presentable.modalTransitionStyle = .coverVertical
            self.presentingViewController?.present(viewController, animated: true, completion: { [unowned self, unowned viewController] in
                self.didNavigate(to: viewController, withPresentationStyle: presentationStyle.rawValue)
            })
            self.presentingViewController = viewController
            break
        default:
            break
        }
    }

    @objc func willNavigate (to viewController: UIViewController, withPresentationStyle presentationStyle: String) {
        // just to observe this func for Reactive extension
    }

    @objc func didNavigate (to viewController: UIViewController, withPresentationStyle presentationStyle: String) {
        // just to observe this func for Reactive extension
    }
}

extension Loom {
    //swiftlint:disable:next identifier_name
    public var rx: Reactive<Loom> {
        return Reactive<Loom>(self)
    }
}

extension Reactive where Base: Loom {
    public var willNavigate: ControlEvent<(toViewController: UIViewController?, withPresentationStyle: PresentationStyle?)> {
        let source = self.methodInvoked(#selector(Base.willNavigate)).map { (args) -> (toViewController: UIViewController?, withPresentationStyle: PresentationStyle?) in
            if  let viewController = args[0] as? UIViewController,
                let presentationStyle = args[1] as? String {
                return (viewController, PresentationStyle.fromRaw(raw: presentationStyle))
            }
            return (nil, nil)
        }
        return ControlEvent(events: source)
    }

    public var didNavigate: ControlEvent<(toViewController: UIViewController?, withPresentationStyle: PresentationStyle?)> {
        let source = self.methodInvoked(#selector(Base.didNavigate)).map { (args) -> (toViewController: UIViewController?, withPresentationStyle: PresentationStyle?) in
            if  let viewController = args[0] as? UIViewController,
                let presentationStyle = args[1] as? String {
                return (viewController, PresentationStyle.fromRaw(raw: presentationStyle))
            }
            return (nil, nil)
        }
        return ControlEvent(events: source)
    }
}
