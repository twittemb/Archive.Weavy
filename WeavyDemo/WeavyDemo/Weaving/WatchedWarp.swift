//
//  WishlistWarp.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-09-05.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import Weavy
import UIKit

class WatchedWarp: Warp {

    var head: UIViewController {
        return self.rootViewController
    }

    let rootViewController = UINavigationController()

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
        let viewController = WatchedViewController.instantiate()
        viewController.title = "Watched"
        self.rootViewController.pushViewController(viewController, animated: true)
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

}
