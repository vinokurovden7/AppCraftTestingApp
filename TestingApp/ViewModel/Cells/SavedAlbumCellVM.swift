//
//  SavedAlbumCellVM.swift
//  TestingApp
//
//  Created by Денис Винокуров on 29.12.2020.
//

import Foundation
/// Класс ячейки вкладки 'БД'
class SavedAlbumCellVM: SavedAlbumCellViewModelType {
    //MARK: Variables
    private let album: AlbumObject
    var nameAlbum: String {album.title}
    
    //MARK: Init
    init(album: AlbumObject) {
        self.album = album
    }
}
