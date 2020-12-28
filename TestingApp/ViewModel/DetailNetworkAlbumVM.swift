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
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func getPhotos(albumId: String) {
        let networkManager: NetworkRequests = NetworkRequests()
        networkManager.getPhotoAlbum(url: photosUrl, parameters: albumId) { [self] photos in
            photosArray = photos
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
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
        let albumObject = AlbumObject()
        albumObject.id = album.id
        albumObject.title = album.title
        albumObject.userId = album.userId
        let storageManager = StorageManager()
        storageManager.saveAlbum(album: albumObject)
        var countPhotos = 0
        for photo in photosArray {
            DispatchQueue.global(qos: .background).async {
                let ph = PhotoObject()
                ph.albumId = photo.albumId
                ph.id = photo.id
                ph.title = photo.title
                ph.thumbnailUrl = photo.thumbnailUrl
                ph.url = photo.url
                self.downloadImageFromUrl(url: photo.thumbnailUrl) { imageData in
                    ph.previewPhoto = imageData
                    self.downloadImageFromUrl(url: photo.url) { imageData in
                        ph.photo = imageData
                        storageManager.savePhoto(photo: ph)
                        //print("saved: \(ph)")
                        countPhotos += 1
                        if countPhotos == self.photosArray.count {
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
    
    private func generatePhotosArray(completion: @escaping ([PhotoObject]) -> ()) {
        var photosObjectArray: [PhotoObject] = []
        for photo in photosArray {
            DispatchQueue.global(qos: .utility).async {
                let ph = PhotoObject()
                ph.albumId = photo.albumId
                ph.id = photo.id
                ph.title = photo.title
                ph.thumbnailUrl = photo.thumbnailUrl
                ph.url = photo.url
                self.downloadImageFromUrl(url: photo.thumbnailUrl) { imageData in
                    ph.previewPhoto = imageData
                }
                self.downloadImageFromUrl(url: photo.url) { imageData in
                    ph.photo = imageData
                    photosObjectArray.append(ph)
                    if photosObjectArray.count == self.photosArray.count {
                        completion(photosObjectArray)
                    }
                }
            }
        }
    }
    
    func checkIsLoaded(id: Int) -> Bool {
        let storageManager = StorageManager()
        return storageManager.getAlbum(userId: id)?.count ?? 0 > 0
    }
    
}
