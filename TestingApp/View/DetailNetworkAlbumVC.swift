//
//  DetailNetworkAlbumVC.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit

class DetailNetworkAlbumVC: UICollectionViewController {
    //MARK: Variables
    var album: Album?
    var indexPath: IndexPath?
    var statusLoading: Int?
    private let reuseIdentifier = "photoCell"
    private var viewModel: DetailNetworkAlbumViewModelType?
    private var countItems:CGFloat = 1
    //Отступ от краев экрана (и между ячейками, если их в строке больше 1)
    private let paddingPlit:CGFloat = 15
    private let loadingIndicator = SharedVariables.sharedVariables.loadingIndicator
    private let refreshControl = UIRefreshControl()
    
    //MARK: IBOutlets
    @IBOutlet var detailCollectionView: UICollectionView!
    @IBOutlet weak var downloadAlbumButton: UIBarButtonItem!
    
    //MARK: Overrides methods
    override func viewLayoutMarginsDidChange() {
        DispatchQueue.main.async { [self] in
            self.collectionView.reloadData()
            guard let viewModel = viewModel, let album = album else { return }
            if let statusLoading = statusLoading {
                updateStatusLoading(status: statusLoading)
            } else {
                viewModel.checkIsLoaded(id: album.id) ? setImageStatusLoading(color: .systemGreen, systemName: "checkmark.icloud") : setImageStatusLoading(color: .systemBlue, systemName: "icloud.and.arrow.down")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshControl()
        activityIndicator(startAnimate: true)
        viewModel = DetailNetworkAlbumVM()
        guard let viewModel = viewModel, let album = album else { return }
        viewModel.getPhotos(albumId: String(album.id))
        addObservers()
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
        case "showImage":
            guard let destination = segue.destination as? ViewImageVC else { return }
            let row = viewModel.getIndexPathSelectedRow().row
            destination.image = viewModel.getPhotosArray()[row].url
        default:
            break
        }
    }
    
    //MARK: IBActions func
    @IBAction func downloadAlbumButtonAction(_ sender: UIBarButtonItem) {
        DispatchQueue.global(qos: .background).async { [self] in
            guard let indexPath = self.indexPath else {return}
            NotificationCenter.default.post(name: Notification.Name("loadingStatus"),object: self,userInfo: ["status":[indexPath:1]])
            guard let viewModel = viewModel, let album = album else { return }
            viewModel.saveAlbum(album: album) { error in
                DispatchQueue.main.async { self.navigationItem.setRightBarButton(sender, animated: true) }
                error ? NotificationCenter.default.post(name: Notification.Name("loadingStatus"),object: self,userInfo: ["status":[indexPath:3]]) :
                    NotificationCenter.default.post(name: Notification.Name("loadingStatus"),object: self,userInfo: ["status":[indexPath:2]])
            }
        }
    }
    
    //MARK: Custom func
    /// Обновить значок статуса загрузки
    /// - Parameter status: статус загрузки 0 - не загружено, 1 - загружается, 2 - загружено
    private func updateStatusLoading(status: Int) {
        switch status {
        case 0: setImageStatusLoading(color: .systemBlue, systemName: "icloud.and.arrow.down")
        case 1: setImageStatusLoading(color: nil, systemName: nil)
        case 2: setImageStatusLoading(color: .systemGreen, systemName: "checkmark.icloud")
        default: setImageStatusLoading(color: .systemRed, systemName: "exclamationmark.icloud")
        }
    }
    
    /// Установка изображения в зависимости от статуса загрузки
    /// - Parameters:
    ///   - color: цвет
    ///   - image: изображение
    private func setImageStatusLoading(color: UIColor?, systemName image: String?) {
        if let color = color, let image = image {
            DispatchQueue.main.async { [self] in
                downloadAlbumButton.image = UIImage(systemName: image)
                downloadAlbumButton.tintColor = color
            }
        } else {
            DispatchQueue.main.async { [self] in
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                let barButton = UIBarButtonItem(customView: activityIndicator)
                self.navigationItem.setRightBarButton(barButton, animated: true)
                activityIndicator.startAnimating()
                downloadAlbumButton.tintColor = .clear
            }
        }
    }
    
    /// Запуск/остановка индикатора загрузки
    /// - Parameter startAnimate: включить/отключить анимацию
    private func activityIndicator(startAnimate: Bool) {
        if startAnimate {
            DispatchQueue.main.async() { [self] in
                self.view.addSubview(loadingIndicator)
                loadingIndicator.startAnimating()
                NSLayoutConstraint.activate([loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                             loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
                self.view.bringSubviewToFront(loadingIndicator)
            }
        } else {
            DispatchQueue.main.async() { [self] in
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            }
        }
    }
    
    /// Обновление записей
    func addRefreshControl() {
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        refreshControl.tintColor = UIColor(named: "borderNetworkCellColor")
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление записей ...")
    }
    
    /// Подпись на уведомления
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateInterface(notification:)), name: Notification.Name("loadingStatus"), object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(updateInterface(notification:)), name: Notification.Name("photoIsLoaded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateInterface(notification:)), name: Notification.Name("photosDeleted"), object: nil)
    }
    
    //MARK: OBJC func
    /// Обработчик refreshControl
    @objc func refreshList() {
        guard let viewModel = viewModel, let album = album else { return }
        viewModel.getPhotos(albumId: String(album.id))
    }
    
    /// Функция обработки notification
    /// - Parameter notification: входящий notification
    @objc func updateInterface(notification: Notification) {
        if let userInfo = notification.userInfo as? [String: [IndexPath:Int]], let status = userInfo["status"] {
            for (key,value) in status { if indexPath == key { updateStatusLoading(status: value) } }
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
                    guard let viewModel = viewModel, let album = album else { return }
                    DispatchQueue.main.async { [self] in
                        viewModel.checkIsLoaded(id: album.id) ? setImageStatusLoading(color: .systemGreen, systemName: "checkmark.icloud") : setImageStatusLoading(color: .systemBlue, systemName: "icloud.and.arrow.down")
                    }
                }
            }
        }
    }
    
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension DetailNetworkAlbumVC: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.selectRow(atIndexPath: indexPath)
        self.performSegue(withIdentifier: "showImage", sender: self)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DetailNetworkAlbumCell
        guard let collectionViewCell = cell, let viewModel = viewModel else { return UICollectionViewCell() }
        collectionViewCell.cellBackgroundView.layer.borderColor = UIColor(named: "borderNetworkCellColor")?.cgColor
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        collectionViewCell.viewModel = cellViewModel
        collectionViewCell.withCellConstraint.constant = getWidthPlits()
        collectionViewCell.previewImage.image = UIImage()
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
    
    func getEdgeInsets() -> UIEdgeInsets {
        let widthPlit = (collectionView.frame.width - paddingPlit * countItems) / countItems
        let superPadding = (collectionView.frame.width - widthPlit * countItems) / (countItems+1)
        let padding = (collectionView.frame.width - (superPadding + (countItems * widthPlit))) / countItems
        return UIEdgeInsets(top: 10, left: padding, bottom: 40, right: padding)
    }
    
    func getSizeItem() -> CGSize {
        return CGSize(width: (collectionView.frame.width - paddingPlit * countItems) / countItems, height: 150)
    }
    
    func getWidthPlits() -> CGFloat {
        return (collectionView.frame.width - paddingPlit * countItems) / countItems
    }
}
