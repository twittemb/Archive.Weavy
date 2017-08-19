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
