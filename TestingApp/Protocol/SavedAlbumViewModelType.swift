//
//  SavedAlbumViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 29.12.2020.
//

import Foundation
import RealmSwift
protocol SavedAlbumViewModelType {
    func getNumberOfSections() -> Int
    func getNumbersItemsInSection() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> SavedAlbumCellViewModelType?
    func getAlbum(for indexPath: IndexPath) -> AlbumObject
    func filteringAlbum(filterString: String?) -> Results<AlbumObject>!
    //MARK: Выбор ячейки
    func selectRow(atIndexPath indexPath: IndexPath)
    //MARK: Получить IndexPath выделенной ячейки
    func getIndexPathSelectedRow() -> IndexPath
}
