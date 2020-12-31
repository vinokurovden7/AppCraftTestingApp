//
//  NetworkRequestsViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import Foundation
/// Протокол для работы с сетью
protocol NetworkRequestsViewModelType {
    /// Получить список альбомов
    /// - Parameters:
    ///   - url: адрес запроса
    func getAlbums(url: String, completion: @escaping (_ albums: [Album]) -> ())
}
