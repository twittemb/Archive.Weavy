//
//  AppDelegate.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-07-25.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import UIKit
import Weavy
import RxSwift
import RxCocoa
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let disposeBag = DisposeBag()
    var window: UIWindow?
    var loom = Loom()
    let mainWarp = MainWarp()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        guard let window = self.window else { return false }

        Warps.whenReady(warp: mainWarp, block: { [unowned window] (head) in
            window.rootViewController = head
        })

        loom.weave(fromWarp: mainWarp, andWeftable: SingleWeftable(withInitialWeft: DemoWeft.apiKey))

        return true
    }

}





























































