//
//  Weftable.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-25.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import RxSwift

/// a Weftable has only one purpose: emit Wefts that correspond that specific navigation states.
/// the state changes lead to navigation actions in the context of a specific Warp
public protocol Weftable: class {

    /// the Rx Obsersable that will trigger new Wefts
    var weft: Observable<Weft> { get }
}

/// a void Weftable that triggers VoidWefts.
class VoidWeftable: Weftable {
    let weft: Observable<Weft> = Observable<Weft>.just(VoidWeft())
}
