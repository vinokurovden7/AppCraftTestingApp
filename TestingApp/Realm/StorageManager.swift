//
//  StorageManager.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import RealmSwift

class StorageManager {
    
    //MARK: Работа с альбомом
    /// Сохранение альбома
    /// - Parameter album: альбом
    func saveAlbum(album: AlbumObject) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(album, update: .modified)
        }
    }
    
    /// Сохранение фотграфий альбома
    /// - Parameter photoArray: массив фотографий
    func savePhoto(photo: PhotoObject) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(photo, update: .modified)
        }
    }
    
    func getAlbum(userId: Int?, title: String?) -> Results<AlbumObject>! {
        if let id = userId, let title = title {
            let realm = try! Realm()
            return realm.objects(AlbumObject.self).filter("id == %@ and title CONTAINS[c] %@", id, title).sorted(byKeyPath: "userId").sorted(byKeyPath: "id")
        } else if let id = userId {
            let realm = try! Realm()
            return realm.objects(AlbumObject.self).filter("id == %@", id).sorted(byKeyPath: "userId").sorted(byKeyPath: "id")
        } else if let title = title  {
            let realm = try! Realm()
            return realm.objects(AlbumObject.self).filter("title CONTAINS[c] %@", title).sorted(byKeyPath: "userId").sorted(byKeyPath: "id")
        } else {
            let realm = try! Realm()
            return realm.objects(AlbumObject.self).sorted(byKeyPath: "userId").sorted(byKeyPath: "id")
        }
        
    }
    
    func getPhoto(albumId: Int, title: String?) -> Results<PhotoObject>! {
        if let title = title  {
            let realm = try! Realm()
            return realm.objects(PhotoObject.self).filter("albumId == %@ and title CONTAINS[c] %@", albumId, title).sorted(byKeyPath: "id")
        } else {
            let realm = try! Realm()
            return realm.objects(PhotoObject.self).filter("albumId == %@", albumId).sorted(byKeyPath: "id")
        }
        
    }
    
    /// Удаление фотографий альбома
    /// - Parameter photosArray: Массив альбомов
    func deleteAlbumWithPhoto(albumId: Int) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(getPhoto(albumId: albumId, title: nil))
        }
        let album = realm.objects(AlbumObject.self).filter("id == %@", albumId)
        try! realm.write {
            realm.delete(album)
        }
    }
    
}
