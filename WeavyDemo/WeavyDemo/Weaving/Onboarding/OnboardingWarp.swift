//
//  OnboardingPattern.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-08-09.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import Weavy
import RxSwift

class OnboardingWarp: Warp {

    var woolBag: WoolBag?

    init(withWoolBag woolBag: OnboardingWoolBag) {
        self.woolBag = woolBag
    }

    func knit(withWeft weft: Weft, usingWoolBag woolBag: WoolBag?) -> Stitch {

        guard   let demoWeft = weft as? DemoWeft,
                let onboardingWoolBag = woolBag as? OnboardingWoolBag else { return Stitch.void }

        switch demoWeft {
        case .needToOnboard:
            let navigationViewController = UINavigationController()
            let viewController = OnboardViewController1.instantiate()
            navigationViewController.viewControllers = [viewController]
            return Stitch(withPresentable: navigationViewController, withWeftable: viewController)
        case .welcomeComplete:
            let viewController = OnboardViewController2.instantiate()
            return Stitch(withPresentationStyle: .show, withPresentable: viewController, withWeftable: viewController)
        case .serverComplete:
            let viewController = OnboardViewController3.instantiate()
            return Stitch(withPresentationStyle: .show, withPresentable: viewController, withWeftable: viewController)
        case .loginComplete:
            return Stitch.end
        default:
            return Stitch.void
        }
    }
}
