//
//  DetailNetworkAlbumCellViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit
import Alamofire
///Протокол ячейки детализации из вкладки 'сеть
protocol DetailNetworkAlbumCellViewModelType: class {
    /// Наименование фото
    var title: String {get}
    /// Адрес изображения
    var previewImageUrl: String {get}
    /// Загрузка изображения
    /// - Parameters:
    ///   - url: адрес изображения
    func getImageFromURL(session: Session, url: String, completion: @escaping (_ imageData: Data)->())
}
