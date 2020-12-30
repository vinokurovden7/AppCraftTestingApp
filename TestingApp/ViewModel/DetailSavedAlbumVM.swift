//
//  DetailSavedAlbumVM.swift
//  TestingApp
//
//  Created by Денис Винокуров on 29.12.2020.
//

import RealmSwift
import UIKit
class DetailSavedAlbumVM: DetailSavedAlbumViewModelType {
    
    private let storageManager = StorageManager()
    private var photos: Results<PhotoObject>!
    private var albumId: Int
    
    init(albumId: Int) {
        self.photos = storageManager.getPhoto(albumId: albumId, title: nil)
        self.albumId = albumId
    }
    
    func getPhotos(for indexPath: IndexPath) -> PhotoObject {
        return photos[indexPath.row]
    }
    
    func getNumberOfSections() -> Int {
        return 1
    }
    
    func getNumbersItemsInSection() -> Int {
        return photos.count
    }
    
    func filteringAlbum(albumId: Int, filterString: String?) -> Results<PhotoObject>! {
        if let filtStr = filterString { photos = storageManager.getPhoto(albumId: albumId, title: filtStr) }
        return photos
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DetailSavedAlbumCellViewModelType? {
        let photo = photos[indexPath.row]
        return DetailSavedAlbumCellVM(photo: photo)
    }
    
    func confirmDeleteAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Подтверждение удаления", message: "Вы действительно хотите удалить альбом ?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Удалить", style: .default) { [self] (_) in
            storageManager.deleteAlbumWithPhoto(albumId: self.albumId)
            NotificationCenter.default.post(name: Notification.Name("photosDeleted"),object: nil, userInfo: ["isDeleted":true])
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        return alert
    }
    
}
