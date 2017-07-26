//
//  Warp.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-23.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation

public protocol Warp: Presentable {
}

extension Warp {
    var type: Warp.Type {
        return type(of: self)
    }
}
