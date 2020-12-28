//
//  DetailNetworkAlbumViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import Foundation
protocol DetailNetworkAlbumViewModelType {
    func getPhotos(albumId: String)
    func getNumberOfSections() -> Int
    func getNumbersItemsInSection() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DetailNetworkAlbumCellViewModelType?
    func saveAlbum(album: Album, completion: @escaping (Bool) -> ())
    func getPhotosArray() -> [Photo]
    func downloadImageFromUrl(url: String, completion: @escaping (Data?) -> ())
    func checkIsLoaded(id: Int) -> Bool
}
