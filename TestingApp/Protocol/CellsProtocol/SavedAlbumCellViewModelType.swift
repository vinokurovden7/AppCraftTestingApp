//
//  SavedAlbumCellViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 29.12.2020.
//

import Foundation
///Протокол ячейки из вкладки 'БД'
protocol SavedAlbumCellViewModelType: class {
    /// Наименование альбома
    var nameAlbum: String {get}
}
