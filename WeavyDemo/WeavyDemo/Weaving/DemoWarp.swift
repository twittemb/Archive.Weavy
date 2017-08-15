//
//  DemoWarp.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-07-25.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import Weavy

enum DemoWarp {

    case application
    case onboarding
    case settings

    var warp: Warp {
        switch self {
        case .application:
            return ApplicationWarp(withInitialWeft: DemoWeft.bootstrap, withWoolBag: ApplicationWoolBag())
        case .onboarding:
            return OnboardingWarp(withInitialWeft: DemoWeft.bootstrap, withWoolBag: OnboardingWoolBag())
        case .settings:
            return SettingsWarp(withInitialWeft: DemoWeft.bootstrap, withWoolBag: SettingsWoolBag())
        }
    }
}
