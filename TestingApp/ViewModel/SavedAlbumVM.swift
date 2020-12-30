//
//  SavedAlbumVM.swift
//  TestingApp
//
//  Created by Денис Винокуров on 29.12.2020.
//

import RealmSwift
import UIKit
class SavedAlbumVM: SavedAlbumViewModelType {
    
    private let storageManager = StorageManager()
    private var albums: Results<AlbumObject>!
    private var selectedIndexPath: IndexPath?
    
    init() {
        albums = storageManager.getAlbum(userId: nil, title: nil)
    }
    
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
    
    //MARK: Получить выбранную запись
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    //MARK: Получить IndexPath выбранной записи
    func getIndexPathSelectedRow() -> IndexPath {
        return self.selectedIndexPath ?? IndexPath(row: 0, section: 0)
    }
    
    
}
