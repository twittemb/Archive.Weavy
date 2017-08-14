//
//  Pattern.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-08-09.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import RxSwift

public protocol Patternable: class, Presentable {

    var initialWarp: Warp { get }
    var initialWeft: Weft { get }
    var woolBag: WoolBag { get set }

    func knit (fromWarp warp: Warp,
               fromWeft weft: Weft,
               withWoolBag woolBag: WoolBag) -> Stitch
}
