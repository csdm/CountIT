//
//  SettingsViewController.swift
//  CountIT
//
//  Created by Claudio S. Di Mauro on 30/05/18.
//  Copyright © 2018 Claudio S. Di Mauro. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    @IBOutlet var volumeSwitch: UISwitch!
    @IBOutlet var vibrationSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Controllo sull'userDefault per vedere se il suono è attivo o meno e a seconda del risultato mostro lo stato dello switch
        Singleton.shared.volume = UserDefaults.standard.float(forKey: "volume")
        if Singleton.shared.volume == 1.0 {
            volumeSwitch.isOn = true
        }
        else {
            volumeSwitch.isOn = false
        }
        
        
        //Controllo sull'userDefault per vedere se la vibrazione è attiva o meno e a seconda del risultato mostro lo stato dello switch
        Singleton.shared.vibration = UserDefaults.standard.bool(forKey: "vibration")
        if Singleton.shared.vibration == true {
            vibrationSwitch.isOn = true
        }
        else {
            vibrationSwitch.isOn = false
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //Quando esco dalla view di setting, devo impostare i valori di volume e vibrazione in base allo stato dello switch. I valori impostati devono essere poi salvati nell'userDefault per tenerne memoria.
        if volumeSwitch.isOn == true {
            Singleton.shared.volume = 1.0
        }
        else {
            Singleton.shared.volume = 0.0
        }
        UserDefaults.standard.set(Singleton.shared.volume, forKey: "volume")
        
        
        if vibrationSwitch.isOn == true {
            Singleton.shared.vibration = true
        }
        else {
            Singleton.shared.vibration = false
        }
        UserDefaults.standard.set(Singleton.shared.vibration, forKey: "vibration")
    }
    
    
    @IBAction func supportPage(_ sender: Any) {
        if let url = URL(string: "https://www.claudiodimauro.it/countIT") {
            UIApplication.shared.open(url)
        }
    }
    

    /* In questo caso non mi servono questi due metodi perché la tableView è statica
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    */
}
