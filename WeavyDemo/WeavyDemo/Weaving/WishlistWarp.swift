//
//  WishlistWarp.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-09-05.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Weavy
import RxSwift
import UIKit

class WishlistWarp: Warp {

    var head: UIViewController {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()
    private let wishlistWeftable: WishlistWeftable
    private let service: MoviesService

    init(withService service: MoviesService, andWeftable weftable: WishlistWeftable) {
        self.service = service
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
        let viewModel = WishlistViewModel(with: self.service)
        let viewController = WishlistViewController.instantiate(with: viewModel)
        viewController.title = "Wishlist"
        self.rootViewController.pushViewController(viewController, animated: true)
        if let navigationBarItem = self.rootViewController.navigationBar.items?[0] {
            navigationBarItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "settings"),
                                                                style: UIBarButtonItemStyle.plain,
                                                                target: self.wishlistWeftable,
                                                                action: #selector(WishlistWeftable.settings)),
                                                animated: false)
        }
        return [Stitch(nextPresentable: viewController, nextWeftable: viewController.viewModel)]
    }

    private func navigateToMovieDetailScreen (with movieId: Int) -> [Stitch] {
        let viewModel = MovieDetailViewModel(withService: self.service, andMovieId: movieId)
        let viewController = MovieDetailViewController.instantiate(with: viewModel)
        viewController.title = viewModel.title
        self.rootViewController.pushViewController(viewController, animated: true)
        return [Stitch(nextPresentable: viewController, nextWeftable: viewModel)]
    }

    private func navigateToCastDetailScreen (with castId: Int) -> [Stitch] {
        let viewModel = CastDetailViewModel(withService: self.service, andCastId: castId)
        let viewController = CastDetailViewController.instantiate(with: viewModel)
        viewController.title = viewModel.name
        self.rootViewController.pushViewController(viewController, animated: true)
        return Stitch.emptyStitches
    }

    private func navigateToSettings () -> [Stitch] {
        let settingsWeftable = SettingsWeftable()
        let settingsWarp = SettingsWarp(withService: self.service, andWeftable: settingsWeftable)
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
