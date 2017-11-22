//
//  Weftable.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-25.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import RxSwift

private var subjectContext: UInt8 = 0

/// a Weftable has only one purpose: emit Wefts that correspond to specific navigation states.
/// The state changes lead to navigation actions in the context of a specific Warp
public protocol Weftable: Synchronizable {

    /// the Rx Obsersable that will trigger new Wefts
    var weft: Observable<Weft> { get }
}

/// A Simple Weftable that has one goal: emit a single Weft once initialized
public class SingleWeftable: Weftable {

    /// Initialise the SingleWeftable
    ///
    /// - Parameter initialWeft: the weft to be emitted once initialized
    public init(withInitialWeft initialWeft: Weft) {
        self.weftSubject.onNext(initialWeft)
    }
}

/// a void Weftable that triggers VoidWefts.
class VoidWeftable: SingleWeftable {
    convenience init() {
        self.init(withInitialWeft: VoidWeft())
    }
}

public extension Weftable {

    /// The weftSubject in which to publish new Wefts
    public var weftSubject: BehaviorSubject<Weft> {
        return self.synchronized {
            if let subject = objc_getAssociatedObject(self, &subjectContext) as? BehaviorSubject<Weft> {
                return subject
            }
            let newSubject = BehaviorSubject<Weft>(value: VoidWeft())
            objc_setAssociatedObject(self, &subjectContext, newSubject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newSubject
        }
    }

    /// the Rx Obsersable that will trigger new Wefts
    public var weft: Observable<Weft> {
        return self.weftSubject.asObservable()
    }
}
