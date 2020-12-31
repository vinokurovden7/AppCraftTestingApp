//
//  SharedVariables.swift
//  TestingApp
//
//  Created by Денис Винокуров on 28.12.2020.
//

import Foundation
import Alamofire
class SharedVariables {
    //MARK: Variables
    static let sharedVariables = SharedVariables()
    /// Настройка sessionManager для доступа к 'via.placeholder.com'
    let sessionManager = Session.init(configuration: .default, serverTrustManager: ServerTrustManager(evaluators: ["via.placeholder.com": DisabledTrustEvaluator()]))
    
    /// Индикатор загрузки
    let loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor(named: "borderNetworkCellColor")
        return spinner
    }()
}
