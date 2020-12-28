//
//  NetworkCellVM.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit
class NetworkCellVM: NetworkCellViewModelType {
    private let album: Album
    private let storageManager = StorageManager()
    var nameAlbum: String {album.title}
    
    /// Обновление статуса загрузки
    /// - Parameters:
    ///   - cell: ячейка для обновления
    ///   - status: статус загрузки 0 - не загружено, 1 - загружается, 2 - загружено
    func updateStatusLoading(cell: NetworkCell, status: Int?) {
        if let status = status {
            switch status {
            case 0:
                DispatchQueue.main.async {
                    cell.activityIndicatorView.stopAnimating()
                    cell.activityIndicatorView.isHidden = true
                    cell.networkStatusAlbumImage.image = UIImage(systemName: "icloud.and.arrow.down")
                    cell.networkStatusAlbumImage.tintColor = .systemBlue
                    cell.networkStatusAlbumImage.isHidden = false
                }
            case 1:
                DispatchQueue.main.async {
                    cell.networkStatusAlbumImage.isHidden = true
                    cell.activityIndicatorView.startAnimating()
                    cell.activityIndicatorView.isHidden = false
                }
            case 2:
                DispatchQueue.main.async {
                    cell.activityIndicatorView.stopAnimating()
                    cell.activityIndicatorView.isHidden = true
                    cell.networkStatusAlbumImage.image = UIImage(systemName: "checkmark.icloud")
                    cell.networkStatusAlbumImage.tintColor = .systemGreen
                    cell.networkStatusAlbumImage.isHidden = false
                }
            default:
                DispatchQueue.main.async {
                    cell.activityIndicatorView.stopAnimating()
                    cell.activityIndicatorView.isHidden = true
                    cell.networkStatusAlbumImage.image = UIImage(systemName: "exclamationmark.icloud")
                    cell.networkStatusAlbumImage.tintColor = .systemRed
                    cell.networkStatusAlbumImage.isHidden = false
                }
                break
            }
        } else {
            if storageManager.getAlbum(userId: album.id)?.count ?? 0 > 0 {
                DispatchQueue.main.async {
                    cell.activityIndicatorView.stopAnimating()
                    cell.activityIndicatorView.isHidden = true
                    cell.networkStatusAlbumImage.image = UIImage(systemName: "checkmark.icloud")
                    cell.networkStatusAlbumImage.tintColor = .systemGreen
                    cell.networkStatusAlbumImage.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    cell.activityIndicatorView.stopAnimating()
                    cell.activityIndicatorView.isHidden = true
                    cell.networkStatusAlbumImage.image = UIImage(systemName: "icloud.and.arrow.down")
                    cell.networkStatusAlbumImage.tintColor = .systemBlue
                    cell.networkStatusAlbumImage.isHidden = false
                }
            }
        }
    }
    
    init(album: Album) {
        self.album = album
    }
}
