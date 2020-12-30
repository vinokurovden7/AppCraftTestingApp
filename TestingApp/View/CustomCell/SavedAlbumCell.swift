//
//  SavedAlbumCell.swift
//  TestingApp
//
//  Created by Денис Винокуров on 29.12.2020.
//

import UIKit

class SavedAlbumCell: UICollectionViewCell {
    @IBOutlet weak var cellBackgroundView: UIView! {
        didSet {
            cellBackgroundView.layer.borderWidth = 1
            cellBackgroundView.layer.cornerRadius = cellBackgroundView.frame.height / 2
        }
    }
    @IBOutlet weak var nameAlbumLabel: UILabel!
    @IBOutlet weak var withIthemConstraint: NSLayoutConstraint!
    weak var viewModel: SavedAlbumCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            nameAlbumLabel.text = viewModel.nameAlbum
        }
    }
}
