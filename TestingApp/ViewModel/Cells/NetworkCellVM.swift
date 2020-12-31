//
//  NetworkCellVM.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit
/// Класс ячейки вкладки 'сеть'
class NetworkCellVM: NetworkCellViewModelType {
    //MARK: Variables
    private let album: Album
    private let storageManager = StorageManager()
    var nameAlbum: String {album.title}
    
    //MARK: Protocols functions
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
            if storageManager.getAlbum(userId: album.id, title: nil)?.count ?? 0 > 0 {
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
    
    //MARK: Init
    init(album: Album) {
        self.album = album
    }
}
