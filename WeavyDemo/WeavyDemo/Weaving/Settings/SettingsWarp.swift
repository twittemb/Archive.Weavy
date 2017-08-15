//
//  SettingsPattern.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-08-09.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import Weavy

class SettingsWarp: Warp {

    let initialWeft: Weft
    var woolBag: WoolBag

    init(withInitialWeft weft: DemoWeft, withWoolBag woolBag: SettingsWoolBag) {
        self.initialWeft = weft
        self.woolBag = woolBag
    }

    func knit(withWeft weft: Weft, usingWoolBag woolBag: WoolBag) -> Stitch {

        guard   let demoWeft = weft as? DemoWeft,
                let settingsWoolBag = woolBag as? SettingsWoolBag else { return Stitch.void }

        switch demoWeft {
        case .bootstrap:
            let navigationViewController = UINavigationController()
            return Stitch(withPresentable: navigationViewController, withWeftable: SettingsWeftable())
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
