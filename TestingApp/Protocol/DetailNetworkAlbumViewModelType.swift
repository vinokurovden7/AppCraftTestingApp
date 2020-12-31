//
//  DetailNetworkAlbumViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import Foundation
/// Протокол для работы детализации вкладки 'сеть'
protocol DetailNetworkAlbumViewModelType {
    
    /// Получить фото из сети
    /// - Parameter albumId: id альбома
    func getPhotos(albumId: String)
    
    /// Количество секций
    func getNumberOfSections() -> Int
    
    /// Количество ячеек в секции
    func getNumbersItemsInSection() -> Int
    
    /// Получить ячейку по indexPath
    /// - Parameter indexPath: indexPath
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DetailNetworkAlbumCellViewModelType?
    
    /// Сохранить альбом в БД
    /// - Parameters:
    ///   - album: Альбом
    func saveAlbum(album: Album, completion: @escaping (Bool) -> ())
    
    /// Получить массив фотографий
    func getPhotosArray() -> [Photo]
    
    /// Загрузить изображение по-ссылке
    /// - Parameters:
    ///   - url: адрес изображения
    func downloadImageFromUrl(url: String, completion: @escaping (Data?) -> ())
    
    /// Проверить статус загрузки
    /// - Parameter id: id альбома
    func checkIsLoaded(id: Int) -> Bool
    
    
    /// Выбор ячейки
    /// - Parameter indexPath: indexPath
    func selectRow(atIndexPath indexPath: IndexPath)
    
    /// Получить IndexPath выбранной ячейки
    func getIndexPathSelectedRow() -> IndexPath
}
