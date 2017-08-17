//
//  Weft.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-23.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation


/// a Weft describes a possible state of navigation
public protocol Weft {
}

extension Weft {

    /// the type of the object that implements the Weft protocol
    var type: Weft.Type {
        return type(of: self)
    }

    /// An empty Weft that is used in the internal weaving process to Drive the navigation without Error
    var voidWeft: Weft {
        return VoidWeft()
    }
}

/// An empty Weft that is used in the internal weaving process to Drive the navigation without Error
struct VoidWeft: Weft {
}
