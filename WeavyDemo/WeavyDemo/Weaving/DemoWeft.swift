//
//  DemoWeft.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-07-25.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import Weavy

enum DemoWeft: Weft {
    case bootstrap
    case needToOnboard
    case needToLogin
    case needTheSettings
    case needTheDashboard
    case needTheMovieDetail(withMovieTitle: String)
    case needToSetServer
    case loginComplete
    case welcomeComplete
    case serverComplete
    case settingsComplete
}
