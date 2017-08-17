//
//  Stitch.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-23.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation

/// describes all the possible presentation options for a Presentable (could be a UIViewController or a Warp for instance)
///
/// - root: used when no PresentationStyle is provided in a Stitch. It mainly displays the UIViewController in the root window
/// - popup: displays the Presentable as a modal popup
/// - show: displays the Presentable either with a show or with a push action, depending on the context (it is up to iOS the pick what is best)
/// - dismiss: dismiss the currently displayed Presentable
/// - PresentationStyle.root.rawValue: String raw value of .root
/// - PresentationStyle.popup.rawValue: String raw value of .popup
/// - PresentationStyle.show.rawValue: String raw value of .show
/// - PresentationStyle.dismiss.rawValue: String raw value of .dismiss
public enum PresentationStyle: String {
    /// used when no PresentationStyle is provided in a Stitch
    case root
    /// displays the Presentable as a modal popup
    case popup
    /// isplays the Presentable either with a show or with a push action
    case show
    /// dismiss the currently displayed Presentable
    case dismiss

    /// a PresentationStyle can be represented by its String raw value. This function gets the enum value from this raw value
    ///
    /// - Parameter raw: the string value of a PresentationStyle
    /// - Returns: the enum value corresponding to the raw value
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

/// a Stitch represents a navigation action. It is built according to a Weft, triggered in the context of a specific Warp. (See Warp.knit())
/// a Stitch can lead to the presentation of a UIViewController or a link to another Warp
public struct Stitch: Presentable {

    /// the way we want to present the Presentable exposed in this Stitch
    var presentationStyle: PresentationStyle

    /// the presentation we want to display (can be a UIViewController or a whole another Warp)
    let presentable: Presentable?

    /// the Weftable that will trigger new Weft values for the presented Presentable.
    /// these new values will interpreted in the context of the Warp in which this Stitch has been built
    let weftable: Weftable?

    /// the optional warp this is pointed by this Stitch. It can be nil because a Stitch represents a Presentable, that can also be a UIViewController
    var linkedWarp: Warp? {
        if let linkedWarp = self.presentable as? Warp {
            return linkedWarp
        }

        return nil
    }

    /// instantiate a new Stitch
    ///
    /// - Parameters:
    ///   - presentationStyle: the way the presentable will be displayed (see PresentationStyle enum)
    ///   - presentable: the presentable we want to display (can be a UIViewController or a whole Warp)
    ///   - weftable: the Weftable that will trigger new Weft values for the presented Presentable
    public init (withPresentationStyle presentationStyle: PresentationStyle = .root,
                 withPresentable presentable: Presentable? = nil,
                 withWeftable weftable: Weftable? = nil) {
        self.presentationStyle = presentationStyle
        self.presentable = presentable
        self.weftable = weftable
    }

    /// a void Stitch used in the weaving process when no other suitable Stitch has been found. It basically lead to nothing in term of navigation
    static public var void: Stitch {
        return Stitch(withPresentationStyle: .root, withPresentable: nil, withWeftable: nil)
    }

    /// the Stitch that triggers a dismiss action (see PresentationStyle enum)
    static public var end: Stitch {
        return Stitch(withPresentationStyle: .dismiss, withPresentable: nil, withWeftable: nil)
    }
}
