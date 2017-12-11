//
//  AppPattern.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-08-09.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Weavy
import RxSwift

class MainWarp: Warp {

    var head: UIViewController {
        return self.rootViewController
    }

    private let rootViewController: UINavigationController
    private let service: MoviesService

    init(with service: MoviesService) {
        self.rootViewController = UINavigationController()
        self.rootViewController.setNavigationBarHidden(true, animated: false)
        self.service = service
    }

    func knit(withWeft weft: Weft) -> [Stitch] {

        guard let weft = weft as? DemoWeft else { return Stitch.emptyStitches }

        switch weft {
        case .apiKey:
            return navigationToApiScreen()
        case .apiKeyIsComplete:
            return navigationToDashboardScreen()
        default:
            return Stitch.emptyStitches
        }
    }

    private func navigationToApiScreen () -> [Stitch] {
        let settingsViewController = SettingsViewController.instantiate()
        rootViewController.pushViewController(settingsViewController, animated: false)
        return [Stitch(nextPresentable: settingsViewController, nextWeftable: settingsViewController)]
    }

    private func navigationToDashboardScreen () -> [Stitch] {
        let tabbarController = UITabBarController()
        let wishlistWeftable = WishlistWeftable()
        let wishListWarp = WishlistWarp(withService: self.service, andWeftable: wishlistWeftable)
        let watchedWarp = WatchedWarp(withService: self.service)
        Warps.whenReady(warp1: wishListWarp, warp2: watchedWarp, block: { [unowned self] (head1: UINavigationController, head2: UINavigationController) in
            let tabBarItem1 = UITabBarItem(title: "Wishlist", image: UIImage(named: "wishlist"), selectedImage: nil)
            let tabBarItem2 = UITabBarItem(title: "Watched", image: UIImage(named: "watched"), selectedImage: nil)
            head1.tabBarItem = tabBarItem1
            head1.title = "Wishlist"
            head2.tabBarItem = tabBarItem2
            head2.title = "Watched"

            tabbarController.setViewControllers([head1, head2], animated: false)
            self.rootViewController.pushViewController(tabbarController, animated: true)
        })

        return ([Stitch(nextPresentable: wishListWarp, nextWeftable: wishlistWeftable),
                 Stitch(nextPresentable: watchedWarp, nextWeftable: SingleWeftable(withInitialWeft: DemoWeft.movieList))])
    }
}
