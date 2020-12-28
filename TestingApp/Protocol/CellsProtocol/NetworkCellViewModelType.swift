//
//  NetworkCellViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import Foundation
protocol NetworkCellViewModelType: class {
    var nameAlbum: String {get}
    func updateStatusLoading(cell: NetworkCell, status: Int?)
}
