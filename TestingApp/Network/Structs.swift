//
//  Structs.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import Foundation

/// Структура альбома
struct Album {
    let id: Int
    let title: String
    let userId: Int
    
    init?(json: [String:Any]) {
        let id = json["id"] as? Int
        let title = json["title"] as? String
        let userId = json["userId"] as? Int
        
        self.id = id ?? 0
        self.title = title ?? ""
        self.userId = userId ?? 0
    }
    
    static func getArray(from jsonArray: Any) -> [Album]? {
        guard let jsonArray = jsonArray as? Array<[String:Any]> else { return nil }
        return jsonArray.compactMap {Album(json: $0)}
    }
}

/// Структура фотографии альбома
struct Photo {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    
    init?(json: [String:Any]) {
        let albumId = json["albumId"] as? Int
        let id = json["id"] as? Int
        let title = json["title"] as? String
        let url = json["url"] as? String
        let thumbnailUrl = json["thumbnailUrl"] as? String
        
        self.albumId = albumId ?? 0
        self.id = id ?? 0
        self.title = title ?? ""
        self.url = url ?? ""
        self.thumbnailUrl = thumbnailUrl ?? ""
    }
    
    static func getArray(from jsonArray: Any) -> [Photo]? {
        guard let jsonArray = jsonArray as? Array<[String:Any]> else { return nil }
        return jsonArray.compactMap {Photo(json: $0)}
    }
}
