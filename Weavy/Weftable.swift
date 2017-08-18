//
//  Weftable.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-25.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import RxSwift

public protocol Weftable: class {
    var weft: Observable<Weft> { get }
}
