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
    public var rxDisplayed: Observable<Bool> {
        return self.rx.displayed
    }
}
