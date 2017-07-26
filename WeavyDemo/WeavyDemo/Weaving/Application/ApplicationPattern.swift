//
//  AppPattern.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-08-09.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import Weavy

class ApplicationPattern: Patternable {

    let initialWarp: Warp
    let initialWeft: Weft
    var woolBag: WoolBag

    init(withInitialWarp warp: DemoWarp, withInitialWeft weft: DemoWeft, withWoolBag woolBag: ApplicationWoolBag) {
        self.initialWarp = warp
        self.initialWeft = weft
        self.woolBag = woolBag
    }

    func knit(fromWarp warp: Warp, fromWeft weft: Weft, withWoolBag woolBag: WoolBag) -> Stitch {

        guard   let demoWarp = warp as? DemoWarp,
                let demoWeft = weft as? DemoWeft,
                let applicationWoolBag = woolBag as? ApplicationWoolBag else { return Stitch.void }

        switch (demoWarp, demoWeft) {
        case (.application, .bootstrap):
            let navigationViewController = UINavigationController()
            return Stitch(withPresentationStyle: .none, withPresentable: navigationViewController, withWeftable: ApplicationWeftable())
        case (.application, .needTheDashboard):
            let viewController = DashboardViewController1.instantiate(withApplicationWoolBag: applicationWoolBag)
            return Stitch(withPresentationStyle: .show, withPresentable: viewController, withWeftable: viewController)
        case (.application, .needTheMovieDetail(let movieTitle)):
            let viewController = DashboardViewController2.instantiate()
            viewController.movieTitle = movieTitle
            return Stitch(withPresentationStyle: .show, withPresentable: viewController, withWeftable: viewController)
        case (.application, .needToLogin):
            return Stitch(withPresentationStyle: .popup, withPresentable: DemoWarp.login)
        case (.application, .needToOnboard):
            let onBoardingPattern = OnboardingPattern(withInitialWarp: DemoWarp.onboarding, withInitialWeft: DemoWeft.bootstrap, withWoolBag: OnboardingWoolBag())
            return Stitch(withPresentationStyle: .popup, withPresentable: onBoardingPattern)
        case (.application, .needTheSettings):
            let settingsPattern = SettingsPattern(withInitialWarp: DemoWarp.settings, withInitialWeft: DemoWeft.bootstrap, withWoolBag: SettingsWoolBag())
            return Stitch(withPresentationStyle: .popup, withPresentable: settingsPattern)
        case (.login, .bootstrap):
            let viewController = OnboardViewController3.instantiate()
            return Stitch(withPresentationStyle: .none, withPresentable: viewController, withWeftable: viewController)
        case (.login, .loginComplete):
            return Stitch.end
        default:
            return Stitch.void
        }
    }
}
