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

class CastDetailViewController: UIViewController, StoryboardBased, ViewModelBased {

    @IBOutlet private weak var castBanner: UIImageView!
    @IBOutlet private weak var castBio: UILabel!

    var viewModel: CastDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.castBanner.image = UIImage(named: self.viewModel.image)
        self.castBio.text = self.viewModel.bio
    }

}
