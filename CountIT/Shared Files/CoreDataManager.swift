//
//  CoreDataManager.swift
//  TestCoreData
//
//  Created by Claudio S. Di Mauro on 24/05/18.
//  Copyright © 2018 Claudio S. Di Mauro. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    //-------------Salvataggio NormalSession-------------
    class func saveNormalSession(title: String, count: Int16, date: String) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "NormalSession", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(title, forKey: "title")
        manageObject.setValue(count, forKey: "count")
        manageObject.setValue(date, forKey: "data")
        
        do{
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
    
    
    //-------------Recupero dati NormalSession-------------
    class func fetchNormalSession() -> [NormalSession]? {
        let context = getContext()
        var normalSession:[NormalSession]? = nil
        
        do{
            normalSession = try context.fetch(NormalSession.fetchRequest())
            return normalSession
        }
        catch{
            return normalSession
        }
    }
    
    
    //----------------------//
    //Update dati NormalSession non mi interessa perché non ho bisogno di aggiornare dati
    //----------------------//
    
    
    //-------------Cancellazione dati NormalSession-------------
    class func deleteInCoreData(normalSession: [NormalSession], title: String, count: Int16, date: String) -> Bool {
        let context = getContext()
        
        for ns in normalSession {
            //controllo sul titolo e sul conteggio per la cancellazione
            if ns.title == title && ns.count == count {
                context.delete(ns)
            }
        }
        
        do{
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
    
    
    //-------------Salvataggio ChronoSession-------------
    class func saveChronoSession(title: String, count: Int16, date: String, time: String) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "ChronoSession", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(title, forKey: "title")
        manageObject.setValue(count, forKey: "count")
        manageObject.setValue(date, forKey: "data")
        manageObject.setValue(time, forKey: "time")
        
        do{
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
    
    
    //-------------Recupero dati ChronoSession-------------
    class func fetchChronoSession() -> [ChronoSession]? {
        let context = getContext()
        var chronoSession:[ChronoSession]? = nil
        
        do{
            chronoSession = try context.fetch(ChronoSession.fetchRequest())
            return chronoSession
        }
        catch{
            return chronoSession
        }
    }
    
    
    //----------------------//
    //Update dati ChronoSession non mi interessa perché non ho bisogno di aggiornare dati
    //----------------------//
    
    
    //-------------Cancellazione dati ChronoSession-------------
    class func deleteChronoInCoreData(chronoSession: [ChronoSession], title: String, count: Int16, date: String, time: String) -> Bool {
        let context = getContext()
        
        for cs in chronoSession {
            //controllo sul titolo e sul conteggio per la cancellazione
            if cs.title == title && cs.count == count {
                context.delete(cs)
            }
        }
        
        do{
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
}
