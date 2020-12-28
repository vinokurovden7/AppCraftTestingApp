//
//  DetailNetworkAlbumCellVM.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit
import Alamofire
class DetailNetworkAlbumCellVM: DetailNetworkAlbumCellViewModelType {
    
    let networkManager = NetworkRequests()
    private let photo: Photo
    var title: String {photo.title}
    var previewImageUrl: String {photo.thumbnailUrl}
    
    func getImageFromURL(session: Session, url: String, completion: @escaping (Data) -> ()) {
        networkManager.downloadImageFromUrl(sessionManager: session, url: url) { imageData in
            completion(imageData ?? (UIImage(systemName: "questionmark")?.pngData())!)
        }
    }
    
    init(photo: Photo) {
        self.photo = photo
    }
}
