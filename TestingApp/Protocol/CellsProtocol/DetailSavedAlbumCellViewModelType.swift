//
//  DetailSavedAlbumCellViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 29.12.2020.
//

import UIKit
/// Протокол ячейки детализации из вкладки 'БД'
protocol DetailSavedAlbumCellViewModelType: class {
    /// Наименование фото
    var title: String {get}
    /// Изображение
    var previewImage: UIImage {get}
}
