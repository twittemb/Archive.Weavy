//
//  Synchronizable.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-11-07.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation

/// Provides a function to prevent concurrent block execution
public protocol Synchronizable: class {
}

extension Synchronizable {
    func synchronized<T>( _ action: () -> T) -> T {
        objc_sync_enter(self)
        let result = action()
        objc_sync_exit(self)
        return result
    }
}
