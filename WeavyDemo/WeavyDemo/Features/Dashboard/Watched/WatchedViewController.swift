//
//  DashboardViewController1.swift
//  WeavyDemo
//
//  Created by Thibault Wittemberg on 17-07-26.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import UIKit
import Reusable
import Weavy
import RxSwift
import RxCocoa

class WatchedViewController: UIViewController, StoryboardBased, Weftable {

    @IBOutlet weak var moviesCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.moviesCollection.delegate = self
        self.moviesCollection.dataSource = self
    }

}

extension WatchedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.weftSubject.onNext(DemoWeft.moviePicked(withId: 1))
    }
}

extension WatchedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: MovieCollectionViewCell!

        if let movieViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell {
            cell = movieViewCell
        } else {
            cell = MovieCollectionViewCell()
        }

        switch indexPath.item {
        case 0:
            cell.movieTitle.text = "Terminator"
            cell.movieImage.image = UIImage(named: "terminator")
            return cell
        case 1:
            cell.movieTitle.text = "Predator"
            cell.movieImage.image = UIImage(named: "predator")
            return cell
        case 2:
            cell.movieTitle.text = "Dune"
            cell.movieImage.image = UIImage(named: "dune")
            return cell
        case 3:
            cell.movieTitle.text = "First Constant"
            cell.movieImage.image = UIImage(named: "firstcontact")
            return cell
        case 4:
            cell.movieTitle.text = "Dune"
            cell.movieImage.image = UIImage(named: "dune")
            return cell
        case 5:
            cell.movieTitle.text = "First Constant"
            cell.movieImage.image = UIImage(named: "firstcontact")
            return cell
        default:
            cell.movieTitle.text = "Star Trek Beyond"
            cell.movieImage.image = UIImage(named: "startrek")
            return cell
        }
    }

}
