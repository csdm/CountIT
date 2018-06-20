//
//  ViewController.swift
//  CountIT
//
//  Created by Claudio S. Di Mauro on 29/05/18.
//  Copyright © 2018 Claudio S. Di Mauro. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox //used for vibration on tap of the counter
import CoreData

class ViewController: UIViewController {
    //outlets
    @IBOutlet var numbers: UILabel!
    
    //constants
    
    //variables
    var i: Int = 0
    var clickSound = Bundle.main.url(forResource: "click", withExtension: "aiff")
    var decremClickSound = Bundle.main.url(forResource: "decremClick", withExtension: "aiff")
    var audioPlayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //NavigationBar hiding
        self.navigationController?.isNavigationBarHidden = true
        /****************************************/
        
        
        //numbers.text = String(i)
        numbers.text = "0000"
        numbers.backgroundColor = UIColor.black
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //check on the first time app opening - implemented the first time volume value in AppDelegate
        UserDefaults.standard.set(true, forKey: "notfirstTime")
    }

    
    @IBAction func counter(_ sender: Any) {
        //control for non over 9999
        if i == 9999 {
            i = 9999
        }
        else {
            i += 1
            
            //Vibration on button pressure
            /*AudioServicesPlayAlertSound(kSystemSoundID_Vibrate) //-> intense vibration
             AudioServicesPlaySystemSound(1519) //-> Actuate `Peek` feedback (weak boom)
             AudioServicesPlaySystemSound(1520) //-> Actuate `Pop` feedback (strong boom)
             AudioServicesPlaySystemSound(1521) //-> Actuate `Nope` feedback (series of three weak booms)*/

            
            Singleton.shared.vibration = UserDefaults.standard.bool(forKey: "vibration")
            switch Singleton.shared.vibration {
            case true:
                AudioServicesPlaySystemSound(1519)
                print("Vib")
            case false:
                print("NoVib")
            }
            
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: clickSound!)
                audioPlayer.play()
                audioPlayer.volume = UserDefaults.standard.float(forKey: "volume")
                
            } catch {
                print("couldn't load sound file")
            }
        }
        
        if i <= 9 {
            numbers.text = "000" + String(i)
        }
        else if i <= 99 {
            numbers.text = "00" + String(i)
        }
        else if i <= 999 {
            numbers.text = "0" + String(i)
        }
    }
    
    
    @IBAction func decrementer(_ sender: Any) {
        //Control for non under-zero values
        if i == 0 {
            i = 0
        }
        else {
            i -= 1
            
            Singleton.shared.vibration = UserDefaults.standard.bool(forKey: "vibration")
            switch Singleton.shared.vibration {
            case true:
                AudioServicesPlaySystemSound(1521)
                print("Vib")
            case false:
                print("NoVib")
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: decremClickSound!)
                audioPlayer.play()
                audioPlayer.volume = UserDefaults.standard.float(forKey: "volume")
            } catch {
                print("couldn't load sound file")
            }
        }
        
        if i <= 9 {
            numbers.text = "000" + String(i)
        }
        else if i <= 99 {
            numbers.text = "00" + String(i)
        }
        else if i <= 999 {
            numbers.text = "0" + String(i)
        }
    }
    
    
    @IBAction func refresh(_ sender: Any) {
        i = Singleton.shared.refresh //i = 0
        numbers.text = "000" + String(i)
        
        Singleton.shared.vibration = UserDefaults.standard.bool(forKey: "vibration")
        switch Singleton.shared.vibration {
        case true:
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            print("Vib")
        case false:
            print("NoVib")
        }
    }
}

