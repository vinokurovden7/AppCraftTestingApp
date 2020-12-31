//
//  NetworkVM.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit
/// Класс работы с сетью
class NetworkVM: NetworkViewModelType {
    //MARK: Variables
    private var albumsArray: [Album] = []
    private let albumsUrl = "https://jsonplaceholder.typicode.com/albums"
    private let storageManager = StorageManager()
    private var selectedIndexPath: IndexPath?
    
    //MARK: Protocol functions
    func getAlbums() {
        let networkManager: NetworkRequestsViewModelType = NetworkRequests()
        networkManager.getAlbums(url: albumsUrl, completion: { [self] albums in
            albumsArray = albums
            NotificationCenter.default.post(name: Notification.Name("albumIsLoaded"),object: nil, userInfo: ["isLoaded":true])
        })
    }

    func getNumberOfSections() -> Int {
        return 1
    }

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
        return storageManager.getAlbum(userId: id, title: nil)?.count ?? 0 > 0
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func getIndexPathSelectedRow() -> IndexPath {
        return self.selectedIndexPath ?? IndexPath(row: 0, section: 0)
    }

}
