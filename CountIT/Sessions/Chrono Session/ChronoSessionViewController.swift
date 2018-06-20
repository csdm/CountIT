//
//  ChronoSessionViewController.swift
//  CountIT
//
//  Created by Claudio S. Di Mauro on 30/05/18.
//  Copyright © 2018 Claudio S. Di Mauro. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox //used for vibration on tap of the counter
import CoreData

class ChronoSessionViewController: UIViewController {
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    /******STOPWATCH DECLARATIONS******/
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var status: Bool = false
    var globalTimeValue = String() //mi serve per passare il valore del timer nel coreData
    
    @IBOutlet var labelMinute: UILabel!
    @IBOutlet var labelSecond: UILabel!
    @IBOutlet var labelMillisecond: UILabel!
    @IBOutlet var labelHour: UILabel!
    @IBOutlet var startStopLabel: UIButton!
    /***************************/
    
    /******COUNTER DECLATATIONS******/
    var i: Int = 0
    
    @IBOutlet var numbers: UILabel!
    @IBOutlet var incrementBtn: UIButton!
    @IBOutlet var decrementBtn: UIButton!
    /***************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //showing navigation controller
        self.navigationController?.isNavigationBarHidden = false
        
        numbers.text = "0000"
        
        //starting the app with disabled value for the buttons
        refreshButton.isEnabled = false
        incrementBtn.isEnabled = false
        decrementBtn.isEnabled = false
        saveButton.isEnabled = false
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        refreshCounterWithoutVibration()
        refreshChrono()
        let startImage = UIImage(named: "start.pdf")
        startStopLabel.setImage(startImage, for: .normal)
    }
    
    
    @IBAction func startStopButton(_ sender: Any) {
        // If button status is true use stop function, relabel button and enable reset button
        if (status) {
            stop()
            let startImage = UIImage(named: "start.pdf")
            //startStopLabel.setTitle("START", for: .normal)
            startStopLabel.setImage(startImage, for: .normal)
            refreshButton.isEnabled = true
            incrementBtn.isEnabled = false
            decrementBtn.isEnabled = false
            
            // If button status is false use start function, relabel button and disable reset button
        } else {
            start()
            let stopImage = UIImage(named: "stop.pdf")
            //            startStopLabel.setTitle("STOP", for: .normal)
            startStopLabel.setImage(stopImage, for: .normal)
            refreshButton.isEnabled = false
            incrementBtn.isEnabled = true
            decrementBtn.isEnabled = true
        }
    }
    
    
    @IBAction func refresh(_ sender: Any) {
        /******STOPWATCH REFRESH******/
        refreshChrono()
        /***************************/
        
        /******COUNTER REFRESH******/
        refreshCounter()
        /***************************/
        
        //disabilito il bottone di refresh dopo aver fatto il refresh
        refreshButton.isEnabled = false
    }
    
    
    func start() {
        startTime = Date().timeIntervalSinceReferenceDate - elapsed
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        // Set Start/Stop button to true
        status = true
        
        saveButton.isEnabled = false
    }
    
    
    func stop() {
        elapsed = Date().timeIntervalSinceReferenceDate - startTime
        timer?.invalidate()
        
        // Set Start/Stop button to false
        status = false
        
        saveButton.isEnabled = true
    }
    
    
    func refreshChrono() {
        // Invalidate timer
        timer?.invalidate()
        
        // Reset timer variables
        startTime = 0
        time = 0
        elapsed = 0
        status = false
        
        // Reset all three labels to 00
        let strReset: String = "00"
        labelHour.text = strReset
        labelMinute.text = strReset
        labelSecond.text = strReset
        labelMillisecond.text = strReset
        
        saveButton.isEnabled = false
    }
    
    
    @objc func updateCounter() {
        // Calculate total time since timer started in seconds
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        //Calculate hours
        let hours = UInt8(time / 60.0)
        time -= (TimeInterval(hours) * 60)
        
        // Calculate minutes
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        // Calculate milliseconds
        let milliseconds = UInt8(time * 100)
        
        
        // Format time vars with leading zero
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMilliseconds = String(format: "%02d", milliseconds)
        
        // Add time vars to relevant labels
        labelHour.text = strHours
        labelMinute.text = strMinutes
        labelSecond.text = strSeconds
        labelMillisecond.text = strMilliseconds
        
        let finalTimer: String = strHours + ":" + strMinutes + ":" + strSeconds + ":" + strMilliseconds
        
        globalTimeValue = finalTimer
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
        
        Singleton.shared.chronoSessionValue = Int16(i)
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
        
        
        Singleton.shared.chronoSessionValue = Int16(i)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Title", message: "Enter a title for this session", preferredStyle: .alert)
        
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
            var iValue = Singleton.shared.chronoSessionValue
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let result = formatter.string(from: date)
            let title = field.text!
            
            print("\n\niValue = \(iValue)")
            print("Title = \(title)")
            print("Date = \(result)")
            print("Time = \(self.globalTimeValue)")
            
            CoreDataManager.saveChronoSession(title: title, count: iValue, date: result, time: self.globalTimeValue)
            
            self.refreshCounter()
            self.refreshChrono()
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
        
        //        var iValue = Singleton.shared.normalSessionValue
        //        iValue = Int16(i)
        Singleton.shared.chronoSessionValue = Int16(i)
    }
    
    
    func refreshCounterWithoutVibration() {
        i = Singleton.shared.refresh //i = 0
        numbers.text = "000" + String(i)
        
        Singleton.shared.chronoSessionValue = Int16(i)
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
