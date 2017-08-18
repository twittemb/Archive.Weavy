//
//  Warp.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-23.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation

public protocol Warp: Presentable {

    var initialWeft: Weft { get }
    var woolBag: WoolBag { get set }

    func knit (withWeft weft: Weft,
               usingWoolBag woolBag: WoolBag) -> Stitch

}
