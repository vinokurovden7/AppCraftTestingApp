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
    
    /// Удаление альбома
    /// - Parameter album: альбом
    func deleteAlbum(album: AlbumObject) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(album)
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
    
    func getAlbum(userId: Int) -> Results<AlbumObject>! {
        let realm = try! Realm()
        return realm.objects(AlbumObject.self).filter("id == %@", userId)
    }
    
}
