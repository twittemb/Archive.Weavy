//
//  Stitch.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-10-09.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

/// A Stitch is the result of the weaving action between a Warp and a Weft (See Warp.knit function)
/// It describes the next thing that will be presented (a Presentable) and
/// the next thing the Loom will listen to have the next navigation steps (a Weftable).
/// If a navigation action does not have to lead to a Stitch, it is possible to have an empty Stitch
public struct Stitch {

    /// The presentable that will be handle by the Loom. The Loom is not
    /// meant to display this presentable, it will only handle its "Display" status
    /// so that the associated weftable will be listened or not
    var nextPresentable: Presentable?

    /// The weftable that will be handle by the Loom. It will trigger the new
    /// navigation states. The Loom will listen to them only if the associated
    /// presentable is displayed
    var nextWeftable: Weftable?

    /// Initialize a new Stitch
    ///
    /// - Parameters:
    ///   - presentable: the next presentable to be handled by the Loom
    ///   - weftable: the next weftable to be handled by the Loom
    public init(nextPresentable presentable: Presentable? = nil, nextWeftable weftable: Weftable? = nil) {
        self.nextPresentable = presentable
        self.nextWeftable = weftable
    }

    /// An empty Stitch that won't be taken care of by the Loom
    public static var empty: Stitch {
        return Stitch()
    }

    /// Empty Stitches that won't be taken care of by the Loom
    public static var emptyStitches: [Stitch] {
        return [Stitch.empty]
    }
}
