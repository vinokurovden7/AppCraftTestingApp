//
//  DetailSavedAlbumsVC.swift
//  TestingApp
//
//  Created by Денис Винокуров on 29.12.2020.
//

import UIKit


class DetailSavedAlbumsVC: UICollectionViewController {

    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
    //MARK: Переменные
    private let reuseIdentifier = "savedPhotoCell"
    private var viewModel: DetailSavedAlbumViewModelType?
    //Количество ячеек в строке
    private var countItems:CGFloat = 1
    //Отступ от краев экрана и между ячейками, если их в строке больше 1
    private let paddingPlit:CGFloat = 15
    var albumId: Int?
    
    //MARK: Жизненный цикл
    override func viewLayoutMarginsDidChange() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let albumId = albumId else { return }
        viewModel = DetailSavedAlbumVM(albumId: albumId)
        NotificationCenter.default.addObserver(self, selector: #selector(updateInterface(notification:)), name: Notification.Name("photoLoaded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateInterface(notification:)), name: Notification.Name("photosDeleted"), object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    /// Функция обработки notification
    /// - Parameter notification: входящий notification
    @objc func updateInterface(notification: Notification) {
        if let userInfo = notification.userInfo as? [String: Bool] {
            if let isLoaded = userInfo["isLoaded"] {
                if isLoaded {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            } else if let isDeleted = userInfo["isDeleted"] {
                if isDeleted {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

    @IBAction func deleteBarButtonItemAction(_ sender: UIBarButtonItem) {
        guard let viewModel = viewModel else { return }
        self.present(viewModel.confirmDeleteAlert(), animated: true)
    }
}
extension DetailSavedAlbumsVC: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "showDetailAlbum", sender: self)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DetailSavedAlbumCell
        guard let collectionViewCell = cell, let viewModel = viewModel else { return UICollectionViewCell() }
        collectionViewCell.cellBackgroundView.layer.borderColor = UIColor(named: "borderNetworkCellColor")?.cgColor
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        collectionViewCell.viewModel = cellViewModel
        collectionViewCell.withIthemConstraint.constant = getWidthPlits()
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
