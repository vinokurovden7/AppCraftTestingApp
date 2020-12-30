//
//  NetworkViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit
protocol NetworkViewModelType {
    func getAlbums()
    func getNumberOfSections() -> Int
    func getNumbersItemsInSection() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> NetworkCellViewModelType?
    func getAlbum(for indexPath: IndexPath) -> Album
    func checkIsLoaded(id: Int) -> Bool
    //MARK: Выбор ячейки
    func selectRow(atIndexPath indexPath: IndexPath)
    //MARK: Получить IndexPath выделенной ячейки
    func getIndexPathSelectedRow() -> IndexPath
}
