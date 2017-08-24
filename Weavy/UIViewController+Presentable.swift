//
//  UIViewController+Presentable.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-25.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

extension UIViewController: Presentable {

    /// Rx Observable that triggers a bool indicating if the current UIViewController is being displayed
    public var rxDisplayed: Observable<Bool> {
        return self.rx.displayed
    }
}
