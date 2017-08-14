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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let disposeBag = DisposeBag()
    var window: UIWindow?
    var loom: Loom!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        guard let window = self.window else { return false }

        let applicationPattern = ApplicationPattern(withInitialWarp: DemoWarp.application, withInitialWeft: DemoWeft.bootstrap, withWoolBag: ApplicationWoolBag())
        loom = Loom(fromRootWindow: window)
        loom.weave(withPattern: applicationPattern)
        
        // FIXME: Reactive extensions (as in UIViewController for instance) do not work this way for method observing
//        loom.rx.willNavigate.subscribe(onNext: { (toViewController, withPresentationStyle) in
//            print ("Will navigate to \(String(describing: toViewController)) with presentationStyle \(String(describing: withPresentationStyle))")
//        }).disposed(by: self.disposeBag)
//
//        loom.rx.didNavigate.subscribe(onNext: { (toViewController, withPresentationStyle) in
//            print ("Did navigate to \(String(describing: toViewController)) with presentationStyle \(String(describing: withPresentationStyle))")
//        }).disposed(by: self.disposeBag)



        return true
    }

}
