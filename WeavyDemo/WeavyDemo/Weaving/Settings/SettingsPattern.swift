//
//  SettingsPattern.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-08-09.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import Weavy

class SettingsPattern: Patternable {

    let initialWarp: Warp
    let initialWeft: Weft
    var woolBag: WoolBag

    init(withInitialWarp warp: DemoWarp, withInitialWeft weft: DemoWeft, withWoolBag woolBag: SettingsWoolBag) {
        self.initialWarp = warp
        self.initialWeft = weft
        self.woolBag = woolBag
    }

    func knit(fromWarp warp: Warp, fromWeft weft: Weft, withWoolBag woolBag: WoolBag) -> Stitch {

        guard   let demoWarp = warp as? DemoWarp,
                demoWarp == DemoWarp.settings,
                let demoWeft = weft as? DemoWeft,
                let settingsWoolBag = woolBag as? SettingsWoolBag else { return Stitch.void }

        switch demoWeft {
        case .bootstrap:
            let navigationViewController = UINavigationController()
            return Stitch(withPresentationStyle: .none, withPresentable: navigationViewController, withWeftable: SettingsWeftable())
        case .needTheSettings:
            let viewController = SettingsViewController1.instantiate()
            return Stitch(withPresentationStyle: .show, withPresentable: viewController, withWeftable: viewController)
        case .needToSetServer:
            let viewController = SettingsViewController2.instantiate()
            return Stitch(withPresentationStyle: .show, withPresentable: viewController, withWeftable: viewController)
        case .settingsComplete:
            return Stitch.end
        default:
            return Stitch.void
        }
    }
}
