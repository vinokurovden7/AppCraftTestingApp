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
    //MARK: Variables
    private var retryCount = 0
    
    
    //MARK: Functions
    /// Отправка запроса на получение списка альбомов
    /// - Parameters:
    ///   - url: адрес запроса
    /// - Returns: массив альбомов
    func getAlbums(url: String, completion: @escaping (_ albums: [Album]) -> ()) {
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
    
    /// Отправка запроса на получение списка фотографий альбома
    /// - Parameters:
    ///   - url: адрес запроса
    ///   - parameters: параметры для запроса
    /// - Returns: Массив фотографий
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
    
    /// Загрузка изображения по указанному url
    /// - Parameters:
    ///   - url: адрес изображения
    /// - Returns: изображение тип Data
    func downloadImageFromUrl(sessionManager: Session, url: String, completion: @escaping (_ photo: Data?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            sessionManager.request(url).validate().responseData { [weak self]  response in
                switch response.result {
                case .success(let responseData):
                    completion(responseData)
                case .failure(let error):
                    if self?.retryCount ?? 0 <= 4 {
                        self?.retryCount += 1
                        self?.downloadImageFromUrl(sessionManager: sessionManager, url: url) { (photo) in
                            self?.retryCount = 0
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
