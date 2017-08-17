//
//  WoolBag.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-08-12.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation

/// a WoolBag is a Bag that is used in a Warp for dependency Injection
public protocol WoolBag {
}

extension WoolBag {

    /// the type of the object that implements the WoolBag protocol
    var type: WoolBag.Type {
        return type(of: self)
    }
}
