//
//  SavedAlbumCellVM.swift
//  TestingApp
//
//  Created by Денис Винокуров on 29.12.2020.
//

import Foundation
class SavedAlbumCellVM: SavedAlbumCellViewModelType {
    private let album: AlbumObject
    var nameAlbum: String {album.title}
    init(album: AlbumObject) {
        self.album = album
    }
}
