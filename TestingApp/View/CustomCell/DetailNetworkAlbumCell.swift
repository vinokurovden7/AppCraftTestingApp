//
//  DetailNetworkAlbumCell.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit
import Alamofire

class DetailNetworkAlbumCell: UICollectionViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var titlePhoto: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var withCellConstraint: NSLayoutConstraint!
    
    //MARK: Variables
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
                viewModel.getImageFromURL(session: sessionManager, url: viewModel.previewImageUrl) { [weak self] imageData in
                    DispatchQueue.main.async {
                        loadingActivityIndicator.stopAnimating()
                        loadingActivityIndicator.isHidden = true
                        self?.previewImage.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
