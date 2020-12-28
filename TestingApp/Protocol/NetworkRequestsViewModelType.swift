//
//  NetworkRequestsViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import Foundation
protocol NetworkRequestsViewModelType {
    func getAlbumsRequest(url: String, completion: @escaping (_ albums: [Album]) -> ())
}
