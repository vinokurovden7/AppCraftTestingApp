//
//  NetworkCollectionVC.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit

class NetworkCollectionVC: UICollectionViewController {

    //MARK: Переменные
    private let reuseIdentifier = "networkAlbumCell"
    private var viewModel: NetworkViewModelType?
    private var globalIndexPath: IndexPath? = nil
    //Количество ячеек в строке
    private var countItems:CGFloat = 1
    //Отступ от краев экрана и между ячейками, если их в строке больше 1
    private let paddingPlit:CGFloat = 15
    private var dictionaryLoadingStatusForIndexPath: [IndexPath:Int] = [:]
    
    @IBOutlet var albumsCollectionView: UICollectionView!
    
    //MARK: Жизненный цикл
    override func viewLayoutMarginsDidChange() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateInterface(notification:)), name: Notification.Name("albumIsLoaded"), object: nil)
        viewModel = NetworkVM()
        guard let viewModel = viewModel else { return }
        viewModel.getAlbums()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewModel = viewModel else {return}
        switch segue.identifier {
        case "showDetailAlbum":
            guard let destination = segue.destination as? DetailNetworkAlbumVC else { return }
            NotificationCenter.default.addObserver(self, selector: #selector(updateInterface(notification:)), name: Notification.Name("loadingStatus"), object: destination)
            if let indexPath = globalIndexPath {
                destination.album = viewModel.getAlbum(for: indexPath)
                destination.indexPath = indexPath
                destination.statusLoading = dictionaryLoadingStatusForIndexPath[indexPath]
            }
        default:
            break
        }
    }
    
    /// Функция обработки notification
    /// - Parameter notification: входящий notification
    @objc func updateInterface(notification: Notification) {
        if let userInfo = notification.userInfo as? [String: [IndexPath:Int]]
        {
            if let status = userInfo["status"] {
                for (key,value) in status {
                    dictionaryLoadingStatusForIndexPath[key] = value
                    DispatchQueue.main.async {
                        self.collectionView.reloadItems(at: [key])
                    }
                }
            }
        } else if let userInfo = notification.userInfo as? [String: Bool] {
            guard let isLoaded = userInfo["isLoaded"] else {return}
            if isLoaded {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}
// MARK: UICollectionViewDelegate
extension NetworkCollectionVC: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        globalIndexPath = indexPath
        self.performSegue(withIdentifier: "showDetailAlbum", sender: self)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let viewModel = viewModel else { return 1 }
        return viewModel.getNumberOfSections()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 1 }
        return viewModel.getNumbersItemsInSection()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? NetworkCell
        guard let collectionViewCell = cell, let viewModel = viewModel else { return UICollectionViewCell() }
        collectionViewCell.cellBackgroundView.layer.borderColor = UIColor(named: "borderNetworkCellColor")?.cgColor
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        collectionViewCell.viewModel = cellViewModel
        collectionViewCell.withIthemConstraint.constant = getWidthPlits()
        if let status = dictionaryLoadingStatusForIndexPath[indexPath] {
            guard let cellVM = cellViewModel else {return collectionViewCell}
            cellVM.updateStatusLoading(cell: collectionViewCell, status: status)
        } else {
            guard let cellVM = cellViewModel else {return collectionViewCell}
            cellVM.updateStatusLoading(cell: collectionViewCell, status: nil)
        }
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return getEdgeInsets()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getSizeItem()
    }
    
    private func getEdgeInsets() -> UIEdgeInsets {
        let widthPlit = (collectionView.frame.width - paddingPlit * countItems) / countItems
        let superPadding = (collectionView.frame.width - widthPlit * countItems) / (countItems+1)
        let padding = (collectionView.frame.width - (superPadding + (countItems * widthPlit))) / countItems
        return UIEdgeInsets(top: 10, left: padding, bottom: 40, right: padding)
    }
    
    private func getSizeItem() -> CGSize {
        return CGSize(width: (collectionView.frame.width - paddingPlit * countItems) / countItems, height: 50)
    }
    
    private func getWidthPlits() -> CGFloat {
        return (collectionView.frame.width - paddingPlit * countItems) / countItems
    }
    
}
