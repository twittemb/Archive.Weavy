//
//  Warp.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-23.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

private var subjectContext: UInt8 = 0

/// A Warp defines a clear navigation area. Combined to a Weft it leads to a navigation action
public protocol Warp: Presentable {

    /// Resolves Stitches according to the Weft, in the context of this very Warp
    ///
    /// - Parameters:
    ///   - weft: the weft emitted by one of the weftables declared in the Warp
    /// - Returns: the stitches matching the weft. This stitches determines the next navigation steps (Presentables to display / Weftables to listen)
    func knit (withWeft weft: Weft) -> [Stitch]

    /// the UIViewController on which rely the navigation inside this Warp. This method must always give the same instance
    var head: UIViewController { get }
}

extension Warp {

    /// Rx Observable that triggers a bool indicating if the current Warp is being displayed
    public var rxVisible: Observable<Bool> {
        return self.head.rxVisible
    }

    /// Rx Observable (Single trait) triggered when this Warp is displayed for the first time
    public var rxFirstTimeVisible: Single<Void> {
        return self.head.rxFirstTimeVisible
    }

    /// Rx Observable (Single trait) triggered when this Warp is dismissed
    public var rxDismissed: Single<Void> {
        return self.head.rxDismissed
    }

    /// Inner/hidden Rx Subject in which we push the "Ready" event
    var warpReadySubject: PublishSubject<Bool> {
        return self.synchronized {
            if let subject = objc_getAssociatedObject(self, &subjectContext) as? PublishSubject<Bool> {
                return subject
            }
            let newSubject = PublishSubject<Bool>()
            objc_setAssociatedObject(self, &subjectContext, newSubject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newSubject
        }

    }

    /// the Rx Obsersable that will be triggered when the first presentable of the warp is ready to be used
    var rxWarpReady: Single<Bool> {
        return self.warpReadySubject.take(1).asSingle()
    }

}

/// Utility functions to synchronize Warp readyness
public class Warps {

    // swiftlint:disable line_length
    /// Allow to be triggered only when Warps given as parameters are ready to be displayed.
    /// Once it is the case, the block is executed
    ///
    /// - Parameters:
    ///   - warp1: first warp to be observed
    ///   - warp2: second warp to be observed
    ///   - warp3: third warp to be observed
    ///   - block: block to execute whenever the warps are ready to use
    public static func whenReady<HeadType1: UIViewController, HeadType2: UIViewController, HeadType3: UIViewController> (warp1: Warp,
                                                                                                                         warp2: Warp,
                                                                                                                         warp3: Warp,
                                                                                                                         block: @escaping (_ warp1Head: HeadType1, _ warp2Head: HeadType2, _ warp3Head: HeadType3) -> Void) {
        _ = Observable<Void>.zip(warp1.rxWarpReady.asObservable(), warp2.rxWarpReady.asObservable(), warp3.rxWarpReady.asObservable()) { (_, _, _) in
            return Void()
            }.take(1).subscribe(onNext: { (_) in
                guard   let head1 = warp1.head as? HeadType1,
                    let head2 = warp2.head as? HeadType2,
                    let head3 = warp3.head as? HeadType3 else {
                        fatalError ("Type mismatch, Warps head types do not match the types awaited in the block")
                }
                block(head1, head2, head3)
            })
    }
    // swiftlint:enable line_length

    /// Allow to be triggered only when Warps given as parameters are ready to be displayed.
    /// Once it is the case, the block is executed
    ///
    /// - Parameters:
    ///   - warp1: first warp to be observed
    ///   - warp2: second warp to be observed
    ///   - block: block to execute whenever the warps are ready to use
    public static func whenReady<HeadType1: UIViewController, HeadType2: UIViewController> (warp1: Warp,
                                                                                            warp2: Warp,
                                                                                            block: @escaping (_ warp1Head: HeadType1, _ warp2Head: HeadType2) -> Void) {
        _ = Observable<Void>.zip(warp1.rxWarpReady.asObservable(), warp2.rxWarpReady.asObservable()) { (_, _) in
            return Void()
            }.take(1).subscribe(onNext: { (_) in
                guard   let head1 = warp1.head as? HeadType1,
                    let head2 = warp2.head as? HeadType2 else {
                        fatalError ("Type mismatch, Warps head types do not match the types awaited in the block")
                }
                block(head1, head2)
            })
    }

    /// Allow to be triggered only when Warp given as parameters are ready to be displayed.
    /// Once it is the case, the block is executed
    ///
    /// - Parameters:
    ///   - warp1: warp to be observed
    ///   - block: block to execute whenever the warps are ready to use
    public static func whenReady<HeadType: UIViewController> (warp: Warp, block: @escaping (_ warpHead: HeadType) -> Void) {
        _ = warp.rxWarpReady.subscribe(onSuccess: { (_) in
            guard let head = warp.head as? HeadType else {
                fatalError ("Type mismatch, Warp head type do not match the type awaited in the block")
            }
            block(head)
        })
    }
}
