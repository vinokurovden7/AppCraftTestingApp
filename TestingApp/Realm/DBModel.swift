//
//  DBModel.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//
import RealmSwift

/// Объект альбома
class AlbumObject: Object {
    @objc dynamic var albumObjectID = ""
    @objc dynamic var id = 0
    @objc dynamic var userId = 0
    @objc dynamic var title = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

/// Объект фотографии
class PhotoObject: Object {
    @objc dynamic var photoObjectId = ""
    @objc dynamic var id = 0
    @objc dynamic var albumId = 0
    @objc dynamic var title = ""
    @objc dynamic var url = ""
    @objc dynamic var thumbnailUrl = ""
    @objc dynamic var previewPhoto: Data?
    @objc dynamic var photo: Data?
    
    override class func primaryKey() -> String? {
        return "photoObjectId"
    }
}
