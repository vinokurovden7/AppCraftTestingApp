//
//  NetworkCellViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import Foundation
/// Протокол ячейки из вкладки 'сеть'
protocol NetworkCellViewModelType: class {
    /// Наименование альбома
    var nameAlbum: String {get}
    
    /// Обновить статус загрузки альбома
    /// - Parameters:
    ///   - cell: ячейка
    ///   - status: статус загрузки 0 - не загружено, 1 - загружается, 2 - загружено
    func updateStatusLoading(cell: NetworkCell, status: Int?)
}
