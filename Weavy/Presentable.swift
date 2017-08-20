//
//  Presentable.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-25.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import RxSwift
import ObjectiveC

/// an abstraction of what can present a Loom. For now, UIViewControllers and Warps are Presentable
public protocol Presentable {
    var rxDisplayed: Observable<Bool> { get }
}

fileprivate struct AssociatedKeys {
    static var disposeBag = "rx_disposeBag"
}

extension Presentable {

    func doLocked(_ closure: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        closure()
    }

    /// a default Rx Dispose Bag associated to the Presentable lifecycle.
    /// It allows to dispose weftable subscriptions when this Presentable is deallocated
    var rxDisposeBag: DisposeBag {
        var disposeBag: DisposeBag!
        doLocked {
            let lookup = objc_getAssociatedObject(self, &AssociatedKeys.disposeBag) as? DisposeBag
            if let lookup = lookup {
                disposeBag = lookup
            } else {
                let newDisposeBag = DisposeBag()
                doLocked {
                    objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, newDisposeBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
                disposeBag = newDisposeBag
            }
        }
        return disposeBag
    }
}
