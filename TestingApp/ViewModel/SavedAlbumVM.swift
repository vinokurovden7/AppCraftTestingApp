//
//  SavedAlbumVM.swift
//  TestingApp
//
//  Created by Денис Винокуров on 29.12.2020.
//

import RealmSwift
import UIKit
/// Класс для работы вкладки 'БД'
class SavedAlbumVM: SavedAlbumViewModelType {
    //MARK: Variables
    private let storageManager = StorageManager()
    private var albums: Results<AlbumObject>!
    private var selectedIndexPath: IndexPath?
    
    //MARK: Protocol functions
    func getNumberOfSections() -> Int {
        return 1
    }
    
    func getNumbersItemsInSection() -> Int {
        return albums.count
    }
    
    func getAlbum(for indexPath: IndexPath) -> AlbumObject {
        return albums[indexPath.row]
    }
    
    func filteringAlbum(filterString: String?) -> Results<AlbumObject>! {
        if let filtStr = filterString { albums = storageManager.getAlbum(userId: nil, title: filtStr) }
        return albums
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> SavedAlbumCellViewModelType? {
        let album = albums[indexPath.row]
        return SavedAlbumCellVM(album: album)
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func getIndexPathSelectedRow() -> IndexPath {
        return self.selectedIndexPath ?? IndexPath(row: 0, section: 0)
    }
    
    //MARK: Init
    init() {
        albums = storageManager.getAlbum(userId: nil, title: nil)
    }
}
