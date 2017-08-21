//
//  Warp.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-23.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import RxSwift

/// A Warp defines a clear navigation area. Combined to a Weft it leads to a navigation action
public protocol Warp: class, Presentable {

    /// The bag in which wy can store references to things we want to inject
    var woolBag: WoolBag? { get set }

    /// Resolves a Stitch according to the Weft, in the scope of this very Warp
    ///
    /// - Parameters:
    ///   - weft: the weft emitted by one of the weftables declared in the Warp
    ///   - woolBag: the bag provided by the variable "woolBag"
    /// - Returns: the stitch matching the weft. This stitch can present either a UIViewController or another Warp
    func knit (withWeft weft: Weft,
               usingWoolBag woolBag: WoolBag?) -> Stitch

}

fileprivate struct AssociatedKeys {
    static var displayedSubject = "rx_displayedSubject"
}

extension Warp {
    var displayedSubject: PublishSubject<Bool> {
        var subject: PublishSubject<Bool>!
        doLocked {
            let lookup = objc_getAssociatedObject(self, &AssociatedKeys.displayedSubject) as? PublishSubject<Bool>
            if let lookup = lookup {
                subject = lookup
            } else {
                let newSubject = PublishSubject<Bool>()
                doLocked {
                    objc_setAssociatedObject(self, &AssociatedKeys.displayedSubject, newSubject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
                subject = newSubject
            }
        }
        return subject
    }

    /// Rx Observable that triggers a bool indicating if the current Warp is being displayed (one of its UIViewControllers)
    public var rxDisplayed: Observable<Bool> {
        return self.displayedSubject.asObservable()
    }
}
