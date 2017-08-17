//
//  AppPattern.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-08-09.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import Weavy
import RxSwift

class ApplicationWarp: Warp {

    var woolBag: WoolBag?

    init(withWoolBag woolBag: ApplicationWoolBag) {
        self.woolBag = woolBag
    }

    func knit(withWeft weft: Weft, usingWoolBag woolBag: WoolBag?) -> Stitch {

        guard   let demoWeft = weft as? DemoWeft,
                let applicationWoolBag = woolBag as? ApplicationWoolBag else { return Stitch.void }

        switch demoWeft {
        case .needTheDashboard:
            let navigationViewController = UINavigationController()
            let viewController = DashboardViewController1.instantiate(withApplicationWoolBag: applicationWoolBag)
            navigationViewController.viewControllers = [viewController]
            return Stitch(withPresentable: navigationViewController, withWeftable: viewController)
        case .needTheMovieDetail(let movieTitle):
            let viewController = DashboardViewController2.instantiate()
            viewController.movieTitle = movieTitle
            return Stitch(withPresentationStyle: .show, withPresentable: viewController, withWeftable: viewController)
        case .needToLogin:
            let viewController = OnboardViewController3.instantiate()
            return Stitch(withPresentationStyle: .popup, withPresentable: viewController, withWeftable: viewController)
        case .needToOnboard:
            return Stitch(withPresentationStyle: .popup, withPresentable: DemoWarp.onboarding.warp, withWeftable: OnboardingWeftable())
        case .needTheSettings:
            return Stitch(withPresentationStyle: .popup, withPresentable: DemoWarp.settings.warp, withWeftable: SettingsWeftable())
        case .loginComplete:
            return Stitch.end
        default:
            return Stitch.void
        }
    }
}
