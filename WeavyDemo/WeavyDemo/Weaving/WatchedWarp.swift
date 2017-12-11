//
//  WishlistWarp.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-09-05.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Weavy
import UIKit

class WatchedWarp: Warp {

    var head: UIViewController {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()
    private let service: MoviesService

    init(withService service: MoviesService) {
        self.service = service
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
        default:
            return Stitch.emptyStitches
        }

    }

    private func navigateToMovieListScreen () -> [Stitch] {
        let viewModel = WatchedViewModel(with: self.service)
        let viewController = WatchedViewController.instantiate(with: viewModel)
        viewController.title = "Watched"
        self.rootViewController.pushViewController(viewController, animated: true)
        return [Stitch(nextPresentable: viewController, nextWeftable: viewModel)]
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

}
