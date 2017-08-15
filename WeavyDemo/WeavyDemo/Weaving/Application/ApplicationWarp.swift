//
//  AppPattern.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-08-09.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import Weavy

class ApplicationWarp: Warp {

    let initialWeft: Weft
    var woolBag: WoolBag

    init(withInitialWeft weft: DemoWeft, withWoolBag woolBag: ApplicationWoolBag) {
        self.initialWeft = weft
        self.woolBag = woolBag
    }

    func knit(withWeft weft: Weft, usingWoolBag woolBag: WoolBag) -> Stitch {

        guard   let demoWeft = weft as? DemoWeft,
                let applicationWoolBag = woolBag as? ApplicationWoolBag else { return Stitch.void }

        switch demoWeft {
        case .bootstrap:
            let navigationViewController = UINavigationController()
            return Stitch(withPresentationStyle: .none, withPresentable: navigationViewController, withWeftable: ApplicationWeftable())
        case .needTheDashboard:
            let viewController = DashboardViewController1.instantiate(withApplicationWoolBag: applicationWoolBag)
            return Stitch(withPresentationStyle: .show, withPresentable: viewController, withWeftable: viewController)
        case .needTheMovieDetail(let movieTitle):
            let viewController = DashboardViewController2.instantiate()
            viewController.movieTitle = movieTitle
            return Stitch(withPresentationStyle: .show, withPresentable: viewController, withWeftable: viewController)
        case .needToLogin:
            let viewController = OnboardViewController3.instantiate()
            return Stitch(withPresentationStyle: .none, withPresentable: viewController, withWeftable: viewController)
        case .needToOnboard:
            return Stitch(withPresentationStyle: .popup, withPresentable: DemoWarp.onboarding.warp)
        case .needTheSettings:
            return Stitch(withPresentationStyle: .popup, withPresentable: DemoWarp.settings.warp)
        case .loginComplete:
            return Stitch.end
        default:
            return Stitch.void
        }
    }
}
