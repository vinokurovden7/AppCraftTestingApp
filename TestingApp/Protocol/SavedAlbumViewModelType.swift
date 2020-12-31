//
//  SavedAlbumViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 29.12.2020.
//

import Foundation
import RealmSwift
/// Протокол для работы вкладки БД
protocol SavedAlbumViewModelType {
    
    /// Количество секций
    func getNumberOfSections() -> Int
    
    /// Количество ячеек в секции
    func getNumbersItemsInSection() -> Int
    
    /// Получить ячейку по indexPAth
    /// - Parameter indexPath: indexPath
    func cellViewModel(forIndexPath indexPath: IndexPath) -> SavedAlbumCellViewModelType?
    
    /// Получить альбом из БД
    /// - Parameter indexPath: indexPath
    func getAlbum(for indexPath: IndexPath) -> AlbumObject
    
    /// Получить отфильтрованный список альбомов по-наименованию
    /// - Parameter filterString: наименование
    func filteringAlbum(filterString: String?) -> Results<AlbumObject>!
    
    
    /// Выбор ячейки по indexPath
    /// - Parameter indexPath: indexPath
    func selectRow(atIndexPath indexPath: IndexPath)
    
    
    /// Получить IndexPath выбранной ячейки
    func getIndexPathSelectedRow() -> IndexPath
}
