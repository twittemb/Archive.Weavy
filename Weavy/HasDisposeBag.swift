//
//  DisposeBagable.swift
//  NSObject-Rx
//
//  Created by Thibault Wittemberg on 2017-08-25.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import Foundation
import RxSwift
import ObjectiveC

fileprivate var disposeBagContext: UInt8 = 0

/// Each HasDisposeBag offers a unique Rx DisposeBag instance
public protocol HasDisposeBag: Synchronizable {

    /// a unique Rx DisposeBag instance
    var disposeBag: DisposeBag { get }
}

extension HasDisposeBag {

    /// The concrete DisposeBag instance
    public var disposeBag: DisposeBag {
        return self.synchronized {
            if let disposeObject = objc_getAssociatedObject(self, &disposeBagContext) as? DisposeBag {
                return disposeObject
            }
            let disposeObject = DisposeBag()
            objc_setAssociatedObject(self, &disposeBagContext, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return disposeObject
        }
    }
}
