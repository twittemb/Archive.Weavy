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

class WishlistViewController: UIViewController, StoryboardBased, Weftable {

    @IBOutlet weak var moviesTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.moviesTable.delegate = self
        self.moviesTable.dataSource = self
    }

}

extension WishlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.weftSubject.onNext(DemoWeft.moviePicked(withId: 1))
    }
}

extension WishlistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: MovieViewCell!

        if let movieViewCell = tableView.dequeueReusableCell(withIdentifier: "movieViewCell") as? MovieViewCell {
            cell = movieViewCell
        } else {
            cell = MovieViewCell()
        }

        switch indexPath.item {
        case 0:
            cell.movieTitle.text = "Star Trek Beyond"
            cell.movieImage.image = UIImage(named: "startrek")
            return cell
        case 1:
            cell.movieTitle.text = "Starwars: The force awakens"
            cell.movieImage.image = UIImage(named: "starwars")
            return cell
        case 2:
            cell.movieTitle.text = "Avatar"
            cell.movieImage.image = UIImage(named: "avatar")
            return cell
        case 3:
            cell.movieTitle.text = "Blade Runner"
            cell.movieImage.image = UIImage(named: "bladerunner")
            return cell
        default:
            cell.movieTitle.text = "Star Trek Beyond"
            cell.movieImage.image = UIImage(named: "startrek")
            return cell
        }
    }
}
