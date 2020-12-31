//
//  DetailSavedAlbumViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 29.12.2020.
//

import UIKit
/// Протокол для работы детализации вкладки БД
protocol DetailSavedAlbumViewModelType {
    
    /// Получить фото по indexPath
    /// - Parameter indexPath: indexPath
    func getPhotos(for indexPath: IndexPath) -> PhotoObject
    
    /// Количество секций
    func getNumberOfSections() -> Int
    
    /// Количество ячеек в секции
    func getNumbersItemsInSection() -> Int
    
    /// Получить ячейку по indexPath
    /// - Parameter indexPath: indexPath
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DetailSavedAlbumCellViewModelType?
    
    /// Алерт с подтверждением удаления альбома с фотографиями
    func confirmDeleteAlert() -> UIAlertController
    
    /// Выбор ячейки
    func selectRow(atIndexPath indexPath: IndexPath)
    
    /// Получить IndexPath выбранной ячейки
    func getIndexPathSelectedRow() -> IndexPath
}
