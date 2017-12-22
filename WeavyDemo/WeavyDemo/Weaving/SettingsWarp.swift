//
//  SettingsPattern.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-08-09.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Weavy
import RxSwift

class SettingsWarp: Warp {

    var head: UIViewController {
        return self.rootViewController
    }

    let rootViewController = UISplitViewController()

    let settingsWeftable: SettingsWeftable
    init(withService service: MoviesService, andWeftable weftable: SettingsWeftable) {
        self.settingsWeftable = weftable
        self.rootViewController.preferredDisplayMode = .allVisible
    }

    func knit(withWeft weft: Weft) -> [Stitch] {

        guard let weft = weft as? DemoWeft else { return Stitch.emptyStitches }

        switch weft {
        case .settings:
            let navigationController = UINavigationController()

            let settingsListViewController = SettingsListViewController.instantiate()

            navigationController.viewControllers = [settingsListViewController]
            if let navigationBarItem = navigationController.navigationBar.items?[0] {
                let settingsButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                                     target: self.settingsWeftable,
                                                     action: #selector(SettingsWeftable.settingsDone))
                navigationBarItem.setRightBarButton(settingsButton, animated: false)
            }
            self.rootViewController.viewControllers = [navigationController]

            let settingsViewController = SettingsViewController.instantiate()
            settingsViewController.title = "Api Key"
            self.rootViewController.showDetailViewController(settingsViewController, sender: nil)

            return [Stitch(nextPresentable: navigationController, nextWeftable: settingsListViewController),
                    Stitch(nextPresentable: settingsViewController, nextWeftable: settingsViewController)]
        case .apiKey:
            let settingsViewController = SettingsViewController.instantiate()
            settingsViewController.title = "Api Key"
            self.rootViewController.showDetailViewController(settingsViewController, sender: nil)
            return Stitch.emptyStitches
        case .about:
            let settingsAboutViewController = SettingsAboutViewController.instantiate()
            settingsAboutViewController.title = "About"
            self.rootViewController.showDetailViewController(settingsAboutViewController, sender: nil)
            return Stitch.emptyStitches
        case .settingsDone:
            self.rootViewController.dismiss(animated: true)
            return Stitch.emptyStitches
        default:
            return Stitch.emptyStitches
        }

    }
}

class SettingsWeftable: Weftable {

    init() {
        self.weftSubject.onNext(DemoWeft.settings)
    }

    @objc func settingsDone () {
        self.weftSubject.onNext(DemoWeft.settingsDone)
    }
}
