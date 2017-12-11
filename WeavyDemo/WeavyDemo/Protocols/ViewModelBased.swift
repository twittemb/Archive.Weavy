//
//  File.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-12-04.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import UIKit
import Reusable

protocol ViewModelBased: class {
    associatedtype ViewModel

    var viewModel: ViewModel { get set }
}

extension StoryboardBased where Self: UIViewController & ViewModelBased {
    static func instantiate (with viewModel: ViewModel) -> Self {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
}
