//
//  DetailNetworkAlbumCellViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit
import Alamofire
protocol DetailNetworkAlbumCellViewModelType: class {
    var title: String {get}
    var previewImageUrl: String {get}
    func getImageFromURL(session: Session, url: String, completion: @escaping (_ imageData: Data)->())
}
