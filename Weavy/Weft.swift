//
//  Weft.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-23.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation

/// A Weft describes a possible state of navigation
public protocol Weft {
}

/// An empty Weft used internally
struct VoidWeft: Weft {
}
