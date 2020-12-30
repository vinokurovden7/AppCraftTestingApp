//
//  DetailSavedAlbumViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 29.12.2020.
//

import UIKit
protocol DetailSavedAlbumViewModelType {
    func getPhotos(for indexPath: IndexPath) -> PhotoObject
    func getNumberOfSections() -> Int
    func getNumbersItemsInSection() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DetailSavedAlbumCellViewModelType?
    func confirmDeleteAlert() -> UIAlertController
}
