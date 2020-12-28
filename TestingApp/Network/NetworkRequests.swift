//
//  NetworkRequests.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit
import Alamofire

/// Класс для работы с сетью
class NetworkRequests: NetworkRequestsViewModelType {
    
//    private let sessionManager = Session.init(configuration: .default, serverTrustManager: ServerTrustManager(evaluators: ["via.placeholder.com": DisabledTrustEvaluator()]))
    
    private var retryCount = 0
    
    /// Отправка запроса на получение списка альбомов
    /// - Parameters:
    ///   - url: адрес запроса
    /// - Returns: массив альбомов
    func getAlbumsRequest(url: String, completion: @escaping (_ albums: [Album]) -> ()) {
        guard let url = URL(string: url) else { return }
        AF.request(url, method: .get).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let albumsArray = Album.getArray(from: value) else {return}
                completion(albumsArray)
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
    func getPhotoAlbum(url: String, parameters: String, completion: @escaping (_ albums: [Photo]) -> ()) {
        guard let url = URL(string: url) else { return }
        AF.request(url, method: .get, parameters: ["albumId":parameters]).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let photoAlbumsArray = Photo.getArray(from: value) else {return}
                completion(photoAlbumsArray)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func downloadImageFromUrl(sessionManager: Session, url: String, completion: @escaping (_ photo: Data?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            sessionManager.request(url).validate().responseData { response in
                switch response.result {
                case .success(let responseData):
                    completion(responseData)
                case .failure(let error):
                    if self.retryCount <= 5 {
                        self.retryCount += 1
                        self.downloadImageFromUrl(sessionManager: sessionManager, url: url) { (photo) in
                            self.retryCount = 0
                            completion(photo)
                        }
                    } else {
                        print("Error ---> \(error)")
                        completion(nil)
                    }
                }
            }
        }
        
    }
}
