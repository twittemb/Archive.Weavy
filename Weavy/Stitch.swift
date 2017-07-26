//
//  Stitch.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-23.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation

public enum PresentationStyle: String {
    case none
    case popup
    case show
    case dismiss

    static func fromRaw (raw: String) -> PresentationStyle? {
        switch raw {
        case PresentationStyle.none.rawValue:
            return PresentationStyle.none
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

    let presentationStyle: PresentationStyle
    let presentable: Presentable?
    let weftable: Weftable?
    var pattern: Patternable? {
        if let innerPattern = self.presentable as? Patternable {
            return innerPattern
        }

        return nil
    }

    var warp: Warp? {
        if let redirectionWarp = self.presentable as? Warp {
            return redirectionWarp
        }

        return nil
    }

    public init (withPresentationStyle presentationStyle: PresentationStyle,
                 withPresentable presentable: Presentable? = nil,
                 withWeftable weftable: Weftable? = nil) {
        self.presentationStyle = presentationStyle
        self.presentable = presentable
        self.weftable = weftable
    }

    static public var void: Stitch {
        return Stitch(withPresentationStyle: .none, withPresentable: nil, withWeftable: nil)
    }

    static public var end: Stitch {
        return Stitch(withPresentationStyle: .dismiss, withPresentable: nil, withWeftable: nil)
    }
}
