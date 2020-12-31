//
//  DetailSavedAlbumCellVM.swift
//  TestingApp
//
//  Created by Денис Винокуров on 29.12.2020.
//

import UIKit
/// Класс ячейки детализации вкладки 'БД'
class DetailSavedAlbumCellVM: DetailSavedAlbumCellViewModelType {
    //MARK: Variables
    private let photo: PhotoObject
    var title: String {photo.title}
    var previewImage: UIImage {UIImage(data: (photo.previewPhoto ?? UIImage(systemName: "apple")!.pngData())!)!}
    
    //MARK: Init
    init(photo: PhotoObject) {
        self.photo = photo
    }
}
