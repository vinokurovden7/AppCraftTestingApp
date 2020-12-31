//
//  PlayerViewModelType.swift
//  TestingApp
//
//  Created by Денис Винокуров on 30.12.2020.
//

import CoreLocation
/// Протокол для аудиоплеера
protocol PlayerViewModelType {
    
    /// Начать проигрывание
    func playMusic()
    /// Остановить проигрывание
    func stopPlayMusic()
    
}
