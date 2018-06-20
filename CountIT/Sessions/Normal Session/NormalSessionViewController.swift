//
//  NormalSessionViewController.swift
//  CountIT
//
//  Created by Claudio S. Di Mauro on 30/05/18.
//  Copyright © 2018 Claudio S. Di Mauro. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import AudioToolbox

var i: Int = 0
var clickSound = Bundle.main.url(forResource: "click", withExtension: "aiff")
var decremClickSound = Bundle.main.url(forResource: "decremClick", withExtension: "aiff")
var audioPlayer = AVAudioPlayer()


class NormalSessionViewController: UIViewController {
    //outlets
    @IBOutlet var numbers: UILabel!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    //constants
    
    
    //variables

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NavigationBar showing
        self.navigationController?.isNavigationBarHidden = false
        
        //numbers.text = String(i)
        numbers.text = "0000"
        numbers.backgroundColor = UIColor.black
        saveButton.isEnabled = false
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //refreshing counter
        refreshCounterWithoutVibration()
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
        
        if i > 0 {
            saveButton.isEnabled = true
        }
        
        Singleton.shared.normalSessionValue = Int16(i)
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
        
        if i == 0 {
            saveButton.isEnabled = false
        }
        
        Singleton.shared.normalSessionValue = Int16(i) //passo il valore di i alla singleton
    }
    
    
    @IBAction func refresh(_ sender: Any) {
        refreshCounter()
        if i == 0 {
            saveButton.isEnabled = false
        }
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Save session", message: "Enter a title for this session", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let textFields = alertController.textFields,
                textFields.count > 0
                else {
                    // Could not find textfield
                    return
            }
            let field = textFields[0]
            print(field)
            
            //preparazione dati per il salvataggio
            var iValue = Singleton.shared.normalSessionValue
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let result = formatter.string(from: date)
            let title = field.text!
            
            print("\n\niValue = \(iValue)")
            print("Title = \(title)")
            print("Date = \(result)")
            
            CoreDataManager.saveNormalSession(title: title, count: iValue, date: result)
            
            self.refreshCounter()
            self.savedPopUp()            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //Inserire un controllo sul titolo vuoto
        /*
         if alertController.textFields?.isEmpty == true {
         alertController.message = "ENTER A TITLE!"
         }
         */
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func refreshCounter() {
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
        
        Singleton.shared.normalSessionValue = Int16(i)
    }
    
    
    func refreshCounterWithoutVibration() {
        i = Singleton.shared.refresh //i = 0
        numbers.text = "000" + String(i)

        Singleton.shared.normalSessionValue = Int16(i)
    }
    
    
    func savedPopUp() {
        let alertController = UIAlertController(title: "Great!", message: "The count has been saved succesfully.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
            //return to the top viewController, after confirmation
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
