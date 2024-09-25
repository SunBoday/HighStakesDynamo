//
//  StakesExt+UIViewController.swift
//  HighStakesDynamo
//
//  Created by SunTory on 2024/9/25.
//

import Foundation
import UIKit
import AVFoundation

extension UIViewController{
    
    static var audioPlayer: AVAudioPlayer?
    
    func playSound() {
        
        if let path = Bundle.main.path(forResource: "Win.wav", ofType:nil) {
            let url = URL(fileURLWithPath: path)

            do {
                UIViewController.audioPlayer = try AVAudioPlayer(contentsOf: url)
                UIViewController.audioPlayer?.play()
            } catch {
                // Handle the error here
                print("Couldn't load file")
            }
        }
    }
    
    func playWin() {
        
        if let path = Bundle.main.path(forResource: "a1.wav", ofType:nil) {
            let url = URL(fileURLWithPath: path)

            do {
                UIViewController.audioPlayer = try AVAudioPlayer(contentsOf: url)
                UIViewController.audioPlayer?.play()
            } catch {
                // Handle the error here
                print("Couldn't load file")
            }
        }
    }

    func playWrong() {
        
        if let path = Bundle.main.path(forResource: "Wrong.wav", ofType:nil) {
            let url = URL(fileURLWithPath: path)

            do {
                UIViewController.audioPlayer = try AVAudioPlayer(contentsOf: url)
                UIViewController.audioPlayer?.play()
            } catch {
                // Handle the error here
                print("Couldn't load file")
            }
        }
    }
    
}


