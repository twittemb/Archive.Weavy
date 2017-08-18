//
//  Stitch.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-23.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation

public enum PresentationStyle: String {
    case root
    case popup
    case show
    case dismiss

    static func fromRaw (raw: String) -> PresentationStyle? {
        switch raw {
        case PresentationStyle.root.rawValue:
            return PresentationStyle.root
        case PresentationStyle.popup.rawValue:
            return PresentationStyle.popup
        case PresentationStyle.show.rawValue:
            return PresentationStyle.show
        case PresentationStyle.dismiss.rawValue:
            return PresentationStyle.dismiss
        default:
            return nil
        }
    }
}

public struct Stitch {

    var presentationStyle: PresentationStyle
    let presentable: Presentable?
    let weftable: Weftable?
    var linkedWarp: Warp? {
        if let linkedWarp = self.presentable as? Warp {
            return linkedWarp
        }

        return nil
    }

    public init (withPresentationStyle presentationStyle: PresentationStyle = .root,
                 withPresentable presentable: Presentable? = nil,
                 withWeftable weftable: Weftable? = nil) {
        self.presentationStyle = presentationStyle
        self.presentable = presentable
        self.weftable = weftable
    }

    static public var void: Stitch {
        return Stitch(withPresentationStyle: .root, withPresentable: nil, withWeftable: nil)
    }

    static public var end: Stitch {
        return Stitch(withPresentationStyle: .dismiss, withPresentable: nil, withWeftable: nil)
    }
}
