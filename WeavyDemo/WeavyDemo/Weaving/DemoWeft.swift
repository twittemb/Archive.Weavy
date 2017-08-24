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
    case apiKey
    case apiKeyIsComplete

    case movieList

    case moviePicked (withId: Int)
    case castPicked (withId: Int)

    case settings
    case settingsDone
    case about
}



