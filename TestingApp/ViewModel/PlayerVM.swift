//
//  PlayerVM.swift
//  TestingApp
//
//  Created by Денис Винокуров on 30.12.2020.
//

import AVFoundation
import Foundation
/// Класс для работы аудиоплеера
class PlayerVM: PlayerViewModelType {
    //MARK: Variables
    private var audioPlayer = AVAudioPlayer()
    
    
    //MARK: Protocol functions
    func playMusic() {
        audioPlayer.play()
    }
    
    func stopPlayMusic() {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
        }
    }
    
    //MARK: Init
    init(fileName: String) {
        let filePath = Bundle.main.path(forResource: fileName, ofType: "mp3")
        guard let fP = filePath else {return}
        let audiofile = URL.init(fileURLWithPath: fP)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audiofile)
        } catch {
            print(error)
        }
        audioPlayer.prepareToPlay()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
        } catch {
            print(error)
        }
    }
    
}
