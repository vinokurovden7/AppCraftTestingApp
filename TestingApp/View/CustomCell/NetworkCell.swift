//
//  NetworkCell.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit

class NetworkCell: UICollectionViewCell {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var nameAlbumLabel: UILabel!
    @IBOutlet weak var withIthemConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellBackgroundView: UIView! {
        didSet {
            cellBackgroundView.layer.borderWidth = 1
            cellBackgroundView.layer.cornerRadius = cellBackgroundView.frame.height / 2
        }
    }
    @IBOutlet weak var networkStatusAlbumImage: UIImageView!
    
    weak var viewModel: NetworkCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            nameAlbumLabel.text = viewModel.nameAlbum
        }
    }
    
}
