//
//  Weft.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-23.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation

public protocol Weft {
}

extension Weft {
    var type: Weft.Type {
        return type(of: self)
    }
}
