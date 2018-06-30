//
//  Singleton.swift
//  CountIT
//
//  Created by Claudio S. Di Mauro on 30/05/18.
//  Copyright © 2018 Claudio S. Di Mauro. All rights reserved.
//

import Foundation

public class Singleton {
    public static let shared = Singleton()
    
    //constants
    let refresh: Int = 0
    
    //variables
    var volume: Float = 1.0 //range: [0.0, 1.0]
    var vibration: Bool = true
    var normalSessionValue: Int16 = 0
    var chronoSessionValue: Int16 = 0
    
    private init() {
    }
}
