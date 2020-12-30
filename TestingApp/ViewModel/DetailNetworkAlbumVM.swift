//
//  DetailNetworkAlbumVM.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit
class DetailNetworkAlbumVM: DetailNetworkAlbumViewModelType {
    
    //MARK: Свойства
    private var photosArray: [Photo] = []
    private let photosUrl = "https://jsonplaceholder.typicode.com/photos"
    private let collectionView: UICollectionView
    var statusLoading: Int?
    private var selectedIndexPath: IndexPath?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func getPhotos(albumId: String) {
        let networkManager: NetworkRequests = NetworkRequests()
        networkManager.getPhotoAlbum(url: photosUrl, parameters: albumId) { [self] photos in
            photosArray = photos
            NotificationCenter.default.post(name: Notification.Name("photoIsLoaded"),object: nil, userInfo: ["isLoaded":true])
        }
    }
    
    func getNumberOfSections() -> Int {
        return 1
    }
    
    func getNumbersItemsInSection() -> Int {
        return photosArray.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DetailNetworkAlbumCellViewModelType? {
        let photo = photosArray[indexPath.row]
        return DetailNetworkAlbumCellVM(photo: photo)
    }
    
    func saveAlbum(album: Album, completion: @escaping (Bool) -> ()) {
        let storageManager = StorageManager()
        var countPhotos = 0
        for photo in photosArray {
            DispatchQueue.global(qos: .background).async {
                let ph = PhotoObject()
                ph.photoObjectId = "\(photo.id)\(photo.albumId)"
                ph.id = photo.id
                ph.albumId = photo.albumId
                ph.title = photo.title
                ph.thumbnailUrl = photo.thumbnailUrl
                ph.url = photo.url
                self.downloadImageFromUrl(url: photo.thumbnailUrl) { imageData in
                    ph.previewPhoto = imageData
                    self.downloadImageFromUrl(url: photo.url) { imageData in
                        ph.photo = imageData
                        storageManager.savePhoto(photo: ph)
                        NotificationCenter.default.post(name: Notification.Name("photoLoaded"),object: nil, userInfo: ["isLoaded":true])
                        countPhotos += 1
                        if countPhotos == self.photosArray.count {
                            let albumObject = AlbumObject()
                            albumObject.albumObjectID = "\(album.id)\(album.userId)"
                            albumObject.id = album.id
                            albumObject.title = album.title
                            albumObject.userId = album.userId
                            storageManager.saveAlbum(album: albumObject)
                            completion(imageData == nil)
                        }
                    }
                }
            }
        }
    }
    
    func getPhotosArray() -> [Photo] {
        return photosArray
    }
    
    func downloadImageFromUrl(url: String, completion: @escaping (Data?) -> ()) {
        let networkManager = NetworkRequests()
        networkManager.downloadImageFromUrl(sessionManager: SharedVariables.sharedVariables.sessionManager, url: url) { imageData in
            completion(imageData)
        }
    }
    
    func checkIsLoaded(id: Int) -> Bool {
        let storageManager = StorageManager()
        return storageManager.getAlbum(userId: id, title: nil)?.count ?? 0 > 0
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
