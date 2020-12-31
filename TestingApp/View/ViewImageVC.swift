//
//  ViewImageVC.swift
//  TestingApp
//
//  Created by Денис Винокуров on 30.12.2020.
//

import UIKit

class ViewImageVC: UIViewController {
    //MARK: Variables
    private let networkManager = NetworkRequests()
    private let loadingIndicator = SharedVariables.sharedVariables.loadingIndicator
    var imageScrollView: ImageScrollView?
    var image: Any?
    
    //MARK: Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        checkImage()
    }
    
    //MARK: Custom func
    /// Проверка изображения
    private func checkImage() {
        if let img = image as? UIImage {
            imageScrollView = ImageScrollView(frame: view.bounds)
            guard let imageScrollView = imageScrollView else { return }
            view.addSubview(imageScrollView)
            setupImageScrollView()
            imageScrollView.set(image: img)
        } else if let imageUrl = image as? String {
            activityIndicator(startAnimate: true)
            networkManager.downloadImageFromUrl(sessionManager: SharedVariables.sharedVariables.sessionManager, url: imageUrl) { [self] (image) in
                guard let imageData = image else {return}
                self.activityIndicator(startAnimate: false)
                imageScrollView = ImageScrollView(frame: view.bounds)
                guard let imageScrollView = imageScrollView else { return }
                view.addSubview(imageScrollView)
                setupImageScrollView()
                imageScrollView.set(image: UIImage(data: imageData)!)
            }
        }
    }
    
    /// Запуск/остановка индикатора загрузки
    /// - Parameter startAnimate: включить/отключить анимацию
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
    
    /// Размещение imageScrollView
    private func setupImageScrollView() {
        imageScrollView?.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}
