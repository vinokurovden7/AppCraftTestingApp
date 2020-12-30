//
//  DetailSavedAlbumCell.swift
//  TestingApp
//
//  Created by Денис Винокуров on 29.12.2020.
//

import UIKit

class DetailSavedAlbumCell: UICollectionViewCell {
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var nameAlbumLabel: UILabel!
    @IBOutlet weak var withIthemConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewImage: UIImageView!
    
    weak var viewModel: DetailSavedAlbumCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            nameAlbumLabel.text = viewModel.title
            previewImage.image = viewModel.previewImage
        }
    }
    
}
