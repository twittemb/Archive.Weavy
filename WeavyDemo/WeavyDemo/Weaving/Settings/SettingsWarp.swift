//
//  SettingsPattern.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-08-09.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import Weavy
import RxSwift

class SettingsWarp: Warp {

    var woolBag: WoolBag?

    init(withWoolBag woolBag: SettingsWoolBag) {
        self.woolBag = woolBag
    }

    func knit(withWeft weft: Weft, usingWoolBag woolBag: WoolBag?) -> Stitch {

        guard   let demoWeft = weft as? DemoWeft,
                let settingsWoolBag = woolBag as? SettingsWoolBag else { return Stitch.void }

        switch demoWeft {
        case .needTheSettings:
            let navigationViewController = UINavigationController()
            let viewController = SettingsViewController1.instantiate()
            navigationViewController.viewControllers = [viewController]
            return Stitch(withPresentable: navigationViewController, withWeftable: viewController)
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
