//
//  NetworkVM.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit
class NetworkVM: NetworkViewModelType {
    
    //MARK: Свойства
    private var albumsArray: [Album] = []
    private let albumsUrl = "https://jsonplaceholder.typicode.com/albums"
    private let storageManager = StorageManager()
    
    //MARK: Методы
    /// Получение альбомов из сети
    func getAlbums() {
        let networkManager: NetworkRequestsViewModelType = NetworkRequests()
        networkManager.getAlbumsRequest(url: albumsUrl, completion: { [self] albums in
            albumsArray = albums
            NotificationCenter.default.post(name: Notification.Name("albumIsLoaded"),object: nil, userInfo: ["isLoaded":true])
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
        })
    }
    
    /// Получение количества секций
    /// - Returns: количество секций
    func getNumberOfSections() -> Int {
        return 1
    }
    
    /// Получение количества строк в секции
    /// - Returns: количество строк
    func getNumbersItemsInSection() -> Int {
        return albumsArray.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> NetworkCellViewModelType? {
        let album = albumsArray[indexPath.row]
        return NetworkCellVM(album: album)
    }
    
    func getAlbum(for indexPath: IndexPath) -> Album {
        let album = albumsArray[indexPath.row]
        return album
    }
    
    func checkIsLoaded(id: Int) -> Bool {
        return storageManager.getAlbum(userId: id)?.count ?? 0 > 0
    }

}
