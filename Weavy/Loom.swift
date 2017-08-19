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

/// the only purpose of a Loom is to handle the navigation that is
/// declared in the Warps of the application. It begins to weave on the root Window
/// and then produces UIViewControllers as the Stitches are triggered all along the way
public class Loom {

    private var window: UIWindow!
    private let disposeBag = DisposeBag()
    private let stitches = PublishSubject<(Warp, Stitch)>()
    private var presentingViewController: UIViewController?

    /// instantiate the Loom. It only needs the root window of the application
    ///
    /// - Parameter window: the root window of the application. it is avalaible in the AppDelegate for instance.
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
                            .asDriver(onErrorJustReturn: VoidWeft()).drive(onNext: { [unowned self] (weft) in
                                self.weave(withWarp: warp, withWeft: weft)
                            }).disposed(by: presentable.rxDisposeBag)
                    }).disposed(by: self.disposeBag)
                }

                self.present(viewController: presentable, withPresentationStyle: stitch.presentationStyle)

            }

        }).disposed(by: self.disposeBag)
    }

    /// this function receives the bootstrap Stitch of the application and start the weaving process
    ///
    /// - Parameters:
    ///   - stitch: the bootstrap Stitch of the application. It must be a direct link to a whole Warp with a Weftable that has to trigger the first Weft of the Warp
    public func weave (withStitch stitch: Stitch) {
        self.weave(withStitch: stitch, withPresentationStyle: nil)
    }

    private func weave (withStitch stitch: Stitch, withPresentationStyle presentationStyle: PresentationStyle? = nil) {
        if  let stitchWarp = stitch.linkedWarp,
            let stitchWeftable = stitch.weftable {
            self.weave(withWarp: stitchWarp, withWeftable: stitchWeftable, withPresentationStyle: presentationStyle)
        } else {
            fatalError("The Stitch passed to this function must present a Warp with a valid Weft in order to bootstrap a proper navigation")
        }
    }

    private func weave (withWarp warp: Warp, withWeftable weftable: Weftable, withPresentationStyle presentationStyle: PresentationStyle? = nil) {
        // we are weaving a new Warp. We listen to the associated Weftable. This Weftable will give us the first Weft and then eventualy
        // other Weft that will trigger navigation actions such as popup windows for instance
        weftable.weft.asDriver(onErrorJustReturn: VoidWeft()).drive(onNext: { [unowned warp, unowned self] (weft) in
            self.weave(withWarp: warp, withWeft: weft, withPresentationStyle: presentationStyle)
        }).disposed(by: warp.rxDisposeBag)
    }

    private func weave (withWarp warp: Warp, withWeft weft: Weft, withPresentationStyle presentationStyle: PresentationStyle? = nil) {
        // find the stitch according to the warp and weft we are processing
        var stitch = warp.knit(withWeft: weft, usingWoolBag: warp.woolBag)

        // if we have a forcedPresentationStyle, it means that we come (previous recursive call) from a Stitch that is
        // a redirection to another Warp ... this is the original stitch PresentationStyle that really matters
        if let forcedPresentationStyle = presentationStyle {
            stitch.presentationStyle = forcedPresentationStyle
        }

        if stitch.linkedWarp != nil {
            // stitch presentable can be a "link" to a another warp
            self.weave(withStitch: stitch, withPresentationStyle: stitch.presentationStyle)
        } else {
            // stitch presentable is a UIViewController to present
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

// TODO
//extension Loom {
//    //swiftlint:disable:next identifier_name
//    public var rx: Reactive<Loom> {
//        return Reactive<Loom>(self)
//    }
//}
//
//extension Reactive where Base: Loom {
//    public var willNavigate: ControlEvent<(toViewController: UIViewController?, withPresentationStyle: PresentationStyle?)> {
//        let source = self.methodInvoked(#selector(Base.willNavigate)).map { (args) -> (toViewController: UIViewController?, withPresentationStyle: PresentationStyle?) in
//            if  let viewController = args[0] as? UIViewController,
//                let presentationStyle = args[1] as? String {
//                return (viewController, PresentationStyle.fromRaw(raw: presentationStyle))
//            }
//            return (nil, nil)
//        }
//        return ControlEvent(events: source)
//    }
//
//    public var didNavigate: ControlEvent<(toViewController: UIViewController?, withPresentationStyle: PresentationStyle?)> {
//        let source = self.methodInvoked(#selector(Base.didNavigate)).map { (args) -> (toViewController: UIViewController?, withPresentationStyle: PresentationStyle?) in
//            if  let viewController = args[0] as? UIViewController,
//                let presentationStyle = args[1] as? String {
//                return (viewController, PresentationStyle.fromRaw(raw: presentationStyle))
//            }
//            return (nil, nil)
//        }
//        return ControlEvent(events: source)
//    }
//}
