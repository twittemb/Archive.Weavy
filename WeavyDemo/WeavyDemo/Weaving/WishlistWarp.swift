//
//  WishlistWarp.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-09-05.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import Weavy
import RxSwift
import UIKit

class WishlistWarp: Warp {
    
    var head: UIViewController {
        return self.rootViewController
    }

    let rootViewController = UINavigationController()

    let wishlistWeftable: WishlistWeftable
    init(with weftable: WishlistWeftable) {
        self.wishlistWeftable = weftable
    }

    func knit(withWeft weft: Weft) -> [Stitch] {

        guard let weft = weft as? DemoWeft else { return Stitch.emptyStitches }

        switch weft {

        case .movieList:
            return navigateToMovieListScreen()
        case .moviePicked(let movieId):
            return navigateToMovieDetailScreen(with: movieId)
        case .castPicked(let castId):
            return navigateToCastDetailScreen(with: castId)
        case .settings:
            return navigateToSettings()
        default:
            return Stitch.emptyStitches
        }

    }

    private func navigateToMovieListScreen () -> [Stitch] {

        let viewController = WishlistViewController.instantiate()
        viewController.title = "Wishlist"
        self.rootViewController.pushViewController(viewController, animated: true)
        if let navigationBarItem = self.rootViewController.navigationBar.items?[0] {
            navigationBarItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "settings"),
                                                                style: UIBarButtonItemStyle.plain,
                                                                target: self.wishlistWeftable,
                                                                action: #selector(WishlistWeftable.settings)),
                                                animated: false)
        }
        return [Stitch(nextPresentable: viewController, nextWeftable: viewController)]
    }

    private func navigateToMovieDetailScreen (with movieId: Int) -> [Stitch] {
        print ("Movie picked with id: \(movieId)")
        let viewController = MovieDetailViewController.instantiate()
        self.rootViewController.pushViewController(viewController, animated: true)
        return [Stitch(nextPresentable: viewController, nextWeftable: viewController)]
    }

    private func navigateToCastDetailScreen (with castId: Int) -> [Stitch] {
        print ("Cast picked with id: \(castId)")
        let viewController = CastDetailViewController.instantiate()
        self.rootViewController.pushViewController(viewController, animated: true)
        return [Stitch(nextPresentable: viewController, nextWeftable: viewController)]
    }

    private func navigateToSettings () -> [Stitch] {
        let settingsWeftable = SettingsWeftable()
        let settingsWarp = SettingsWarp(with: settingsWeftable)
        Warps.whenReady(warp: settingsWarp, block: { [unowned self] (head: UISplitViewController) in
            self.rootViewController.present(head, animated: true)
        })
        return [Stitch(nextPresentable: settingsWarp, nextWeftable: settingsWeftable)]
    }
}

class WishlistWeftable: Weftable, HasDisposeBag {

    init() {
        self.weftSubject.onNext(DemoWeft.movieList)
    }

    @objc func settings () {
        self.weftSubject.onNext(DemoWeft.settings)
    }
}








