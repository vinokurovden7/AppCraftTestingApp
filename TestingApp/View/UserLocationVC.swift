//
//  UserLocationVC.swift
//  TestingApp
//
//  Created by Денис Винокуров on 26.12.2020.
//

import UIKit
import CoreLocation

class UserLocationVC: UIViewController {
    //MARK: Variables
    private var playerViewModel: PlayerViewModelType?
    private var isStaringLocation: Bool = false
    private var locationManager: CLLocationManager?
    
    //MARK: IBOutlets
    @IBOutlet weak var labelUserLocation: UILabel!
    @IBOutlet weak var buttonUserLocation: UIButton!
    @IBOutlet weak var speedLabel: UILabel!
    
    
    //MARK: Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        playerViewModel = PlayerVM(fileName: "superMarioSound")
    }
    
    //MARK: IBActions func
    @IBAction func buttonUserlocationAction(_ sender: UIButton) {
        guard let playerViewModel = playerViewModel, let locationManager = locationManager else { return }
        if isStaringLocation {
            playerViewModel.stopPlayMusic()
            locationManager.showsBackgroundLocationIndicator = false
            locationManager.stopUpdatingLocation()
            DispatchQueue.main.async { [self] in
                buttonUserLocation.tintColor = .systemRed
                labelUserLocation.text = ""
                speedLabel.text = ""
            }
        } else {
            playerViewModel.playMusic()
            locationManager.showsBackgroundLocationIndicator = true
            locationManager.startUpdatingLocation()
            DispatchQueue.main.async { [self] in
                buttonUserLocation.tintColor = .systemGreen
            }
        }
        isStaringLocation = !isStaringLocation
    }
    
    //MARK: Custom func
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
    }
    
}

//MARK: CLLocationManagerDelegate
extension UserLocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async { [self] in
                labelUserLocation.text = "широта = \(location.coordinate.latitude) долгота = \(location.coordinate.longitude)"
                speedLabel.text = "текущая скорость: \(location.speed > 0 ? Int(location.speed*3.6) : 0) км/ч"
            }
        }
    }
}
