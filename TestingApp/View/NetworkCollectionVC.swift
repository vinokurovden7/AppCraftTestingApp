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
    //Количество ячеек в строке
    private var countItems:CGFloat = 1
    //Отступ от краев экрана и между ячейками, если их в строке больше 1
    private let paddingPlit:CGFloat = 15
    private var dictionaryLoadingStatusForIndexPath: [IndexPath:Int] = [:]
    @IBOutlet var albumsCollectionView: UICollectionView!
    private let loadingIndicator = SharedVariables.sharedVariables.loadingIndicator
    private let refreshControl = UIRefreshControl()
    
    //MARK: Жизненный цикл
    override func viewLayoutMarginsDidChange() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshControl()
        NotificationCenter.default.addObserver(self, selector: #selector(updateInterface(notification:)), name: Notification.Name("albumIsLoaded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateInterface(notification:)), name: Notification.Name("photosDeleted"), object: nil)
        activityIndicator(startAnimate: true)
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
            let indexPath = viewModel.getIndexPathSelectedRow()
            destination.album = viewModel.getAlbum(for: indexPath)
            destination.indexPath = indexPath
            destination.statusLoading = dictionaryLoadingStatusForIndexPath[indexPath]
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
            if let isLoaded = userInfo["isLoaded"] {
                if isLoaded {
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                        self.collectionView.reloadData()
                    }
                    activityIndicator(startAnimate: false)
                }
            } else if let isDeleted = userInfo["isDeleted"] {
                if isDeleted {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    private func activityIndicator(startAnimate: Bool) {
        if startAnimate {
            DispatchQueue.main.async(){ [self] in
                self.view.addSubview(loadingIndicator)
                loadingIndicator.startAnimating()
                NSLayoutConstraint.activate([loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                             loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
                self.view.bringSubviewToFront(loadingIndicator)
            }
        } else {
            DispatchQueue.main.async(){ [self] in
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            }
        }
    }
    
    //Обновление записей
    private func addRefreshControl(){
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        refreshControl.tintColor = UIColor(named: "borderNetworkCellColor")
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление записей ...")
    }
    
    @objc func refreshList(){
        guard let viewModel = viewModel else { return }
        viewModel.getAlbums()
    }
    
}
// MARK: UICollectionViewDelegate
extension NetworkCollectionVC: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {return}
        viewModel.selectRow(atIndexPath: indexPath)
        UIView.animate(withDuration: 0.12, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
            collectionView.cellForItem(at: indexPath)?.transform.a = 0.9
            collectionView.cellForItem(at: indexPath)?.transform.d = 0.9
        }) { (_) in
            UIView.animate(withDuration: 0.12, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
                collectionView.cellForItem(at: indexPath)?.transform.a = 1
                collectionView.cellForItem(at: indexPath)?.transform.d = 1
            })
        }
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
            if status != 1 { dictionaryLoadingStatusForIndexPath.removeValue(forKey: indexPath) }
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
