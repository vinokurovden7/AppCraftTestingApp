//
//  SharedVariables.swift
//  TestingApp
//
//  Created by Денис Винокуров on 28.12.2020.
//

import Foundation
import Alamofire
class SharedVariables {
    static let sharedVariables = SharedVariables()
    let sessionManager = Session.init(configuration: .default, serverTrustManager: ServerTrustManager(evaluators: ["via.placeholder.com": DisabledTrustEvaluator()]))
    
    let loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor(named: "borderNetworkCellColor")
        return spinner
    }()
}
