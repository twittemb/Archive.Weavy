//
//  WoolBag.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-08-12.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation

public protocol WoolBag {
}

extension WoolBag {
    var type: WoolBag.Type {
        return type(of: self)
    }
}
