//
//  NetworkViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit
/// Протокол для работы вкладки 'сеть'
protocol NetworkViewModelType {
    
    /// Загрузить список альбомов
    func getAlbums()
    
    /// Количество секций
    func getNumberOfSections() -> Int
    
    /// Количество ячеек в секции
    func getNumbersItemsInSection() -> Int
    
    /// Получить ячейку
    /// - Parameter indexPath: indexPath
    func cellViewModel(forIndexPath indexPath: IndexPath) -> NetworkCellViewModelType?
    
    /// Получить альбом по indexPath
    /// - Parameter indexPath: indexPath
    func getAlbum(for indexPath: IndexPath) -> Album
    
    /// Проверить статус загрузки альбома
    /// - Parameter id: id альбома
    func checkIsLoaded(id: Int) -> Bool
    
    /// Выбор ячейки
    /// - Parameter indexPath: indexPath
    func selectRow(atIndexPath indexPath: IndexPath)
    
    /// Получить IndexPath выбранной ячейки
    func getIndexPathSelectedRow() -> IndexPath
    
}
