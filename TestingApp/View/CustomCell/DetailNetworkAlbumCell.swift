//
//  DetailNetworkAlbumCell.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit
import Alamofire

class DetailNetworkAlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var titlePhoto: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView! {
        didSet {
//            cellBackgroundView.layer.borderWidth = 1
//            cellBackgroundView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var withCellConstraint: NSLayoutConstraint!
    
    private let sessionManager = Session.init(configuration: .default, serverTrustManager: ServerTrustManager(evaluators: ["via.placeholder.com": DisabledTrustEvaluator()]))
    
    weak var viewModel: DetailNetworkAlbumCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            titlePhoto.text = viewModel.title
            
            DispatchQueue.main.async { [self] in
                loadingActivityIndicator.startAnimating()
                loadingActivityIndicator.isHidden = false
            }
            
            DispatchQueue.global().async { [self] in
                viewModel.getImageFromURL(session: sessionManager, url: viewModel.previewImageUrl) { imageData in
                    DispatchQueue.main.async {
                        loadingActivityIndicator.stopAnimating()
                        loadingActivityIndicator.isHidden = true
                        self.previewImage.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
